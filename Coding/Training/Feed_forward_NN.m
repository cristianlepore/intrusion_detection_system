% Pulisco il workspace
close all;
clear variables;

% Carico i dataset
load('Dataset/X_Train.mat');
load('Dataset/Y_Train.mat');

% Mischio le righe del dataset ad ogni primo avvio
X_temp = [X_Train,Y_Train];
X_Train = X_Train(randperm(size(X_temp,1)),:);
X_Train = X_temp(:,1:41);
Y_Train = X_temp(:,42:end);

% Selezione solo alcuni record dal dataset perchè è troppo grande
% X_Train = X_Train(1:12597,:);
% Y_Train = Y_Train(1:12597,:);

% Normalizzo I valori
X_Train = mapminmax(X_Train);

% Faccio la trasposta dei dataset
X_Train =X_Train';
Y_Train =Y_Train';

% numClasses=5;
% Parametro della k-fold validation
K=10;

% Divide into training and test DB
% [trainInd,valInd,testInd] = dividerand(size(X_Train,2),0.7,0.15,0.15);

% create a neural network
neuronsXLayer = 8; % number of neurons per layer
neuronTopology{1} = 'tansig';

% Creo gli indici per la cross-validazione
indices = crossvalind('Kfold', size(X_Train,2) ,K);

% Divido dataset in training, validaton e test
% X_train =X_Train(:,trainInd);
% Y_train =Y_Train(:,trainInd);
% X_val   =X_Train(:,valInd);
% Y_val   =Y_Train(:,valInd);
% X_test  =X_Train(:,testInd);
% Y_test  =Y_Train(:,testInd);

kFoldTrainResults = [];
kFoldTestResults = [];
kFoldTotalResults = [];
kfoldTestResultMultiNeuron = [];
desiredOutput = [];

kFoldTrainTs = [];
kFoldTestTs = [];
kFoldTotalTs = [];

for i =1:K

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
    [coeff,score,latent,tsquared,explained,mu] = pca(X_train,'NumComponents',35);
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

    % Definisco il tipo di rete neurale
    net = feedforwardnet(neuronsXLayer);

    % training and testing data
    net.divideParam.trainRatio = 1;
    net.divideParam.testRatio  = 0; 
    net.divideParam.valRatio   = 0;

    % Definisco il numero di epoche
    net.trainParam.epochs = 100;
    % Definisco l'obiettivo da raggiungere
    net.trainParam.goal = 0.01;

    % Faccio il caso di rete con un solo strato nascosto e la stessa acivation 
    % function per ogni strato
    for iL = 1: size(neuronsXLayer,2)
        net.layers{iL}.transferFcn = neuronTopology{iL};
    end

    % train a neural network
    [net,tr,Y,E] = train(net,X_train,Y_train);

    % Training data
    trainResult = net(X_train);
    [maxValueTrain,trainResult] = max(trainResult);
    [~,expectedTrainResult]= max(Y_train);

    % Validation data
    % valResult = net(X_val);
    % [maxValueVal,valResult] = max(valResult);
    % [~,expectedValResult] = max(Y_val);

    % Testing data
    testResultMultiNeuron = net(X_test);
    
    [maxValueTest,testResult] = max(testResultMultiNeuron);
    [~,expectedTestResult]= max(Y_test);
    desiredOutput = [desiredOutput,Y_test];

    kFoldTrainResults=[kFoldTrainResults, trainResult];
    kFoldTestResults=[kFoldTestResults, testResult];
    kFoldTotalResults=[kFoldTotalResults, trainResult, testResult];
    kfoldTestResultMultiNeuron=[kfoldTestResultMultiNeuron, testResultMultiNeuron];

    kFoldTrainTs=[kFoldTrainTs, expectedTrainResult];
    kFoldTestTs=[kFoldTestTs, expectedTestResult];
    kFoldTotalTs=[kFoldTotalTs, expectedTrainResult, expectedTestResult];

end
% Valuto l'errore
% trainErr = expectedTrainResult ~= trainResult;
% valError = expectedValResult ~= valResult;
% testErr  = expectedTestResult ~= testResult;

