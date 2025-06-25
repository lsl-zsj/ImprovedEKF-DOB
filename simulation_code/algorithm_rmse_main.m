function algorithm_rmse_main()

%
clear all
% EKF-DOB
for j=1:100
eta=exp(0);
err0(j)=EKF_DOB_function(eta);
eta=exp(1);
err1(j)=EKF_DOB_function(eta);
eta=exp(2);
err2(j)=EKF_DOB_function(eta);
eta=exp(3);
err3(j)=EKF_DOB_function(eta);
eta=exp(4);
err4(j)=EKF_DOB_function(eta);

eta=exp(100);
err40(j)=EKF_DOB_function(eta);

eta=exp(0);
errideal(j)=EKF_DOB_function_Ideal(eta);
% IMMEKF-DOB
eta1=exp(0);
eta2=exp(5);
immerr(j)=EKF_IMM_function(eta1,eta2);
% MKCEKF-DOB
eta=exp(0);
mkcerr(j)=MKEKF_DOB_function(eta);
end


% statistics
ERR0.time_mean=mean([err0(2:end).time]);
ERR0.time_std=std([err0(2:end).time]);
ERR0.p_mean=mean([err0.p_err_rms]);   %p
ERR0.p_std=std([err0.p_err_rms]);     %p
ERR0.v_mean=mean([err0.v_err_rms]);   %v
ERR0.v_std=std([err0.v_err_rms]);     %v
ERR0.d_mean=mean([err0.d_err_rms]);   %d
ERR0.d_std=std([err0.d_err_rms]);     %d
ERR0.xe1_mean=mean([err0.s1_err_rms]);%s1
ERR0.xe1_std=std([err0.s1_err_rms]);  %s1
ERR0.xe2_mean=mean([err0.s2_err_rms]);%s2
ERR0.xe2_std=std([err0.s2_err_rms]);  %s2


ERR1.time_mean=mean([err1(2:end).time]);
ERR1.time_std=std([err1(2:end).time]);
ERR1.p_mean=mean([err1.p_err_rms]);   %p
ERR1.p_std=std([err1.p_err_rms]);     %p
ERR1.v_mean=mean([err1.v_err_rms]);   %v
ERR1.v_std=std([err1.v_err_rms]);     %v
ERR1.d_mean=mean([err1.d_err_rms]);   %d
ERR1.d_std=std([err1.d_err_rms]);     %d
ERR1.xe1_mean=mean([err1.s1_err_rms]);%s1
ERR1.xe1_std=std([err1.s1_err_rms]);  %s1
ERR1.xe2_mean=mean([err1.s2_err_rms]);%s2
ERR1.xe2_std=std([err1.s2_err_rms]);  %s2


ERR2.time_mean=mean([err2(2:end).time]);
ERR2.time_std=std([err2(2:end).time]);
ERR2.p_mean=mean([err2.p_err_rms]);   %p
ERR2.p_std=std([err2.p_err_rms]);     %p
ERR2.v_mean=mean([err2.v_err_rms]);   %v
ERR2.v_std=std([err2.v_err_rms]);     %v
ERR2.d_mean=mean([err2.d_err_rms]);   %d
ERR2.d_std=std([err2.d_err_rms]);     %d
ERR2.xe1_mean=mean([err2.s1_err_rms]);%s1
ERR2.xe1_std=std([err2.s1_err_rms]);  %s1
ERR2.xe2_mean=mean([err2.s2_err_rms]);%s2
ERR2.xe2_std=std([err2.s2_err_rms]);  %s2


ERR3.time_mean=mean([err3(2:end).time]);
ERR3.time_std=std([err3(2:end).time]);
ERR3.p_mean=mean([err3.p_err_rms]);   %p
ERR3.p_std=std([err3.p_err_rms]);     %p
ERR3.v_mean=mean([err3.v_err_rms]);   %v
ERR3.v_std=std([err3.v_err_rms]);     %v
ERR3.d_mean=mean([err3.d_err_rms]);   %d
ERR3.d_std=std([err3.d_err_rms]);     %d
ERR3.xe1_mean=mean([err3.s1_err_rms]);%s1
ERR3.xe1_std=std([err3.s1_err_rms]);  %s1
ERR3.xe2_mean=mean([err3.s2_err_rms]);%s2
ERR3.xe2_std=std([err3.s2_err_rms]);  %s2


