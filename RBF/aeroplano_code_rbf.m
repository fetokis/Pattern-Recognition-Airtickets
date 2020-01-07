clear all; close all; clc;


X = xlsread('fet.xlsx','A2:E796');
T = xlsread('fet2.xlsx','A1:ADP1');
N=length(X(:,1));
M=length(X(1,:));
Y=zeros(N,M);
Y=X-repmat(mean(X),N,1);
Y=Y./repmat(std(X,0,1),N,1);



goal=0;
k=75;
Ki=5;
spread=1;
x_train=Y((1:700),1:5)'; y_train=T(:,(1:700));
x_test=Y((701:end),1:5)'; y_arxiko=T(:,(701:end)); 
net = newrb(x_train,y_train,goal,spread,k,Ki);
y_net=net(x_test);
test_diff = zeros(1,95)';
for i=1:95
    test_diff(i)=100*((y_arxiko(i)-y_net(i))./y_net(i));
end
test_diff = abs(test_diff);
S = sum(test_diff);
test_error = S/95;
test_accuracy = 100 - test_error;
disp(['Price of Airticket is=' num2str(y_net)]);