% kFoldTrainErrors=kFoldTrainTs~=kFoldTrainResults;
kFoldTestErrors=kFoldTestTs~=kFoldTestResults;
% kFoldTotalErrors=kFoldTotalTs~=kFoldTotalResults;

% kFoldTrainErrorRate=sum(kFoldTrainErrors)/size(kFoldTrainErrors,2)*100;
kFoldTestErrorRate=sum(kFoldTestErrors)/size(kFoldTestErrors,2)*100;
% kFoldTotalErrorRate=sum(kFoldTotalErrors)/size(kFoldTotalErrors,2)*100;

% % Plotto i grafici degli errori
% % Train error
% figure,
% plot(trainErr)
% title('training error')
% % Train error
% figure,
% plot(valError)
% title('validation error')
% % Test error
% figure,
% plot(testErr)
% title('testing error')

% Risultati per training
% numTrainErr  = size(find(trainErr > 0),2);
% percTrainErr = (numTrainErr/size(X_train,2))*100;

% Risultati per validation
% numValErr = size(find(valError > 0),2);
% percValErr = (numValErr/size(X_val,2))*100;

% Risultati per testing
numTestErr = size(find(kFoldTestErrors > 0),2);
percTestErr = (numTestErr/size(kFoldTestErrors,2))*100;

% Risultati con training e validazione insieme
% totalErr = [trainErr, valError];
% numTotalErr = size(find(totalErr > 0),2);
% percTotalErr = (numTotalErr/size(Y_Train,2))*100;

% Stampo sulla console dei risultati
fprintf('\nRESULTS \n')
% fprintf('TRAINING\n')
% fprintf('number of el. = %i \n', size(trainErr,2))
% fprintf('number of errors = %i \n', numTrainErr)
% fprintf('Error rate = %6.2f %%\n', percTrainErr)
% fprintf('Classification accuracy = %6.2f %%\n', 100-percTrainErr)
fprintf('\nTESTING\n')
fprintf('number of el. = %i \n', size(kFoldTestErrors,2))
fprintf('number of errors = %i \n', numTestErr)
fprintf('Error rate = %6.2f %%\n', percTestErr)
fprintf('Classification accuracy = %6.2f %%\n', 100-percTestErr)
% fprintf('\nTOTAL\n')
% fprintf('number of el. = %i \n', size(totalErr,2))
% fprintf('number of errors = %i \n', numTotalErr)
% fprintf('Error rate = %6.2f %%\n', percTotalErr)
% fprintf('Classification accuracy = %6.2f %%\n', 100-percTotalErr)


% % ******************************************************************************
% 
%         % Testing data
%         testResultMultiNeuron = net(X_Test);
%         testResultMultiNeuron= round(testResultMultiNeuron);
%         [maxValueTest,testResult] = max(testResultMultiNeuron);
%         [~,expectedTestResult] = max(Y_Test);
%         
%         testResult(testResult<2)=0;
%         testResult(testResult>1)=1;
%         
%         expectedTestResult(expectedTestResult<2)=0;
%         expectedTestResult(expectedTestResult>1)=1;
% 
%         % Confusion matrix
%         cm = confusionmat(expectedTestResult,testResult);
%         fprintf('Confusion matrix \n\n')
%         cm;
% 
%         % Apro la confusion matrix
%         figure,
%         plotconfusion(expectedTestResult,testResult);
%     
% % ******************************************************************************
    
% Confusion matrix
cm = confusionmat(kFoldTestTs,kFoldTestResults);
fprintf('Confusion matrix \n\n')
cm;

% kFoldTestTs(kFoldTestTs<2)=0;
% kFoldTestTs(kFoldTestTs>1)=1;        
% kFoldTestResults(kFoldTestResults<2)=0;
% kFoldTestResults(kFoldTestResults>1)=1;

% Apro la confusion matrix
figure,
plotconfusion(desiredOutput,kfoldTestResultMultiNeuron);
% plotconfusion(kFoldTestTs,kFoldTestResults);