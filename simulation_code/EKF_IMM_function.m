function error=EKF_IMM_function(eta1,eta2)

%  system parameters
I=0.1;m=0.1; k=0.1; b=1; T=0.01;l=0.2;g=9.81;
H=[0,0,1];

% command
len=1000;
t=0:T:(len-1)*T;
theta=10*sin(2*pi*0.2*t);
theta_d=10*2*pi*0.2*cos(2*pi*0.2*t);
theta_dd=-10*2*pi*0.2*2*pi*0.2*sin(2*pi*0.2*t);
theta=theta';theta_d=theta_d';theta_dd=theta_dd';
% transaction matrix
TP=[0.95,0.05;0.3,0.7];
% TP=[0.99,0.01;0.9,0.1];


% initial state
dn=0.5;
X=[0;0;0];
X_last=[0;0;0];
Q1=[eta1*dn*dn,0,0;0,0.0001,0;0,0,0.0001];
Q2=[eta2*dn*dn,0,0;0,0.0001,0;0,0,0.0001];
R=0.0001;
P=2*Q1;
% store the data
S=zeros(len,3);U=zeros(len,5);X_R=zeros(len,3);Y=zeros(len,1);
d=zeros(len,1);
%d(400:600)=40; 
d=20*sign(theta_d)+0.5*theta_d;

% real system
X_r=[0;0;0];
X_rlast=[0;0;0];
u=0;
tic
for i=1:len
    if(i==1)
        x1=X;
        P1=P;
        x2=X;
        P2=P; 
        mu1=0.5;
        mu2=0.5;
    end
    %% raeal state 
    X_rlast=X_r; % real state at k-1
    %% generate state
    [X_r,y]=nonlinearSystemDynamic_dn(I,m,k,b,T,l,X_rlast,u,d(i),dn);     
    % 1: input interaction: c=[mu1 mu2]*T
    c1=TP(1,1)*mu1+TP(2,1)*mu2;
    c2=TP(1,2)*mu1+TP(2,2)*mu2;
    mu11=TP(1,1)*mu1/c1;
    mu12=TP(1,2)*mu1/c2;
    mu21=TP(2,1)*mu2/c1;
    mu22=TP(2,2)*mu2/c2;
    % 2: calculate the initial fusion state vector of model m
    % [x_pre1;x_pre2]=[x1, x2] [mu11 mu12; mu21; mu22]
    x_pre1=x1*mu11+x2*mu21;
    x_pre2=x1*mu12+x2*mu22;
    % 3: calculate the mixed covariance
    P_pre1=mu11*(P1+(x1-x_pre1)*(x1-x_pre1)')+mu21*(P2+(x2-x_pre1)*(x2-x_pre1)');
    P_pre2=mu12*(P1+(x1-x_pre2)*(x1-x_pre2)')+mu22*(P2+(x2-x_pre2)*(x2-x_pre2)');
    % 4: the kalman filter
    % update 1
    x1_=prediction(I,m,k,b,T,l,x_pre1,u);
    F1=[1,0,0;
        T/I, 1-(b)/I*T, -k*T/I-T/I*m*g*l*cos(x_pre1(3));
        0,T,1];
    P1_=F1*P_pre1*F1'+Q1;
    S1=H*P1_*H'+R;
    K1=P1_*H'/S1;
    v1=y-H*x1_;
    x1=x1_+K1*v1;
    % update 2
    x2_=prediction(I,m,k,b,T,l,x_pre2,u);
    F2=[1,0,0;
        T/I, 1-(b)/I*T, -k*T/I-T/I*m*g*l*cos(x_pre2(3));
        0,T,1];
    P2_=F2*P_pre2*F2'+Q2;
    S2=H*P2_*H'+R;
    K2=P2_*H'/S2;
    v2=y-H*x2_;
    x2=x1_+K2*v2;
    % 5 observe the likelihood
    Gamma1=1/sqrt(2*pi*det(S1))*exp(-0.5*v1'*inv(S1)*v1);
    Gamma2=1/sqrt(2*pi*det(S2))*exp(-0.5*v2'*inv(S2)*v2);
    % 6: calculate the filtering covariance matrix
    P1=(eye(3)-K1*H)*P1_*(eye(3)-K1*H)'+K1*R*K1';
    P2=(eye(3)-K2*H)*P2_*(eye(3)-K2*H)'+K2*R*K2';
    % 7: update the model probability
    c= Gamma1*c1+Gamma2*c2;
    mu1= Gamma1*c1/c;
    mu2= Gamma2*c2/c;
    % 8: output interaction
    x=mu1*x1+mu2*x2;
    % 9: interact the error covariance matrix
    P=mu1*(P1+(x1-x)*(x1-x)')+mu2*(P2+(x2-x)*(x2-x)');
    
    %% control
    u1=I*theta_dd(i)+b*theta_d(i)+k*theta_d(i)+m*g*l*sin(x(3));
    u2=-x(1);
    kp=100;kd=10;
    u3=kp*(theta(i)-x(3));
    u4=kd*(theta_d(i)-x(2));
    u=u1+u2+u3+u4;
   
    muv=[mu1;mu2];
    %% data
    S(i,:)=x';
    U(i,:)=[u1,u2,u3,u4,u];
    X_R(i,:)=X_r;
    Y(i)=y;
    MU(:,i)=muv';

end

error.time=toc;
error.de=S(:,1)-X_R(:,1);
error.ve=S(:,2)-X_R(:,2);
error.pe=S(:,3)-X_R(:,3);
error.p_d=theta;
error.v_d=theta_d;
error.p_err=theta-X_R(:,3);
error.v_err=theta_d-X_R(:,2);
error.d_err=d-X_R(:,1);
error.u=U(:,5);

error.p_err_rms=rms(error.p_err);
error.v_err_rms=rms(error.v_err);
error.d_err_rms=rms(error.de);
error.s1_err_rms=rms(error.ve);
error.s2_err_rms=rms(error.pe);
error.time_mean=mean(error.time);
error.time_std=std(error.time);
error.theta=theta;
error.theta_d=theta_d;
error.S=S; % state
error.U=U; % input
error.X_R=X_R; % real state
error.MU=MU;


end
