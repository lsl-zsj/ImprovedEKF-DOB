function [X_]=prediction(I,m,k,b,T,l,X,u)

% X is the state vector 

% X(1) is the external disturbance 
% X(2) is the angular velocity
% X(3) is the angle 
X_=zeros(3,1);
% X_(1)=X(1)+randn(1,1);
g=9.81;
X_(1)=X(1);
X_(2)=T/I*X(1)+(1-b*T/I)*X(2)-(k*T/I)*X(3)-T/I*m*g*l*sin(X(3))+T/I*u;
X_(3)=T*X(2)+X(3);


end