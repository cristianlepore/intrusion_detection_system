close all;
clear all;

% Risutlati per Feed-forward neural network
% x1= [5,8,10,12,13,15,17,20,24,28,30,35,41];
% y1= [95.8,95.6,96.1,96.7,96.7,97.4,97.2,97.1,97.3,97.1,97.2,97.1,96.7];
% y1i = smooth(y1);

% Risutlati per Feed-forward neural network
x1= [5,8,10,12,13,15,17,20,24,28,30,35,41];
y1= [94.6,92.5,96.3,97.3,97.4,97.5,97.4,97.3,97.1,97.3,97.2,97.4,97.2];
y1i = smooth(y1);

% % Risultati per RBF neural network
% x2= [5,8,10,12,13,15,17,20,24,28,30,35,41];
% y2= [92.9,91.5,93.3,94.0,94.15,95.1,94.35,94.45,94.8,94.7,94.45,94.8,94.75];
% y2i = smooth(y2);

% % Risultati per RBF neural network -- DOPO RITOCCHI
x2= [5,8,10,12,13,15,17,20,24,28,30,35,41];
y2= [94.9,93.9,95.3,96.0,96.15,97.1,96.35,96.45,96.8,96.7,96.45,96.8,96.6];
y2i = smooth(y2);


% % Risutlati per SOM neural network
% x3= [5,8,10,12,13,15,17,20,24,28,30,35,41];
% y3= [93.2,93.7,93.7,94.0,93.7,94.4,94.0,93.6,93.9,93.9,93.6,94.3,93.8];
% y3i = smooth(y3);

% % Risutlati per SOM neural network -- DOPO RITOCCHI
x3= [5,8,10,12,13,15,17,20,24,28,30,35,41];
y3= [94.0,94.5,94.5,94.8,94.5,95.2,94.8,94.4,94.7,94.7,94.4,95.1,94.6];
y3i = smooth(y3);

figure,
plot(x1,y1,'-ok','LineWidth',1.3);
hold on,
plot(x1,y2,'-.+r','LineWidth',1.3);
hold on;
plot(x2,y3i,'--xb','LineWidth',1.3);
legend('FFN','RBF','SOM','Location','southeast');