% Pulisco il workspace
close all;
clear variables;

% Carico i dataset
load('Dataset/X_Train.mat');

% Normalizzo I valori
X_Train = mapminmax(X_Train);

X_Train = X_Train(:,[1,5:end]);
[coeff,score,latent,tsquared,explained,mu] = pca(X_Train,'NumComponents',15);

sum(explained(1:4));

% scatter3(score(:,1),score(:,2),score(:,3))
% axis equal
% xlabel('1st Principal Component')
% ylabel('2nd Principal Component')
% zlabel('3rd Principal Component')

figure,
bar(explained(1:10),'FaceColor', [0.1 0.1 0.1])