% Pulisco il workspace
close all;
clear variables;

% Carico i dataset
load('Dataset/X_Train.mat');
load('Dataset/Y_Train.mat');
load('Dataset/X_Test.mat');
load('Dataset/Y_Test.mat');

% Normalizzo tutti i valori
X_Train = mapminmax(X_Train);

% Definisco il numero massimo di cluster da verificare
maxNumberOfClusters=5;

% Itero aumentandoo ogni volta il numero di cluster
% % for i=2:maxNumberOfClusters    
%     Applico l'algoritmo Kmeans
%     sumd ritorna la media della distanza tra ogni singolo punto del cluster
%     ed il suo centroide

[idx,C,sumd]=kmeans(X_Train,5);

%     Metto nel vettore sumDs la media delle distanze
%     sumDs(i)=mean(sumd);
% end

% Disegno il grafico
% figure, plot(sumDs(2:end));