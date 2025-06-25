function algorithm_bais_variance()

clear all

len=1000;
cnt=100;
num=16;
for j=1:cnt
    for m=1:num
        eta=exp((m-1)/3);
        err(j,m)=EKF_DOB_function(eta);
    end
% IMMEKF-DOB
eta1=exp(0);
eta2=exp(4);
immerr(j)=EKF_IMM_function(eta1,eta2);
% MKCEKF-DOB
eta=exp(0);
mkcerr(j)=MKEKF_DOB_function(eta);
end

%
clear biasvar immbiasvar mkcbiasvar
de=zeros(cnt,1);
deimm=zeros(cnt,1);
demkc=zeros(cnt,1);
for i=1:len
    for j=1:num
            for k=1:cnt
                de(k)=err(k,j).de(i);
            end
        biasvar{j}.bias(i,:)=mean(de);
        biasvar{j}.std(i,:)=std(de);
    end
    for k=1:cnt
        deimm(k)=immerr(k).de(i);
        demkc(k)=mkcerr(k).de(i);
    end
    immbiasvar.bias(i,:)=mean(deimm);
    immbiasvar.std(i,:)=std(deimm);
    mkcbiasvar.bias(i,:)=mean(demkc);
    mkcbiasvar.std(i,:)=std(demkc);
end

%
len=1000; 
T=0.01;
t=0:T:(len-1)*T;

t1=[t,fliplr(t)];
statefl1=biasvar{1}.bias(:,1)-1.96*biasvar{1}.std(:,1);
statefh1=biasvar{1}.bias(:,1)+1.96*biasvar{1}.std(:,1);
inbew_s1=[statefl1',fliplr(statefh1')]; 

mkcstatefl1=mkcbiasvar.bias-1.96*mkcbiasvar.std;
mkcstatefh1=mkcbiasvar.bias+1.96*mkcbiasvar.std;
mkcinbew_s1=[mkcstatefl1',fliplr(mkcstatefh1')]; 

immstatefl1=immbiasvar.bias-1.96*immbiasvar.std;
immstatefh1=immbiasvar.bias+1.96*immbiasvar.std;
imminbew_s1=[immstatefl1',fliplr(immstatefh1')]; 

% 95% interval
figure;
box on
hold on;
fill([t'; flipud(t')], [biasvar{1}.bias(:,1) - 1.96*biasvar{1}.std(:,1); flipud(biasvar{1}.bias(:,1) + 1.96*biasvar{1}.std(:,1))], 'k', 'FaceAlpha', 0.3,'Edgecolor','k');
plot(t,biasvar{1}.bias(:,1),'LineWidth',1,'color','black');

fill([t'; flipud(t')], [mkcbiasvar.bias(:,1) - 1.96*mkcbiasvar.std; flipud(mkcbiasvar.bias(:,1) + 1.96*mkcbiasvar.std)], 'g', 'FaceAlpha', 0.1,'Edgecolor','k');
plot(t,mkcbiasvar.bias(:,1),'LineWidth',1,'color','red');

fill([t'; flipud(t')], [immbiasvar.bias - 1.96*immbiasvar.std; flipud(immbiasvar.bias + 1.96*immbiasvar.std)], 'cyan', 'FaceAlpha', 0.1,'Edgecolor','k');
plot(t,immbiasvar.bias(:,1),'LineWidth',1,'color','blue');

lg=legend('EKF-DOB $\eta=\exp(0)$ $1.96\sigma_{d,k}$','EKF-DOB $\eta=\exp(0)$ $b_{d,k}$',...
    'MKCKF-DOB $1.96\sigma_{d,k}$','MKCKF-DOB $b_{d,k}$',...
    'IMMKF-DOB $1.96\sigma_{d,k}$','IMMKF-DOB $b_{d,k}$','interpreter','latex','fontsize',13);
set(gcf,'Position',[100 100 700 600]);
xlim([3.5,4.6])
xlabel('time (s)','interpreter','latex')
ylabel('dist error','interpreter','latex')
set(gca,'fontsize',16)




figure
box on
hold on
patch(t1,inbew_s1,'m','FaceAlpha',0.4,'Edgecolor','none')
legend('off')
plot(t,biasvar{1}.bias(:,1),'LineWidth',0.8,'color','black');