ERR4.time_mean=mean([err4(2:end).time]);
ERR4.time_std=std([err4(2:end).time]);
ERR4.p_mean=mean([err4.p_err_rms]);   %p
ERR4.p_std=std([err4.p_err_rms]);     %p
ERR4.v_mean=mean([err4.v_err_rms]);   %v
ERR4.v_std=std([err4.v_err_rms]);     %v
ERR4.d_mean=mean([err4.d_err_rms]);   %d
ERR4.d_std=std([err4.d_err_rms]);     %d
ERR4.xe1_mean=mean([err4.s1_err_rms]);%s1
ERR4.xe1_std=std([err4.s1_err_rms]);  %s1
ERR4.xe2_mean=mean([err4.s2_err_rms]);%s2
ERR4.xe2_std=std([err4.s2_err_rms]);  %s2

ERR40.time_mean=mean([err40(2:end).time]);
ERR40.time_std=std([err40(2:end).time]);
ERR40.p_mean=mean([err40.p_err_rms]);   %p
ERR40.p_std=std([err40.p_err_rms]);     %p
ERR40.v_mean=mean([err40.v_err_rms]);   %v
ERR40.v_std=std([err40.v_err_rms]);     %v
ERR40.d_mean=mean([err40.d_err_rms]);   %d
ERR40.d_std=std([err40.d_err_rms]);     %d
ERR40.xe1_mean=mean([err40.s1_err_rms]);%s1
ERR40.xe1_std=std([err40.s1_err_rms]);  %s1
ERR40.xe2_mean=mean([err40.s2_err_rms]);%s2
ERR40.xe2_std=std([err40.s2_err_rms]);  %s2

ERRI.time_mean=mean([errideal(2:end).time]);
ERRI.time_std=std([errideal(2:end).time]);
ERRI.p_mean=mean([errideal.p_err_rms]);   %p
ERRI.p_std=std([errideal.p_err_rms]);     %p
ERRI.v_mean=mean([errideal.v_err_rms]);   %v
ERRI.v_std=std([errideal.v_err_rms]);     %v
ERRI.d_mean=mean([errideal.d_err_rms]);   %d
ERRI.d_std=std([errideal.d_err_rms]);     %d
ERRI.xe1_mean=mean([errideal.s1_err_rms]);%s1
ERRI.xe1_std=std([errideal.s1_err_rms]);  %s1
ERRI.xe2_mean=mean([errideal.s2_err_rms]);%s2
ERRI.xe2_std=std([errideal.s2_err_rms]);  %s2

IMMERR.time_mean=mean([immerr(2:end).time]);
IMMERR.time_std=std([immerr(2:end).time]);
IMMERR.p_mean=mean([immerr.p_err_rms]);   %p
IMMERR.p_std=std([immerr.p_err_rms]);     %p
IMMERR.v_mean=mean([immerr.v_err_rms]);   %v
IMMERR.v_std=std([immerr.v_err_rms]);     %v
IMMERR.d_mean=mean([immerr.d_err_rms]);   %d
IMMERR.d_std=std([immerr.d_err_rms]);     %d
IMMERR.xe1_mean=mean([immerr.s1_err_rms]);%s1
IMMERR.xe1_std=std([immerr.s1_err_rms]);  %s1
IMMERR.xe2_mean=mean([immerr.s2_err_rms]);%s2
IMMERR.xe2_std=std([immerr.s2_err_rms]);  %s2

MKCERR.time_mean=mean([mkcerr(2:end).time]);
MKCERR.time_std=std([mkcerr(2:end).time]);
MKCERR.p_mean=mean([mkcerr.p_err_rms]);   %p
MKCERR.p_std=std([mkcerr.p_err_rms]);     %p
MKCERR.v_mean=mean([mkcerr.v_err_rms]);   %v
MKCERR.v_std=std([mkcerr.v_err_rms]);     %v
MKCERR.d_mean=mean([mkcerr.d_err_rms]);   %d
MKCERR.d_std=std([mkcerr.d_err_rms]);     %d
MKCERR.xe1_mean=mean([mkcerr.s1_err_rms]);%s1
MKCERR.xe1_std=std([mkcerr.s1_err_rms]);  %s1
MKCERR.xe2_mean=mean([mkcerr.s2_err_rms]);%s2
MKCERR.xe2_std=std([mkcerr.s2_err_rms]);  %s2

