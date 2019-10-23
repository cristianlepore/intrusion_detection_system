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

% Selezione solo alcuni record dal dataset perchè è troppo grande
% X_Train = X_Train(1:2000,:);
% Y_Train = Y_Train(1:2000,:);

% Faccio la trasposta della matrice
X_Train = X_Train';
Y_Train = Y_Train';

% Parametro della k-fold validation
k = 10;

% Definisco i parametri per la mia SOM
orderingEpochs=20;
neighbordNeurons=5;
networkDimension=[20 20];
totalEpochs=50;

% Configuro la SOM
som = selforgmap(networkDimension,orderingEpochs,neighbordNeurons,'hextop','linkdist');

% Setto il nuovo parametro delle epoco totali da compiere
som.trainParam.epochs=totalEpochs;

indices = crossvalind('Kfold', size(X_Train,2) ,k);

DesiredOutput = [];
TestingResult = [];

for i =1:k
    
    X_train=X_Train(:,indices ~=i);
    Y_train=Y_Train(:,indices ~=i);
    X_test=X_Train(:,indices ==i);
    Y_test=Y_Train(:,indices ==i);

%     ********* PCA ********
%     **********************
    % Faccio la trasposta dei dataset
    X_train = X_train';
    Y_train = Y_train';
    X_test = X_test';
    Y_test = Y_test';

    % Riduco per comodità il dataset applicando la PCA
    [coeff,score,latent,tsquared,explained,mu] = pca(X_train,'NumComponents',15);
    X_train = score;

    % Moltiplico i vettori delle Principal Components ottenuti nel training set
    % con i dati per ottenere il nuovo testset.
    % Prima però ho dovuto modificare il testset
    X_test = bsxfun(@minus,X_test,mean(X_test));
    X_test = X_test*coeff;
    
    % Faccio la trasposta dei dataset
    X_train = X_train';
    Y_train = Y_train';
    X_test = X_test';
    Y_test = Y_test';
%     **********************
%     **********************
    
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
    clear label;
    
    
    
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
%     Converto l'etichetta a numero singolo con una stringa di 5 bits
%     Lo faccio con una funzione
    [m,n] = size(Y_test);
    converted_label = zeros(m,n);
    converted_label = convert(converted_label, winningNeuron_label);
    
%     Raggruppo gli errori
    DesiredOutput = [DesiredOutput, Y_test];
    TestingResult = [TestingResult, converted_label];
    
end

% Adesso calcolo l'errore
% errors = TestingResult ~= label;
% numErr = size(find(errors > 0),2);

% Apro la confusion matrix
figure,
plotconfusion(DesiredOutput,TestingResult);

function converted_label = convert(converted_label ,winningNeuron_label)
   
    idx = find(winningNeuron_label == 1);
    converted_label(1,idx) = 1;
    idx = find(winningNeuron_label == 2);
    converted_label(2,idx) = 1;
    idx = find(winningNeuron_label == 3);
    converted_label(3,idx) = 1;
    idx = find(winningNeuron_label == 4);
    converted_label(4,idx) = 1;
    idx = find(winningNeuron_label == 5);
    converted_label(5,idx) = 1;
    return;
    
end