% Pulisco il workspace
close all;
clear variables;

% Carico i dataset
load('Dataset/X_Train.mat');
load('Dataset/Y_Train.mat');
load('Dataset/X_Test.mat');
load('Dataset/Y_Test.mat');

% Mischio le righe del dataset di train ad ogni primo avvio
X_temp = [X_Train,Y_Train];
X_Train = X_Train(randperm(size(X_temp,1)),:);
X_Train = X_temp(:,1:41);
Y_Train = X_temp(:,42:end);
% Cancello la variabile X_temp
clear X_temp;

% Mischio le righe del dataset di test ad ogni primo avvio
X_temp = [X_Test,Y_Test];
X_Test = X_Test(randperm(size(X_temp,1)),:);
X_Test = X_temp(:,1:41);
Y_Test = X_temp(:,42:end);
% Cancello la variabile X_temp
clear X_temp;

% Selezione solo alcuni record dal dataset perchè è troppo grande
% X_Train = X_Train(1:1000,:);
% Y_Train = Y_Train(1:1000,:);

% Normalizzo I valori
X_Train = mapminmax(X_Train);
X_Test = mapminmax(X_Test);

% Riduco per comodità il dataset applicando la PCA
[coeff,score,latent,tsquared,explained,mu] = pca(X_Train,'NumComponents',15);
X_Train = score;

% Moltiplico i vettori delle Principal Components ottenuti nel training set
% con i dati per ottenere il nuovo testset.
% Prima però ho dovuto modificare il testset
X_Test = bsxfun(@minus,X_Test,mean(X_Test));
X_Test = X_Test*coeff;

% Faccio la trasposta dei dataset
X_Train =X_Train';
Y_Train =Y_Train';
X_Test =X_Test';
Y_Test =Y_Test';

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

% Testing della rete
testResult = som_train(X_Test);
    
% Ottengo le classi
op_som = vec2ind(som_train(X_Train))';

% Creo la matrice per le etichette
% La matrice è una label x celle e contiene le istanze di ogni label
column = networkDimension(1,1)*networkDimension(1,2);
label_matrix = zeros(6,column);

% Costruisco la matrice per le etichette finali
% Etichetta per normal
[~,label] = max(Y_Train);

normal_idx = find(label==1);
normal = op_som(normal_idx);
for i = 1:column
    label_matrix(1,i) = sum(normal==i);
end

% figure,
% plotsomhits(som_train, X_Train(:,normal_idx));
% hold on;

% Etichetta per DoS
DoS_idx = find(label==2);
DoS = op_som(DoS_idx);
for i = 1:column
    label_matrix(2,i) = sum(DoS==i);
end

% figure,
% plotsomhits(som_train, X_Train(:,DoS_idx));
% hold on;

% Etichetta per probe
probe_idx = find(label==3);
probe = op_som(probe_idx);
for i = 1:column
    label_matrix(3,i) = sum(probe==i);
end

% figure,
% plotsomhits(som_train, X_Train(:,probe_idx));
% hold on;

% Etichetta per R2L
R2L_idx = find(label==4);
R2L = op_som(R2L_idx);
for i = 1:column
    label_matrix(4,i) = sum(R2L==i);
end

% figure,
% plotsomhits(som_train, X_Train(:,R2L_idx));
% hold on;

% Etichetta per U2R
U2R_idx = find(label==5);
U2R = op_som(U2R_idx);

for i = 1:column
    label_matrix(5,i) = sum(U2R==i);
end

% figure,
% plotsomhits(som_train, X_Train(:,U2R_idx));

% Trovo gli indici dei nodi winning
[M,I] = max(label_matrix);
a = find(M == 0);
I(a) = 0;
clear a;
clear label;
        
% Etichetta dei winning neurons
[maximum,winningNeuron] = max(testResult);
winningNeuron_label = I(winningNeuron);

% Converto l'etichetta a numero singolo con una stringa di 5 bits
% Lo faccio con una funzione
[m,n] = size(Y_Test);
clear m;
converted_label = zeros(5,n);
finalResult = convert(converted_label, winningNeuron_label);

% ***************************************************
% Confusion matrix per 5 classes ALL
expectedResult = Y_Test(1:5,:);

figure,
plotconfusion(expectedResult,finalResult);
clear expectedResult;

% Confusion matrix per 5 classes KNOWN
indexes = find(Y_Test(6,:)==1);
expectedResult = Y_Test(1:5,indexes);
finalResult_known = finalResult(:,indexes);

figure,
plotconfusion(expectedResult,finalResult_known);
clear expectedResult;

% Confusion matrix per 5 classes UNKNOWN
indexes = find(Y_Test(6,:)==2);
expectedResult = Y_Test(1:5,indexes);
finalResult_unknown = finalResult(:,indexes);

figure,
plotconfusion(expectedResult,finalResult_unknown);
clear expectedResult;

% **********************************************
% VARIANTE A DUE SOLE CLASSI
Y_test = Y_Test(1:5,:);

indexes = find(winningNeuron_label == 1);
winningNeuron_label(indexes) = 0;
indexes = find(winningNeuron_label > 1);
winningNeuron_label(indexes) = 1;

[maxValue, Y_test] = max(Y_test);
indexes = find(Y_test == 1);
Y_test(indexes) = 0;
indexes = find(Y_test > 1);
Y_test(indexes) = 1;

% **********************************************
% **********************************************

figure,
plotconfusion(Y_test,winningNeuron_label);

% Confusion matrix per 2 classes KNOWN
indexes = find(Y_Test(6,:)==1);
expectedResult = Y_test(indexes);
finalResult_known = winningNeuron_label(indexes);

figure,
plotconfusion(expectedResult,finalResult_known);
clear expectedResult;
clear indexes;

% Confusion matrix per 2 classes UNKNOWN
indexes = find(Y_Test(6,:)==2);
expectedResult = Y_test(indexes);
finalResult_known = winningNeuron_label(indexes);

figure,
plotconfusion(expectedResult,finalResult_known);
clear expectedResult;

% *********** FINE PROGRAMMA ****************
% *******************************************

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