fprintf('EKFDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    ERR0.d_mean,ERR0.d_std,ERR0.xe1_mean,ERR0.xe1_std,ERR0.xe2_mean,ERR0.xe2_std,...
    ERR0.p_mean,ERR0.p_std,ERR0.v_mean,ERR0.v_std,ERR0.time_mean,ERR0.time_std)

fprintf('EKFDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    ERR1.d_mean,ERR1.d_std,ERR1.xe1_mean,ERR1.xe1_std,ERR1.xe2_mean,ERR1.xe2_std,...
    ERR1.p_mean,ERR1.p_std,ERR1.v_mean,ERR1.v_std,ERR1.time_mean,ERR1.time_std)

fprintf('EKFDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    ERR2.d_mean,ERR2.d_std,ERR2.xe1_mean,ERR2.xe1_std,ERR2.xe2_mean,ERR2.xe2_std,...
    ERR2.p_mean,ERR2.p_std,ERR2.v_mean,ERR2.v_std,ERR2.time_mean,ERR2.time_std)

fprintf('EKFDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    ERR3.d_mean,ERR3.d_std,ERR3.xe1_mean,ERR3.xe1_std,ERR3.xe2_mean,ERR3.xe2_std,...
    ERR3.p_mean,ERR3.p_std,ERR3.v_mean,ERR3.v_std,ERR3.time_mean,ERR3.time_std)

fprintf('EKFDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    ERR4.d_mean,ERR4.d_std,ERR4.xe1_mean,ERR4.xe1_std,ERR4.xe2_mean,ERR4.xe2_std,...
    ERR4.p_mean,ERR4.p_std,ERR4.v_mean,ERR4.v_std,ERR4.time_mean,ERR4.time_std)

fprintf('EKFDOB40: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    ERR40.d_mean,ERR40.d_std,ERR40.xe1_mean,ERR40.xe1_std,ERR40.xe2_mean,ERR40.xe2_std,...
    ERR40.p_mean,ERR40.p_std,ERR40.v_mean,ERR40.v_std,ERR40.time_mean,ERR40.time_std)


fprintf('IMMEDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    IMMERR.d_mean,IMMERR.d_std,IMMERR.xe1_mean,IMMERR.xe1_std,IMMERR.xe2_mean,IMMERR.xe2_std,...
    IMMERR.p_mean,IMMERR.p_std,IMMERR.v_mean,IMMERR.v_std,IMMERR.time_mean,IMMERR.time_std)

fprintf('MKCEDOB: %.3f ± %.3f & %.3f ± %.3f & %.4f ± %.4f&%.3f ± %.4f& %.3f ± %.3f & %.4f ± %.3f \n',...
    MKCERR.d_mean,MKCERR.d_std,MKCERR.xe1_mean,MKCERR.xe1_std,MKCERR.xe2_mean,MKCERR.xe2_std,...
    MKCERR.p_mean,MKCERR.p_std,MKCERR.v_mean,MKCERR.v_std,MKCERR.time_mean,MKCERR.time_std)

%% figure plot
len=1000;
% noise free disturbance
% d=zeros(len,1);
% d(400:600)=40; 
T=0.01;
t=0:T:(len-1)*T;
theta=10*sin(2*pi*0.2*t);
theta_d=10*2*pi*0.2*cos(2*pi*0.2*t);
theta_dd=-10*2*pi*0.2*2*pi*0.2*sin(2*pi*0.2*t);
theta=theta';theta_d=theta_d';theta_dd=theta_dd';
d=20*sign(theta_d)+0.5*theta_d;

% friction_d=20*sign(theta_d)+0.5*theta_d;
% plot(friction_d)

figure
x1=subplot(2,1,1);
box on
plot(t,d,'color',[0.8500 0.3250 0.0980],'LineWidth',1.5,'color','black')
hold on
plot(t,err0(1).S(:,1),'blue','LineWidth',0.8)
%plot(t,err1(1).S(:,1))
plot(t,err2(1).S(:,1),'red','LineWidth',0.8)
%plot(t,err3(1).S(:,1))
plot(t,err4(1).S(:,1),'m','LineWidth',0.8)
plot(t,immerr(1).S(:,1),'cyan','LineWidth',0.8)
plot(t,mkcerr(1).S(:,1),'color',[0.4660 0.6740 0.1880],'LineWidth',1.2)
xticks([])
set(gca,'fontsize',16)
ylabel('disturbance','interpreter','latex')
lg=legend('noiseless $d_k$','EKF($\eta=\exp(0)$)','EKF($\eta=\exp(2)$)','EKF($\eta=\exp(4)$)', ...
    'IMMEKF','MKCEKF','interpreter','latex','NumColumns',3);
