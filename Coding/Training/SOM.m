% Pulisco il workspace
close all;
clear variables;

% Carico i dataset
load('Dataset/X_Train.mat');
load('Dataset/Y_Train.mat');

% Mischio le righe del dataset ad ogni primo avvio
% X_temp = [X_Train,Y_Train];
% X_temp = X_temp(randperm(size(X_temp,1)),:);
% X_Train = X_temp(:,1:41);
% Y_Train = X_temp(:,42:end);

% Normalizzo tutti i valori
X_Train = mapminmax(X_Train);

% Riduco per comodità il dataset applicando la PCA
[coeff,score,latent,tsquared,explained,mu] = pca(X_Train,'NumComponents',15);
X_Train =score;

% Selezione solo alcuni record dal dataset perchè è troppo grande
% X_Train = X_Train(1:10000,:);
% Y_Train = Y_Train(1:10000,:);

% Faccio la trasposta della matrice
X_Train = X_Train';
Y_Train = Y_Train';

% Definisco i parametri per la mia SOM
orderingEpochs=20;
neighbordNeurons=5;
networkDimension=[20 20];
totalEpochs=50;

% Configuro la SOM
som = selforgmap(networkDimension,orderingEpochs,neighbordNeurons,'hextop','linkdist');

% Setto il nuovo parametro delle epoco totali da compiere
som.trainParam.epochs=totalEpochs;

% Faccio training della rete
[som_train, stats] = train(som, X_Train);

% Training della rete
y=som_train(X_Train);
% Ottengo le classi
classes = vec2ind(y);
op_som = vec2ind(som_train(X_Train))';

% figure
% plotsomnd(som_train);
% hold on;
% figure,
% plotsomhits(som_train,X_Train);
% plotsomhits(som_train, X_Train(:,1:100)) % Winning nodes for F1.

[~,expectedResult]= max(Y_Train);
indexes = [];
indexes1 = find(expectedResult==2);
indexes2 = find(expectedResult==3);
indexes3 = find(expectedResult==4);
indexes4 = find(expectedResult==5);
[indexes]=[indexes1,indexes2,indexes3,indexes4];

plotsomhits(som_train, X_Train(:,indexes));