patch(t1,mkcinbew_s1,'g','FaceAlpha',0.2,'Edgecolor','none')
legend('off')
plot(t,mkcbiasvar.bias(:,1),'LineWidth',0.8,'color','red');

patch(t1,imminbew_s1,'cyan','FaceAlpha',0.2,'Edgecolor','none')
legend('off')
plot(t,immbiasvar.bias(:,1),'LineWidth',0.8,'color','blue');
lg=legend('EKF-DOB $\eta=\exp(0)$ $\pm 1.96\sigma_{d,k}$','EKF-DOB $\eta=\exp(0)$ $b_{d,k}$',...
    'MKCKF-DOB $\pm 1.96\sigma_{d,k}$','MKCKF-DOB $b_{d,k}$',...
    'IMMKF-DOB $\pm 1.96\sigma_{d,k}$','IMMKF-DOB $b_{d,k}$','interpreter','latex','fontsize',13);
set(gcf,'Position',[100 100 700 600]);
xlim([3.5,4.6])
xlabel('time (s)','interpreter','latex')
ylabel('disturbance error','interpreter','latex')
set(gca,'fontsize',16)

%
biasvarmkc=mkcbiasvar;
biasvarimm=immbiasvar;

seg=300:450;
%seg=250:750;
lenseg=length(seg);
for item=1:num
% kf-dob
biasvar{item}.bias_seg=mean(biasvar{item}.bias(seg,:));
biasvar{item}.std_seg=mean(biasvar{item}.std(seg,:));
bias_seg_square(item,:)=biasvar{item}.bias_seg.^2;
var_seg(item,:)=biasvar{item}.std_seg.^2;
end
% mkckf-dob
biasvarmkc.bias_seg=mean(biasvarmkc.bias(seg,:));
biasvarmkc.std_seg=mean(biasvarmkc.std(seg,:));
bias_seg_squaremkc(:)=biasvarmkc.bias_seg.^2;
var_segmkc(:)=biasvarmkc.std_seg.^2;
% immkf-dob
biasvarimm.bias_seg=mean(biasvarimm.bias(seg,:));
biasvarimm.std_seg=mean(biasvarimm.std(seg,:));
bias_seg_squareimm(:)=biasvarimm.bias_seg.^2;
var_segimm(:)=biasvarimm.std_seg.^2;




itemlen=num;
ETA=((1:itemlen)-1)/3;
figure
hold on
box on
plot(ETA,bias_seg_square(:,1),'Color','red','LineWidth',1.0)
plot(ETA,var_seg(:,1),'Color','black','LineWidth',1.0)
legend('bias$^{2}$','variance','interpreter','latex')
xlabel('$\log(\eta)$','interpreter','latex')
ylabel('value','interpreter','latex')
title('Bais-variance of $\hat{d}_k$ in KF-DOB','interpreter','latex')
set(gca,'fontsize',16)
set(gcf,'Position',[100 100 700 600]);
xlim([0,5])


%
figure 
hold on
box on
plot(ETA,bias_seg_square(:,1),'Color','red','LineWidth',1.5,'LineStyle','--')
plot(ETA,var_seg(:,1),'Color','black','LineWidth',1.5,'LineStyle','--')
plot(ETA,bias_seg_square(:,1)+var_seg(:,1),'Color','black','LineWidth',2.0,'LineStyle','-')
plot(ETA(1:end),(bias_seg_squaremkc(1:end,1)+var_segmkc(1:end,1))*ones(1,16),'Color','red','LineWidth',2.0,'Marker','+')
plot(ETA(1:end),(bias_seg_squareimm(1:end,1)+var_segimm(1:end,1))*ones(1,16),'Color',[0.4660 0.6740 0.1880],'LineWidth',2.0,'Marker','square')
lg=legend('EKF-DOB bias$^{2}$','EKF-DOB variance','EKF-DOB bias$^{2}$+variance',...
    'MKCEKF-DOB bias$^{2}$+variance','IMMEKF-DOB bias$^{2}$+variance','interpreter','latex');
set(lg,'fontsize',12)
set(gca,'fontsize',16)
xlabel('$\log(\eta)$','interpreter','latex')
ylabel('value','interpreter','latex')
ylim([0,18])
set(gcf,'Position',[100 100 700 600]);



end
