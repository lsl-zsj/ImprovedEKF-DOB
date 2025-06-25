function dob_prepropossing_rubber_band_main()

clear all
clc
addpath(genpath('.\data\band'));

f_gait=0.3;
hz=[num2str(f_gait*100)];
vardtimes=[num2str(1)];

dob{1}=load('30hznodob');     % 1 nodob
dob{2}=load('30hzmkekf_1');   % 2 mkcekf
dob{3}=load('30hzimm_1');     % 3 immkf
dob{4}=load('30hzckf_1');     % 4 cekf
dob{5}=load('30hzekf_1');     % 5 ekf
dob{6}=load('30hzdob_8');     % 6 ndob

%% smoother bandwidth
smc = designfilt('lowpassiir','FilterOrder',12, ...
    'HalfPowerFrequency',0.15,'DesignMethod','butter');

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
    dobd{i}.mu=dob{i}.rlt.mu(index,:); % mu
    dobd{i}.tor=dob{i}.rlt.tor(index,:); % tor
    %% 
    torhips = filtfilt(smc,dobd{i}.tor(:,1));
    torknees = filtfilt(smc,dobd{i}.tor(:,2));
    dobd{i}.tors=[torhips,torknees];
    %% metric
    tore=dobd{i}.tor-dobd{i}.tors;
    dobm{i}.qe_rms=[rms(dobd{i}.qe(:,1));rms(dobd{i}.qe(:,2))];
    dobm{i}.dqe_rms=[rms(dobd{i}.dqe(:,1));rms(dobd{i}.dqe(:,2))];
    dobm{i}.tors_rms=[rms(tore(:,1));rms(tore(:,2))];

    dobm{i}.qe_std=[std(dobd{i}.qe(:,1));std(dobd{i}.qe(:,2))];

end

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
x_labels = { 'IMMEKF','MKCEKF', 'CEKF', 'EKF', 'NDOB'};
x_bar = categorical(x_labels, x_labels, 'Ordinal', true); 
y_bar=[dobm{3}.qe_rms';dobm{2}.qe_rms';dobm{4}.qe_rms';dobm{5}.qe_rms';dobm{6}.qe_rms'];
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

%%
figure
% 类别顺序定义
x_labels = {'IMMEKF','MKCEKF','CEKF','EKF','NDOB'};
x_bar = categorical(x_labels, x_labels, 'Ordinal', true); 

% 数据矩阵 [Knee; Hip]
y_bar = [dobm{3}.qe_rms'; dobm{2}.qe_rms'; dobm{4}.qe_rms'; dobm{5}.qe_rms'; dobm{6}.qe_rms'];

% 创建柱状图
bar1 = bar(x_bar, y_bar, 'FaceAlpha', 0.9, 'EdgeColor', 'none');
set(bar1(1), 'DisplayName', 'Knee', 'FaceColor', [0.850, 0.325, 0.098]); % 红橙
set(bar1(2), 'DisplayName', 'Hip',  'FaceColor', [0.200, 0.600, 0.300]); % 绿色

% 添加数值标签
xtips1 = bar1(1).XEndPoints; ytips1 = bar1(1).YEndPoints;
labels1 = string(round(bar1(1).YData,3));
text(xtips1, ytips1 + 0.005, labels1, 'HorizontalAlignment','center','FontSize',10)

xtips2 = bar1(2).XEndPoints; ytips2 = bar1(2).YEndPoints;
labels2 = string(round(bar1(2).YData,3));
text(xtips2, ytips2 + 0.005, labels2, 'HorizontalAlignment','center','FontSize',10)

% 设置Y轴标签和样式
ylabel('Error (rad)', 'Interpreter', 'latex', 'FontSize', 14)
set(gca, 'FontSize', 12, 'YGrid', 'on', 'GridLineStyle', '--')

% 图例
lg = legend('Hip', 'Knee', 'Location', 'northwest');
set(lg, 'FontSize', 12)

% 美化图形窗口
set(gcf, 'Color', 'w', 'Position', [100 100 800 500])
box on
set(gca,'fontsize',16)


%imm_imp=(dobm{5}.qe_rms'-dobm{3}.qe_rms')./dobm{5}.qe_rms';

%mkc_imp=(dobm{5}.qe_rms'-dobm{2}.qe_rms')./dobm{5}.qe_rms';


end