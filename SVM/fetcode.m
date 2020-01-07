%% Variable initialization
close all; clear; clc;
X = xlsread('fet.xlsx','A2:E701');
Y = xlsread('fet2.xlsx','A2:A701');
test = xlsread('fet.xlsx','A702:E799');
test_prices = xlsread('fet.xlsx','F702:F799');

%% Model creation / initialization

rng(100); % For reproducibility

% Model generation


Mdl = fitrensemble(X,Y,'NPrint',50,'CategoricalPredictors','all','NumLearningCycles',500,'LearnRate',0.8);

% Train set price approximation

YFit = predict(Mdl,X);

lStd = resubLoss(Mdl);

% Optimization
% Mdl = fitrensemble(X,Y,'OptimizeHyperparameters','auto',...
%     'HyperparameterOptimizationOptions',struct('AcquisitionFunctionName',...
%     'expected-improvement-plus'))

% YFit = predict(Mdl,X);

%% Error in training

train_diff = zeros(1,700)';

% Error in percentage for each case
for i=1:700
    train_diff(i)=100*(Y(i)-YFit(i))./YFit(i);
end

% Absolute value the percentages
train_diff = abs(train_diff);

% train error
S = sum(train_diff);
train_error = S/700;
train_accuracy = 100 - train_error;

%% Error in testing

test_diff = zeros(1,98)';
YFit2 = zeros(1,98)';

% Test on new data
for i=1:98
     YFit2(i) = predict(Mdl,test(i,:));
end

% Error in percentage for each case
for i=1:98
    test_diff(i)=100*(test_prices(i)-YFit2(i))./YFit2(i);
end

% Absolute value the percentages
test_diff = abs(test_diff);

% test error
S = sum(test_diff);
test_error = S/98;
test_accuracy = 100 - test_error;
%%