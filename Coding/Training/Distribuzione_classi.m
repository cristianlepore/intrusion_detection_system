close all;
clear variables;

load('Dataset/X_Train.mat');
load('Dataset/Y_Train.mat');
load('Dataset/X_Test.mat');
load('Dataset/Y_Test.mat');
Y_Train = Y_Train';
Y_Test = Y_Test';

Normal_train = length(find(Y_Train(1,:) == 1));
DoS_train = length(find(Y_Train(2,:) == 1));
Probe_train = length(find(Y_Train(3,:) == 1));
U2R_train = length(find(Y_Train(4,:) == 1));
R2L_train = length(find(Y_Train(5,:) == 1));

% indexes = (find(Y_Test(6,:) == 2));
Y_Test = Y_Test(1:5,:);
Normal_test = length(find(Y_Test(1,:) == 1));
DoS_test = length(find(Y_Test(2,:) == 1));
Probe_test = length(find(Y_Test(3,:) == 1));
U2R_test = length(find(Y_Test(4,:) == 1));
R2L_test = length(find(Y_Test(5,:) == 1));

xtl = {'Normal' 'DoS' 'Probe' 'R2L' 'U2R'};
data = [Normal_train Normal_test; DoS_train DoS_test; Probe_train Probe_test; U2R_train U2R_test; R2L_train R2L_test];
figure(1);
hb = bar(data,2);
set(gca, 'XtickLabel', xtl);
set(gca, 'YTick', [0:10:2.2], 'YTickLabel',[0:10:1]+0);
legend('NSL-KDD Train','NSL-KDD Test','Location','northeast');