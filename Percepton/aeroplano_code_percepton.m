%% Variable initialization
clear all; close all; clc;
X = xlsread('fet.xlsx','A2:E796');
T = xlsread('fet2.xlsx','A1:ADP1');
%%%Standard Normalization
%%Number of observations
N=length(X(:,1));
%%Number of variables
M=length(X(1,:));
%%Output array of normalised values
Y=zeros(N,M);
%%Subtract mean of each Column from data
Y=X-repmat(mean(X),N,1);
%%Normalize each observation by the standard deviation of that variable
Y=Y./repmat(std(X,0,1),N,1);
%%%
%% x_train is input and y_train target of data
x_train=Y((1:700),1:5)'; y_train=T(:,(1:700));
%% x_test is test data not learning percepton and y_arxiko is real data output of x_test
x_test=Y((701:end),1:5)'; y_arxiko=T(:,(701:end));
%% Initialization MultiLayerPerceptron
net=newff(x_train,y_train,[10,10]);
%%Train with loop 10 times
for i=10
%%Trained network using BackPropagation
	net=train(net,x_train,y_train);
end
%%Output of test data isn't learning network
y_net=net(x_test);
%%Displayed results on screen
disp(['Price of Airticket is=' num2str(y_net)]);
%% Error in testing
test_diff = zeros(1,95)';
%%Error in percentage for each case
for i=1:95
    test_diff(i)=100*((y_arxiko(i)-y_net(i))./y_net(i));
end
%%Absolute value the percentages
test_diff = abs(test_diff);
%%Sum test data 
S = sum(test_diff);
%%Test error of output at 100%
test_error = S/95;
%%Test accuracy of output at 100%
test_accuracy = 100 - test_error;

