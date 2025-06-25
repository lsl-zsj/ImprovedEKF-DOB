clc; clear all;
%% sys
ts=0.001;
Kg=80;

%% Gait generator
f_gait=0.2;
acc_gain=50;

%% Position Control Gain
Kp=15000;
Kd=150;
%% system parameters
load('optimresultsLeg.mat')
l1=0.42;
tau_c2=optimresultsLeg.x(1);
tau_s2=optimresultsLeg.x(2);
dqs2=optimresultsLeg.x(3);
eta2=optimresultsLeg.x(4);
X2=optimresultsLeg.x(5);
Y2=optimresultsLeg.x(6);
J2=optimresultsLeg.x(7);

tau_c1=optimresultsLeg.x(8);
tau_s1=optimresultsLeg.x(9);
dqs1=optimresultsLeg.x(10);
eta1=optimresultsLeg.x(11);
X1=optimresultsLeg.x(12);
Y1=optimresultsLeg.x(13);
J1=optimresultsLeg.x(14);

systemP=[tau_c2,tau_s2,dqs2,eta2,X2,Y2,J2,tau_c1,tau_s1,dqs1,eta1,X1,Y1,J1];

%% Channel   1 = NDOB  2= EKF  3=MKEKF 4= CKF 5=IMM 6= no dob
f_gait=0.1;
channel=5;
%% Disturbance Observer  8:24
cc=16;
%% Extended Kalman filter
vardtimes=5;   % 1:10
vard=vardtimes*1E-2*[2;1];
vardq=1E-4*[1;1];
varq=1E-5*[1;1];
Q_k= diag([vard;vardq;varq]);
R_k = diag([1E-4*[1;1];1E-6*[1;1]]);
sigma_p=[0.5 1 100000 100000 100000 100000]';
sigma_r=[100000 100000 100000 100000]';

sigma=5;
sigma_pp=[sigma sigma sigma sigma sigma sigma]';
sigma_rr=[sigma sigma sigma sigma]';


