function error=MKEKF_DOB_function(eta)


I=0.1;m=0.1; k=0.1; b=1; T=0.01;l=0.2;g=9.81;
H=[0,0,1];

len=1000;
t=0:T:(len-1)*T;
theta=10*sin(2*pi*0.2*t);
theta_d=10*2*pi*0.2*cos(2*pi*0.2*t);
theta_dd=-10*2*pi*0.2*2*pi*0.2*sin(2*pi*0.2*t);
theta=theta';theta_d=theta_d';theta_dd=theta_dd';



% initial state
dn=0.5;
X=[0;0;0];
X_last=[0;0;0];
Q=[eta*dn*dn,0,0;0,0.0001,0;0,0,0.0001];
R=0.0001;
P=2*Q;
S=zeros(len,3);U=zeros(len,5);X_R=zeros(len,3);Y=zeros(len,1);

d=zeros(len,1);
%d(400:600)=40;
d=20*sign(theta_d)+0.5*theta_d;

% real system
X_r=[0;0;0];
X_rlast=[0;0;0];
u=0;

sigma_p=[1.2 100000000 100000000]'; % 1.0/sqrt(2)
tic
for i=1:len
    %% real system 
    X_rlast=X_r;
    %X_last=X;
    %% generate state
    [X_r,y]=nonlinearSystemDynamic_dn(I,m,k,b,T,l,X_rlast,u,d(i),dn);
    %%
    % state prediction 
    X_=prediction(I,m,k,b,T,l,X,u);
    % prediction covariance
    gra1  = zeros(3,3);
    gra1=[1,0,0;
        T/I, 1-(b)/I*T, -k*T/I-T/I*m*g*l*cos(X(3));
        0,T,1];
    Phi=gra1;
    P_=Phi*P*Phi'+Q;
    %%
    cnt=3;
    num=3;
    bp = chol(P_,'lower') ;
    dp= bp\X_;
    while(num>0)
        % 
        if(num==cnt)
          X_tlast=X_; 
        else  
          X_tlast=X_t; 
        end
        wp= bp\X_tlast;
        ep=dp-wp;
        % 
        if(num==cnt)
            Cx_array=[1,1,1];
        else  
            Cx_array=(exp(-ep.*ep./(2*sigma_p.*sigma_p)));
        end
        for kk=1:3
            if(Cx_array(kk)<0.00001)
                Cx_array(kk)=0.00001;
                num=1;
            end
        end
        Cx=diag(Cx_array);
        
        P_1=bp/Cx*bp';
        K_1=P_1*H'/(H*P_1*H'+R);
        
        X_t=X_+K_1*(y-H*X_); 
        num=num-1;       
        %xe(cnt-num,i)=norm(X_t-X_tlast)/(norm(X_tlast));  
        xee=norm(X_t-X_tlast)/(norm(X_tlast));  
        if(xee<0.02)
            break
        end
    end 
        %P=(eye(3)-K_1*H)*P_1;
        temp=eye(3)-K_1*H;
        P= temp*P_*temp'+K_1*R*K_1';
        X=X_t;
        S(i,:)=X';
        %Trace(i)=trace(P_1);
        %ER(i,:)=ep;
        
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


end