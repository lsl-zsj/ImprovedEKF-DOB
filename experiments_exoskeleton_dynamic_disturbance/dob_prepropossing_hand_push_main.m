function dob_prepropossing_hand_push_main()

clear all
clc
addpath(genpath('.\data\push'));

f_gait=0.3;
hz=[num2str(f_gait*100)];
vardtimes=[num2str(1)];

dob{1}=load('30hzimm_1');     % 1

%% smoother bandwidth
smc = designfilt('lowpassiir','FilterOrder',12, ...
    'HalfPowerFrequency',0.15,'DesignMethod','butter');

%% performance comparison 3002:end
index=3002:33002;
dt=0.001;
t=0:dt:dt*(length(index)-1);
dobd=[];
dobm=[];
for i=1:1
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
end

%% hip and knee native disturbance
dq=dobd{1}.dq;
ddq(:,1)=gradient(dq(:,1))*1000;
ddq(:,2)=gradient(dq(:,2))*1000;
naivedob=native_disturbance_observer(dobd{1}.q,dobd{1}.dq,ddq,dobd{1}.tor);
%% angle
figure
x1=subplot(2,1,1);
box on
% plot(t,10*sign(dobd{3}.dq(:,1)));
plot(t,dobd{1}.q(:,1),'LineWidth',1,'Color','black');
legend('hip','intepreter','latex','Orientation','horizontal')
set(gca,'fontsize',16)
xticks([])
x2=subplot(2,1,2);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,2)));
plot(t,dobd{1}.q(:,2),'LineWidth',1,'Color','black');
legend('knee','intepreter','latex','Orientation','horizontal')
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([4.5,24.5])

%% disturbance estiamtion of different observers

figure
x1=subplot(2,1,1);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,1)));
plot(t(1:5:end),naivedob(1:5:end,1),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{1}.mkcekf(:,1),'LineWidth',1,'Color','black');
plot(t,dobd{1}.immekf(:,1),'LineWidth',1.2,'Color','red');
plot(t,dobd{1}.cekf(:,1),'LineWidth',1,'Color','blue');
plot(t,dobd{1}.ekf(:,1),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{1}.ndob(:,1),'LineWidth',1.2,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
legend('RDOB','MKCEKF','IMMEKF','CEKF','EKF','NDOB','intepreter','latex','Orientation','horizontal')
xticks([])
ylim([-40,20])
yl = ylim; % 获取 y 轴范围
%
rectangle('Position',[3.35, yl(1), 0.3, yl(2)-yl(1)], 'EdgeColor','k', 'LineWidth',1.5, 'LineStyle','--')
rectangle('Position',[6.6, yl(1), 0.3, yl(2)-yl(1)], 'EdgeColor','k', 'LineWidth',1.5, 'LineStyle','--')
rectangle('Position',[9.9, yl(1), 0.3, yl(2)-yl(1)], 'EdgeColor','k', 'LineWidth',1.5, 'LineStyle','--')
x2=subplot(2,1,2);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,2)));
plot(t(1:5:end),naivedob(1:5:end,2),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{1}.mkcekf(:,2),'LineWidth',1,'Color','black');
plot(t,dobd{1}.immekf(:,2),'LineWidth',1.2,'Color','red');
plot(t,dobd{1}.cekf(:,2),'LineWidth',1,'Color','blue');
plot(t,dobd{1}.ekf(:,2),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{1}.ndob(:,2),'LineWidth',1.2,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
xlim([0,15])
ylim([-40,20])
yl = ylim; % 获取 y 轴范围
%
rectangle('Position',[3.35, yl(1), 0.3, yl(2)-yl(1)], 'EdgeColor','k', 'LineWidth',1.5, 'LineStyle','--')
rectangle('Position',[6.6, yl(1), 0.3, yl(2)-yl(1)], 'EdgeColor','k', 'LineWidth',1.5, 'LineStyle','--')
rectangle('Position',[9.9, yl(1), 0.3, yl(2)-yl(1)], 'EdgeColor','k', 'LineWidth',1.5, 'LineStyle','--')
set(gcf,'position',[100 100 800 800])




figure
x1=subplot(2,1,1);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,1)));
l1=plot(t(1:3:end),naivedob(1:3:end,1),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
l2=plot(t,dobd{1}.mkcekf(:,1),'LineWidth',1,'Color','black');
l3=plot(t,dobd{1}.immekf(:,1),'LineWidth',1.2,'Color','red');
l4=plot(t,dobd{1}.cekf(:,1),'LineWidth',1,'Color','blue');
l5=plot(t,dobd{1}.ekf(:,1),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
l6=plot(t,dobd{1}.ndob(:,1),'LineWidth',1.2,'Color',[0.9290 0.6940 0.1250]);
ylabel('Nm','Interpreter','latex')
set(gca,'fontsize',16)
ylim([-40,20])
yl = ylim; % 获取 y 轴范围

x_fill = [6.6 6.9 6.9 6.6];
y_fill = [-40 -40 20 20];
l7 = fill(x_fill, y_fill, [1 0 0.2], ...
    'FaceAlpha', 0.1, 'EdgeColor', 'none', ...
    'DisplayName', 'Disturbance interval');

x_fill = [7.9 8.2 8.2 7.9];
y_fill = [-40 -40 20 20];
l8 = fill(x_fill, y_fill, [0.4660    0.6740    0.1880], ...
    'FaceAlpha', 0.1, 'EdgeColor', 'none', ...
    'DisplayName', 'Disturbance interval');
legend([l1 l2 l3 l4 l5 l6 l7 l8],...
 {'RDOB','MKCEKF','IMMEKF','CEKF','EKF','NDOB','Fast disturbance','Slow distrubance'},...
 'Interpreter','latex','Orientation','horizontal')
xticks([])
x2=subplot(2,1,2);
box on
hold on
% plot(t,10*sign(dobd{3}.dq(:,2)));
plot(t(1:3:end),naivedob(1:3:end,2),'LineWidth',0.2,'Color',[0 0.4470 0.7410],'LineStyle','--');
plot(t,dobd{1}.mkcekf(:,2),'LineWidth',1,'Color','black');
plot(t,dobd{1}.immekf(:,2),'LineWidth',1.2,'Color','red');
plot(t,dobd{1}.cekf(:,2),'LineWidth',1,'Color','blue');
plot(t,dobd{1}.ekf(:,2),'LineWidth',1,'Color',[0.4940 0.1840 0.5560]);
plot(t,dobd{1}.ndob(:,2),'LineWidth',1.2,'Color',[0.9290 0.6940 0.1250]);
set(gca,'fontsize',16)
ylabel('Nm','Interpreter','latex')
linkaxes([x1,x2],'x')
xlabel('time (s)','Interpreter','latex')
set(gcf,'position',[100 100 800 800])
xlim([5,8.5])
ylim([-40,20])
yl = ylim; % 获取 y 轴范围
x_fill = [6.6 6.9 6.9 6.6];
y_fill = [-40 -40 20 20];
l7 = fill(x_fill, y_fill, [1 0 0.2], ...
    'FaceAlpha', 0.1, 'EdgeColor', 'none', ...
    'DisplayName', 'Disturbance interval');

x_fill = [7.9 8.2 8.2 7.9];
y_fill = [-40 -40 20 20];
l8 = fill(x_fill, y_fill, [0.4660    0.6740    0.1880], ...
    'FaceAlpha', 0.1, 'EdgeColor', 'none', ...
    'DisplayName', 'Disturbance interval');





end