function gait_design()

clear all
f=0.3;

A=[19.9072,23.8858,19.9072,23.8858];
B=[7.7114,-23.3998,7.7114,-23.3998];
c=[-0.0781,-1.9451,3.0635,1.1965];
d1=[0.2762,-0.5417,0.2762,-0.5417];
d2=[0.06517,-0.1381,0.06517,-0.1381];
e1=[-0.1455,-1.353,-0.1455,-1.353];
e2=[-0.7061,-0.3798,-0.7061,-0.3798];

bias=[3.4764,-57.0147,8.6787,-12.1018];
index=1;
for t=0:0.001:10
for i=1:1:4
    gait(i,index)=B(i)+A(i)*(sin(2*pi*f*t+c(i))+d1(i)*sin(4*pi*f*t+2*c(i)+e1(i))+d2(i)*sin(6*pi*f*t+3*c(i)+e2(i)));
    dgait(i,index)=A(i)*(2*pi*f*cos(2*pi*f*t+c(i))+4*pi*f*d1(i)*cos(4*pi*f*t+2*c(i)+e1(i))+6*pi*f*d2(i)*cos(6*pi*f*t+3*c(i)+e2(i)));
    ddgait(i,index)=-A(i)*(2*pi*f*2*pi*f*sin(2*pi*f*t+c(i))+4*pi*f*4*pi*f*d1(i)*sin(4*pi*f*t+2*c(i)+e1(i))+6*pi*f*6*pi*f*d2(i)*sin(6*pi*f*t+3*c(i)+e2(i)));
end
index=index+1;
end

gait=gait';
dgait=dgait';
ddgait=ddgait';

figure
plot(gradient(gait(:,1))*1000)
hold on
plot(dgait(:,1))
legend('gradient','syms')

figure
plot(gradient(dgait(:,1))*1000)
hold on
plot(ddgait(:,1))
legend('gradient','syms')


%% Initial gait
q00=[0,0,0,0];
v00=[0,0,0,0];
a00=[0,0,0,0];
q11=[3.4764  -57.0147    8.6787  -12.1018];
v11=[41.0176  -39.8435  -14.6282    6.9192];
a11=[27.6670  108.7800   -7.0270   32.1858];
T=1;

for i=1:1001
    for j=1:4
        a0=q00(j);
        a1=v00(j);
        a2=a00(j)/2;
        a3=(20*q11(j)-20*q00(j)-(8*v11(j)+12*v00(j))*T-(3*a00(j)-a11(j))*T^2)/(2*T^3);
        a4=(30*q00(j)-30*q11(j)+(14*v11(j)+16*v00(j))*T+(3*a00(j)-2*a11(j))*T^2)/(2*T^4);
        a5=(12*q11(j)-12*q00(j)-(6*v11(j)+6*v00(j))*T-(a00(j)-a11(j))*T^2)/(2*T^5);%计算五次多项式系数 
        ti=(i-1)/1000;
        qi=a0+a1*(ti)+a2*(ti).^2+a3*(ti).^3+a4*(ti).^4+a5*(ti).^5;
        vi=a1+2*a2*(ti)+3*a3*(ti).^2+4*a4*(ti).^3+5*a5*(ti).^4;
        ai=2*a2+6*a3*(ti)+12*a4*(ti).^2+20*a5*(ti).^3;
        Q(i,j)=qi;
        V(i,j)=vi;
        A(i,j)=ai;
    end
    
end
figure
subplot(3,1,1)
plot(Q)
subplot(3,1,2)
plot(V)
subplot(3,1,3)
plot(A)


figure
plot(gradient(Q(:,1))*1000)
hold on
plot(V(:,1))

figure
plot(gradient(V(:,1))*1000)
hold on
plot(A(:,1))



end