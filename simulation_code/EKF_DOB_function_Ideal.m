function error=EKF_DOB_function_Ideal(eta)

%
%  system dynamics
I=0.1;m=0.1; k=0.1; b=1; T=0.01;l=0.2;g=9.81;
% Phi=[1,0,0; T/m, 1- b/m*T, -k/m*T; 0, T, 1];
% F=[0;T/m;0];
H=[0,0,1];

len=1000;
t=0:T:(len-1)*T;
theta=10*sin(2*pi*0.2*t);
theta_d=10*2*pi*0.2*cos(2*pi*0.2*t);
theta_dd=-10*2*pi*0.2*2*pi*0.2*sin(2*pi*0.2*t);
theta=theta';theta_d=theta_d';theta_dd=theta_dd';

% friction_d=20*sign(theta_d)+0.2*theta_d;
% plot(friction_d)

% initial state
dn=0.5;
X=[0;0;0];
X_last=[0;0;0];
Q=[eta*dn^2,0,0;0,0.0001,0;0,0,0.0001];
R=0.0001;
P=2*Q;
% store the data
S=zeros(len,3);U=zeros(len,5);X_R=zeros(len,3);Y=zeros(len,1);
%change this to friction 20sgn(\dot{\theta})+1\dot{\theta}
%d(400:600)=40; 
d=20*sign(theta_d)+0.5*theta_d;
% real system
X_r=[0;0;0];
X_rlast=[0;0;0];
u=0;


tic
for i=1:len
    %% state 
    X_rlast=X_r; % real state at k-1
    %X_last=X;    % estimated state at k-1
    %u_last=u;    % control output
    %% generate state
    [X_r,y]=nonlinearSystemDynamic_dn(I,m,k,b,T,l,X_rlast,u,d(i),dn);
    %% estimate
    % prediction 
    %X_=Phi*X+F*u;
    X_=prediction(I,m,k,b,T,l,X,u);
   
    Phi=[1,0,0;
        T/I, 1-(b)/I*T, -k*T/I-T/I*m*g*l*cos(X(3));
        0,T,1];
    % prediction covariance
    if(i>1)
        Q=[(dn^2+(d(i)-d(i-1))^2),0,0;0,0.0001,0;0,0,0.0001];
    else
        Q=[(dn^2),0,0;0,0.0001,0;0,0,0.0001];
    end

    P_=Phi*P*Phi'+Q;
    %%
    K=P_*H'/(H*P_*H'+R);
    P=(eye(3)-K*H)*P_;
    X=X_+K*(y-H*X_);
    %% control
    u1=I*theta_dd(i)+b*theta_d(i)+k*theta_d(i)+m*g*l*sin(X(3));
    u2=-X(1);
    kp=100;kd=10;
    u3=kp*(theta(i)-X(3));
    u4=kd*(theta_d(i)-X(2));
    u=u1+u2+u3+u4;
    %% data
     S(i,:)=X';
     U(i,:)=[u1,u2,u3,u4,u];
     X_R(i,:)=X_r;
     Y(i)=y;
     Qd(i)=Q(1,1);
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
error.Qd=Qd;

end