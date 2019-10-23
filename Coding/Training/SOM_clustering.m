% Pulisco il workspace
close all;
clear variables;

% Carico i dataset
load('Dataset/X_Train.mat');
load('Dataset/Y_Train.mat');

% Mischio le righe del dataset ad ogni primo avvio
X_temp = [X_Train,Y_Train];
X_temp = X_temp(randperm(size(X_temp,1)),:);
X_Train = X_temp(:,1:41);
Y_Train = X_temp(:,42:end);

% Normalizzo tutti i valori
X_Train = mapminmax(X_Train);

% Riduco per comodità il dataset applicando la PCA
[coeff,score,latent,tsquared,explained,mu] = pca(X_Train,'NumComponents',15);
X_Train =score;

% Selezione solo alcuni record dal dataset perchè è troppo grande
X_Train = X_Train(1:10000,:);
Y_Train = Y_Train(1:10000,:);

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

indices = crossvalind('Kfold', size(X_Train,2) ,10);

kFoldTrainResults = [];
kFoldTestResults = [];
kFoldTotalResults = [];

kFoldTrainTs = [];
kFoldTestTs = [];
kFoldTotalTs = [];

for i =1:10
    
    X_train=X_Train(:,indices ~=i);
    Y_train=Y_Train(:,indices ~=i);
    X_test=X_Train(:,indices ==i);
    Y_test=Y_Train(:,indices ==i);

    % Faccio training della rete
    [som_train, stats] = train(som, X_train);

    % Testing della rete
    y = som_train(X_train);
    
    % Ottengo le classi
    op_som = vec2ind(som_train(X_train))';

    % Creo la matrice per le etichette
    % La matrice è una label x celle e contiene le istanze di ogni label
    column = networkDimension(1,1)*networkDimension(1,2);
    label_matrix = zeros(6,column);

    % Costruisco la matrice per le etichette finali
    % Etichetta per normal
    [~,label] = max(Y_train);

    normal_idx = find(label==1);
    normal = op_som(normal_idx);
    for i = 1:column
        label_matrix(1,i) = sum(normal==i);
    end

%     figure,
%     plotsomhits(som_train, X_train(:,normal_idx));
%     hold on;

    % Etichetta per DoS
    DoS_idx = find(label==2);
    DoS = op_som(DoS_idx);
    for i = 1:column
        label_matrix(2,i) = sum(DoS==i);
    end

%     figure,
%     plotsomhits(som_train, X_train(:,DoS_idx));
%     hold on;

    % Etichetta per probe
    probe_idx = find(label==3);
    probe = op_som(probe_idx);
    for i = 1:column
        label_matrix(3,i) = sum(probe==i);
    end

%     figure,
%     plotsomhits(som_train, X_train(:,probe_idx));
%     hold on;

    % Etichetta per R2L
    R2L_idx = find(label==4);
    R2L = op_som(R2L_idx);
    for i = 1:column
        label_matrix(4,i) = sum(R2L==i);
    end

%     figure,
%     plotsomhits(som_train, X_train(:,R2L_idx));
%     hold on;

    % Etichetta per U2R
    U2R_idx = find(label==5);
    U2R = op_som(U2R_idx);

    for i = 1:column
        label_matrix(5,i) = sum(U2R==i);
    end

%     figure,
%     plotsomhits(som_train, X_train(:,U2R_idx));

    % Trovo gli indici dei nodi winning
    [M,I] = max(label_matrix);
    a = find(M == 0);
    I(a) = 0;
    clear a;
    
    
    
% %     Visualizzo i cluster*********************************************
%     
% %     seleziono da I i neuroni winning
%     a = find(I == 1);
% %     da y pendo il loro neurone winning
%     prova = [y(a,:)];
%     prova = prova';
% %     ottengo i records
%     [maximum,record_number] = max(prova);
%     X_train1 = X_train(:,record_number);
%     figure,
%     plotsomhits(som_train, X_train1);
%     hold on;
%     
% %     **************
% %     *************
% %       seleziono da I i neuroni winning
%     a = find(I == 2);
% %     da y pendo il loro neurone winning
%     prova = [y(a,:)];
%     prova = prova';
% %     ottengo i records
%     [maximum,record_number] = max(prova);
%     X_train1 = X_train(:,record_number);
%     figure,
%     plotsomhits(som_train, X_train1);
%     hold on;
%     
%     
%     %     **************
% %     *************
% 
% 
% 
%     %       seleziono da I i neuroni winning
%     a = find(I == 3);
% %     da y pendo il loro neurone winning
%     prova = [y(a,:)];
%     prova = prova';
% %     ottengo i records
%     [maximum,record_number] = max(prova);
%     X_train1 = X_train(:,record_number);
%     figure,
%     plotsomhits(som_train, X_train1);
%     hold on;
%     
%     %     **************
% %     *************
% 
%     
%     
%     %       seleziono da I i neuroni winning
%     a = find(I == 4);
% %     da y pendo il loro neurone winning
%     prova = [y(a,:)];
%     prova = prova';
% %     ottengo i records
%     [maximum,record_number] = max(prova);
%     X_train1 = X_train(:,record_number);
%     figure,
%     plotsomhits(som_train, X_train1);
%     hold on;
%     
%     %     **************
% %     *************
% 
%     
%     %       seleziono da I i neuroni winning
%     a = find(I == 5);
% %     da y pendo il loro neurone winning
%     prova = [y(a,:)];
%     prova = prova';
% %     ottengo i records
%     [maximum,record_number] = max(prova);
%     X_train1 = X_train(:,record_number);
%     figure,
%     plotsomhits(som_train, X_train1);
%     
%     
% %     Fine visualizzo i cluster*******************************************
    
%     Faccio la parte di testing
    y = som_train(X_test);
    [~,label] = max(Y_test);
    
    % Etichetta dei winning neurons
    [maximum,winningNeuron] = max(y);
    winningNeuron_label = I(winningNeuron);
    errors = winningNeuron_label ~= label;
    numErr = size(find(errors > 0),2);
    
end