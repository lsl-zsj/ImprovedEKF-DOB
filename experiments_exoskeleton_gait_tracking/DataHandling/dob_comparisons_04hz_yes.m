function dob_comparisons_04hz_yes()

clear all
clc
addpath(genpath('..\DataStoreSISE'));

% f=0.1 cc=8 vardtimes=1
f_gait=0.4;
hz=[num2str(f_gait*100)];

dob{1}=load('40hznodob');     % 1 nodob
dob{2}=load('40hzmkekf_1');   % 2 mkcekf
dob{3}=load('40hzimm_1');     % 3 immkf
dob{4}=load('40hzckf_1');     % 4 cekf
dob{5}=load('40hzekf_1');     % 5 ekf
dob{6}=load('40hzdob_8');     % 6 ndob

%% smoother bandwidth
smc = designfilt('lowpassiir','FilterOrder',12, ...
    'HalfPowerFrequency',0.2,'DesignMethod','butter');

%% performance comparison 3002:end
index=3002:33002;
dt=0.001;
t=0:dt:dt*(length(index)-1);
dobd=[];
dobm=[];
for i=1:6
    dobd{i}.q=dob{i}.rlt.q(index,:); % q
    dobd{i}.dq=dob{i}.rlt.dq(index,:); % dq
    dobd{i}.ddq=dob{i}.rlt.ddq(index,:); % ddq
    dobd{i}.qe=dob{i}.rlt.qe(index,:); % qe
    dobd{i}.dqe=dob{i}.rlt.dqe(index,:); % dqe
    dobd{i}.ndob=dob{i}.rlt.dist(index,3:4); % ndoe
    dobd{i}.mkcekf=dob{i}.rlt.mkekfxk(index,:); % mkcekf
    dobd{i}.immekf=dob{i}.rlt.immxk(index,:); % immkf
    dobd{i}.cekf=dob{i}.rlt.cxk(index,:); % cekf
    dobd{i}.ekf=dob{i}.rlt.ekfxk(index,:); % ekf
    %dobd{i}.mu=dob{i}.rlt.mu(index,:); % mu
    dobd{i}.tor=dob{i}.rlt.tor(index,:); % tor
    %% 
    torhips = filtfilt(smc,dobd{i}.tor(:,1));
    torknees = filtfilt(smc,dobd{i}.tor(:,2));
    dobd{i}.tors=[torhips,torknees];
    %
    dobd{i}.cmd=dob{i}.rlt.cmd(index,:); % tor
    torhips = filtfilt(smc,dobd{i}.cmd(:,1));
    torknees = filtfilt(smc,dobd{i}.cmd(:,2));
    dobd{i}.cmds=[torhips,torknees];

    %% metric
    tore=dobd{i}.tor-dobd{i}.tors;
    dobm{i}.qe_rms=[rms(dobd{i}.qe(:,1));rms(dobd{i}.qe(:,2))];
    dobm{i}.dqe_rms=[rms(dobd{i}.dqe(:,1));rms(dobd{i}.dqe(:,2))];
    dobm{i}.tors_rms=[rms(tore(:,1));rms(tore(:,2))];
    % snr
    hipsnr=snr(dobd{i}.tors(:,1),tore(:,1));
    kneesnr=snr(dobd{i}.tors(:,1),tore(:,2));
    dobm{i}.snr=[hipsnr,kneesnr];
    % snr 1
    tore=dobd{i}.cmds-dobd{i}.cmd;
    hipsnr=snr(dobd{i}.cmds(:,1),tore(:,1));
    kneesnr=snr(dobd{i}.cmds(:,1),tore(:,2));
    dobm{i}.snr1=[hipsnr,kneesnr];
end


