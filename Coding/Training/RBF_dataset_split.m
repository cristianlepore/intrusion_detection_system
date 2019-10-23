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

% Selezione solo alcuni record dal dataset perchè è troppo grande
X_Train = X_Train(1:10000,:);
Y_Train = Y_Train(1:10000,:);

% Normalizzo I valori
X_Train = mapminmax(X_Train);

% Riduco per comodità il dataset applicando la PCA
[coeff,score,latent,tsquared,explained,mu] = pca(X_Train,'NumComponents',15);
X_Train =score;

% Faccio la trasposta dei dataset
X_Train =X_Train';
Y_Train =Y_Train';
new_X_train = [];
new_Y_train = [];

divide = crossvalind('Kfold', size(X_Train,2) ,20);
for j =1:20
    X_Train2=X_Train(:,divide ==j);
    Y_Train2=Y_Train(:,divide ==j);

    k=10;
    % Creo gli indici per la cross-validazione
    indices = crossvalind('Kfold', size(X_Train2,2) ,k);

    kFoldTrainResults = [];
    kFoldExpectedResult = [];
    X_Test2 = [];
    Y_Test2 = [];
    
    % Preparo la rete neurale RBF
    goal= 0.05;
    spread= 10;

    for i =1:k

        X_train=X_Train2(:,indices ~=i);
        Y_train=Y_Train2(:,indices ~=i);
        X_test=X_Train2(:,indices ==i);
        Y_test=Y_Train2(:,indices ==i);

        % Faccio training della rete
        net1 = newrb(X_train,Y_train,goal,spread); 

        % Testo la rete sul validation set 
        trainResult=net1(X_test);

        % Converto i valori di regressione in pattern specifici
        [maxValueTrain,trainResult] = max(trainResult);
        [~,expectedResult]= max(Y_test);
        X_Test2= [X_Test2,X_test];
        Y_Test2= [Y_Test2,Y_test];

        kFoldTrainResults= [kFoldTrainResults, trainResult];
        kFoldExpectedResult= [kFoldExpectedResult, expectedResult];

    end

    kFoldTrainErrors= kFoldExpectedResult~=kFoldTrainResults;
    indexes = find(kFoldTrainErrors==1);
    X_Test2 = X_Test2(:,indexes);
    Y_Test2 = Y_Test2(:,indexes);
    kFoldTrainErrorRate=sum(kFoldTrainErrors)/size(kFoldTrainErrors,2)*100;
    [new_X_train] = [new_X_train, X_Test2];
    [new_Y_train] = [new_Y_train, Y_Test2];
end

new_X_train2 = [];
new_Y_train2 = [];

divide = crossvalind('Kfold', size(new_X_train,2) ,5);
for j =1:5
    X_Train2=new_X_train(:,divide ==j);
    Y_Train2=new_Y_train(:,divide ==j);

    k=10;
    % Creo gli indici per la cross-validazione
    indices = crossvalind('Kfold', size(X_Train2,2) ,k);

    kFoldTrainResults = [];
    kFoldExpectedResult = [];
    X_Test2 = [];
    Y_Test2 = [];
    
    % Preparo la rete neurale RBF
    goal= 0.03;
    spread= 10;

    for i =1:k

        X_train=X_Train2(:,indices ~=i);
        Y_train=Y_Train2(:,indices ~=i);
        X_test=X_Train2(:,indices ==i);
        Y_test=Y_Train2(:,indices ==i);

        % Faccio training della rete
        net1 = newrb(X_train,Y_train,goal,spread); 

        % Testo la rete sul validation set 
        trainResult=net1(X_test);

        % Converto i valori di regressione in pattern specifici
        [maxValueTrain,trainResult] = max(trainResult);
        [~,expectedResult]= max(Y_test);
        X_Test2= [X_Test2,X_test];
        Y_Test2= [Y_Test2,Y_test];

        kFoldTrainResults= [kFoldTrainResults, trainResult];
        kFoldExpectedResult= [kFoldExpectedResult, expectedResult];

    end

    kFoldTrainErrors= kFoldExpectedResult~=kFoldTrainResults;
    indexes = find(kFoldTrainErrors==1);
    X_Test2 = X_Test2(:,indexes);
    Y_Test2 = Y_Test2(:,indexes);
    kFoldTrainErrorRate=sum(kFoldTrainErrors)/size(kFoldTrainErrors,2)*100;
    [new_X_train2] = [new_X_train2, X_Test2];
    [new_Y_train2] = [new_Y_train2, Y_Test2];
end


indices = crossvalind('Kfold', size(new_X_train2,2) ,k);
X_Train = new_X_train2;
Y_Train = new_Y_train2;

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

fprintf('\nRESULTS \n')
fprintf('TRAINING\n')
fprintf('Error rate = %6.2f %%\n', kFoldTrainErrorRate)
fprintf('Classification accuracy = %6.2f %%\n', 100-kFoldTrainErrorRate)

% Confusion matrix
cm=confusionmat(kFoldExpectedResult,kFoldTrainResults);

fprintf('Test confusion matrix \n\n')
cm