set(lg,'fontsize',14);
x2=subplot(2,1,2);
hold on
box on
%plot(t,err0(1).p_d)
plot(t,err0(1).p_d-err0(1).X_R(:,3),'blue','LineWidth',0.8)
plot(t,err2(1).p_d-err2(1).X_R(:,3),'red','LineWidth',0.8)
plot(t,err4(1).p_d-err4(1).X_R(:,3),'m','LineWidth',0.8)
plot(t,immerr(1).p_d-immerr(1).X_R(:,3),'cyan','LineWidth',0.8)
plot(t,mkcerr(1).p_d-mkcerr(1).X_R(:,3),'color',[0.4660 0.6740 0.1880],'LineWidth',1.2)
linkaxes([x1,x2],'x')
xlim([3,7])
set(gca,'fontsize',16)
xlabel('time (s)','interpreter','latex')
ylabel('angle error','interpreter','latex')
set(gcf,'Position',[100 100 700 600]);
% lg=legend('EKF-DOB($\eta=\exp(0)$)','EKF-DOB($\eta=\exp(2)$)','EKF-DOB($\eta=\exp(4)$)', ...
%    'IMMEKF-DOB','MKCEKF-DOB','interpreter','latex');
% set(lg,'fontsize',12);



figure
x1=subplot(2,1,1);
box on
plot(t,d,'color',[0.8500 0.3250 0.0980],'LineWidth',1.5,'color','black')
hold on
plot(t,err40(1).S(:,1),'m','LineWidth',0.8)
xticks([])
set(gca,'fontsize',16)
ylabel('disturbance','interpreter','latex')
lg=legend('noiseless $d_k$','EKF($\eta=\exp(40)$)', ...
    'IMMEKF','MKCEKF','interpreter','latex','NumColumns',3);
set(lg,'fontsize',14);
x2=subplot(2,1,2);
hold on
box on
plot(t,err40(1).p_d-err40(1).X_R(:,3),'m','LineWidth',0.8)
linkaxes([x1,x2],'x')
xlim([3,7])
set(gca,'fontsize',16)
xlabel('time (s)','interpreter','latex')
ylabel('angle error','interpreter','latex')
set(gcf,'Position',[100 100 700 600]);




figure
x1=subplot(2,1,1);
box on
plot(t,d,'color',[0.8500 0.3250 0.0980],'LineWidth',1.5,'color','black')
hold on
plot(t,errideal(1).S(:,1),'m','LineWidth',0.8)
plot(t,immerr(1).S(:,1),'cyan','LineWidth',0.8)
plot(t,mkcerr(1).S(:,1),'color',[0.4660 0.6740 0.1880],'LineWidth',1.2)
plot(t,err0(1).S(:,1),'blue','LineWidth',0.8)
xticks([])
set(gca,'fontsize',16)
ylabel('disturbance','interpreter','latex')
lg=legend('noiseless $d_k$','EKF(Ideal)', ...
    'IMMEKF','MKCEKF','EKF','interpreter','latex','NumColumns',3);
set(lg,'fontsize',14);
x2=subplot(2,1,2);
hold on
box on
plot(t,err40(1).p_d-errideal(1).X_R(:,3),'m','LineWidth',0.8)
plot(t,immerr(1).p_d-immerr(1).X_R(:,3),'cyan','LineWidth',0.8)
plot(t,mkcerr(1).p_d-mkcerr(1).X_R(:,3),'color',[0.4660 0.6740 0.1880],'LineWidth',1.2)
plot(t,err0(1).p_d-err0(1).X_R(:,3),'blue','LineWidth',0.8)
linkaxes([x1,x2],'x')
xlim([3,7])
set(gca,'fontsize',16)
xlabel('time (s)','interpreter','latex')
ylabel('angle error','interpreter','latex')
set(gcf,'Position',[100 100 700 600]);




end