figure
x1=subplot(2,1,1);
box on
hold on
plot(t,dobd{2}.cmd(:,1),'LineWidth',1,'Color','black')
plot(t,dobd{2}.cmds(:,1),'LineWidth',1,'Color','red');
legend('command torque','desired torque','intepreter','latex','Orientation','horizontal')
set(gca,'fontsize',16)
ylabel('Hip (Nm)','Interpreter','latex')
xticks([])
x2=subplot(2,1,2);
box on
hold on
plot(t,dobd{2}.cmd(:,2),'LineWidth',1,'Color','black')
plot(t,dobd{2}.cmds(:,2),'LineWidth',1,'Color','red');
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
ylabel('Knee (Nm)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([5,25])

%% hip and knee native disturbance
dq=dobd{3}.dq;
ddq(:,1)=gradient(dq(:,1))*1000;
ddq(:,2)=gradient(dq(:,2))*1000;
naivedob=native_disturbance_observer(dobd{3}.q,dobd{3}.dq,ddq,dobd{3}.tor);
%% angle
figure
x1=subplot(2,1,1);
box on
% plot(t,10*sign(dobd{3}.dq(:,1)));
plot(t,dobd{3}.q(:,1),'LineWidth',1,'Color','black');
legend('hip','intepreter','latex','Orientation','horizontal')
set(gca,'fontsize',16)
xticks([])
x2=subplot(2,1,2);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,2)));
plot(t,dobd{3}.q(:,2),'LineWidth',1,'Color','black');
legend('knee','intepreter','latex','Orientation','horizontal')
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([4.5,24.5])
%% disturbance estiamtion of different observers
% 1 nodob
% 2 mkcekf
% 3 immkf
% 4 cekf
% 5 ndob
figure
x1=subplot(2,1,1);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,1)));
plot(t(1:10:end),naivedob(1:10:end,1),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{3}.mkcekf(:,1),'LineWidth',1,'Color','black');
plot(t,dobd{3}.immekf(:,1),'LineWidth',1.2,'Color','red');
plot(t,dobd{3}.cekf(:,1),'LineWidth',1,'Color','blue');
plot(t,dobd{3}.ekf(:,1),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{3}.ndob(:,1),'LineWidth',1.2,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
legend('dist','MKCEKF','IMMEKF','CEKF','EKF','NDOB','intepreter','latex','Orientation','horizontal')
xticks([])
x2=subplot(2,1,2);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,2)));
plot(t(1:10:end),naivedob(1:10:end,2),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{3}.mkcekf(:,2),'LineWidth',1,'Color','black');
plot(t,dobd{3}.immekf(:,2),'LineWidth',1.2,'Color','red');
plot(t,dobd{3}.cekf(:,2),'LineWidth',1,'Color','blue');
plot(t,dobd{3}.ekf(:,2),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{3}.ndob(:,2),'LineWidth',1.2,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([4.5,24.5])

% zoom-in 
figure
x1=subplot(2,1,1);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,1)));
plot(t(1:10:end),naivedob(1:10:end,1),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{3}.mkcekf(:,1),'LineWidth',1.5,'Color','black');
plot(t,dobd{3}.immekf(:,1),'LineWidth',1.5,'Color','red');
plot(t,dobd{3}.cekf(:,1),'LineWidth',1,'Color','blue');
plot(t,dobd{3}.ekf(:,1),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{3}.ndob(:,1),'LineWidth',1.5,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
legend('dist','MKCEKF','IMMEKF','CEKF','EKF','NDOB','intepreter','latex','Orientation','horizontal')
xticks([])
x2=subplot(2,1,2);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,2)));
plot(t(1:10:end),naivedob(1:10:end,2),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{3}.mkcekf(:,2),'LineWidth',1.5,'Color','black');
plot(t,dobd{3}.immekf(:,2),'LineWidth',1.5,'Color','red');
plot(t,dobd{3}.cekf(:,2),'LineWidth',1,'Color','blue');
plot(t,dobd{3}.ekf(:,2),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{3}.ndob(:,2),'LineWidth',1.5,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([7.9,11])

%% position error plot
% 1 nodob
% 2 mkcekf
% 3 immkf
% 4 cekf
% 5 ndob
figure
x1=subplot(2,1,1);
box on
hold on
%plot(t,dobd{1}.qe(:,1),'LineWidth',1,'Color','black');
plot(t,dobd{2}.qe(:,1),'LineWidth',1.5,'Color','black');
plot(t,dobd{3}.qe(:,1),'LineWidth',1.5,'Color','red');
plot(t,dobd{4}.qe(:,1),'LineWidth',1,'Color','blue');
plot(t,dobd{5}.qe(:,1),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{6}.qe(:,1),'LineWidth',1,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
legend('MKCEKF','IMMEKF','CEKF','EKF','NDOB','intepreter','latex','Orientation','horizontal')
xticks([])
x2=subplot(2,1,2);
box on
hold on
%plot(t,dobd{1}.qe(:,2),'LineWidth',1,'Color','black');
plot(t,dobd{2}.qe(:,2),'LineWidth',1.5,'Color','black');
plot(t,dobd{3}.qe(:,2),'LineWidth',1.5,'Color','red');
plot(t,dobd{4}.qe(:,2),'LineWidth',1,'Color','blue');
plot(t,dobd{5}.qe(:,2),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{6}.qe(:,2),'LineWidth',1,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([7.9,11])

%% bar plot
 % 1 nodob
 % 2 mkcekf
 % 3 immkf
 % 4 cekf
 % 5 ekf
 % 6 ndob

figure
x_bar={'MKCEKF', 'IMMEKF', 'CEKF','EKF','NDOB'};
x_bar = categorical(x_bar);
y_bar=[dobm{2}.qe_rms';dobm{3}.qe_rms';dobm{4}.qe_rms';dobm{5}.qe_rms';dobm{6}.qe_rms'];
bar1=bar(x_bar,y_bar,'FaceAlpha',0.8,'EdgeColor','none');
set(bar1(2),'DisplayName','hip','FaceColor',[0.392156862745098 0.831372549019608 0.0745098039215686]);
set(bar1(1),'DisplayName','knee',...
    'FaceColor',[0.850980392156863 0.325490196078431 0.0980392156862745]);
ylabel('error (rad)','Interpreter','latex')
hold on
set(gca,'FontSize',10)
lg=legend('Hip','Knee');
set(lg,'FontSize',14)
set(gcf,'position',[100 100 800 500])


%% save metric
filename=[hz,'_','1'];
fullname=['D:\AfterPhD\research\MKMCDOB_IMM\DOB\ComputedTorque&MKEKF\DataHandling\dobm\',filename];
save(fullname,'dobm')



end