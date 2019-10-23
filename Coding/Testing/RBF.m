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
X_Train = X_Train(1:12597,:);
Y_Train = Y_Train(1:12597,:);

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

% Preparo la rete neurale RBF
goal= 0.01;
spread= 10;
    
% Faccio training della rete
net1 = newrb(X_Train,Y_Train,goal,spread); 
% Testo la rete sul validation set 
testResult=net1(X_Test);

% Calcolo i valori massimi -- uso il valore max() perchè con la funzione
% round() ottenevo una imprecisione
[maxValue,result] = max(testResult);

% Converto l'etichetta a numero singolo con una stringa di 5 bits
% Lo faccio con una funzione
[m,n] = size(Y_Test);
clear m;
converted_label = zeros(5,n);
finalResult = convert(converted_label, result);

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

indexes = find(result == 1);
result(indexes) = 0;
indexes = find(result > 1);
result(indexes) = 1;

[maxValue, Y_test] = max(Y_test);
indexes = find(Y_test == 1);
Y_test(indexes) = 0;
indexes = find(Y_test > 1);
Y_test(indexes) = 1;

% **********************************************
% **********************************************

figure,
plotconfusion(Y_test,result);

% Confusion matrix per 2 classes KNOWN
indexes = find(Y_Test(6,:)==1);
expectedResult = Y_test(indexes);
finalResult_known = result(indexes);

figure,
plotconfusion(expectedResult,finalResult_known);
clear expectedResult;
clear indexes;

% Confusion matrix per 2 classes UNKNOWN
indexes = find(Y_Test(6,:)==2);
expectedResult = Y_test(indexes);
finalResult_known = result(indexes);

figure,
plotconfusion(expectedResult,finalResult_known);
clear expectedResult;

% *********** FINE PROGRAMMA ****************
% *******************************************

function converted_label = convert(converted_label ,result)
   
    idx = find(result == 1);
    converted_label(1,idx) = 1;
    idx = find(result == 2);
    converted_label(2,idx) = 1;
    idx = find(result == 3);
    converted_label(3,idx) = 1;
    idx = find(result == 4);
    converted_label(4,idx) = 1;
    idx = find(result == 5);
    converted_label(5,idx) = 1;
    return;
    
end