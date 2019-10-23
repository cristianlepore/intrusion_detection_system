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

% Selezione solo alcuni record dal dataset perchè è troppo grande
X_Train = X_Train(1:12597,:);
Y_Train = Y_Train(1:12597,:);

% Normalizzo I valori
X_Train = mapminmax(X_Train);

% Faccio la trasposta dei dataset
X_Train =X_Train';
Y_Train =Y_Train';

k=10;
% Creo gli indici per la cross-validazione
indices = crossvalind('Kfold', size(X_Train,2) ,k);

kFoldTrainResults = [];
kFoldExpectedResult = [];

% Preparo la rete neurale RBF
goal= 0.01;
spread= 10;

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
    net1 = newrb(X_train,Y_train,goal,spread); 
    % Testo la rete sul validation set 
    trainResult=net1(X_test);
    
    % Converto i valori di regressione in pattern specifici
    [maxValueTrain,trainResult] = max(trainResult);
    [~,expectedResult]= max(Y_test);

    kFoldTrainResults= [kFoldTrainResults, trainResult];
    kFoldExpectedResult= [kFoldExpectedResult, expectedResult];
    
end

kFoldTrainErrors= kFoldExpectedResult~=kFoldTrainResults;
kFoldTrainErrorRate=sum(kFoldTrainErrors)/size(kFoldTrainErrors,2)*100;

fprintf('\nRESULTS \n')
fprintf('TRAINING\n')
fprintf('Error rate = %6.2f %%\n', kFoldTrainErrorRate)
fprintf('Classification accuracy = %6.2f %%\n', 100-kFoldTrainErrorRate)

% Confusion matrix
cm=confusionmat(kFoldExpectedResult,kFoldTrainResults);

fprintf('Test confusion matrix \n\n')
cm

% Apro la confusion matrix
figure,
plotconfusion(kFoldExpectedResult,kFoldTrainResults);