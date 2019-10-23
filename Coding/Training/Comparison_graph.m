clear all;
close all;

% xtl = {'FFN' 'RBF' 'SOM'};
% data = rand(6,3)+3;
% data = [97.61 99.17 99.31; 96.98 95.37 96.12; 95.2 96.54 96.96];

xtl = {'FFN' 'RBF' 'SOM'};
data = [0.46 1.86; 2.14 0.58; 1.62 1.25];

% Immagine per accuratezza, precision e recall
% figure(1)
% hb = bar(data-92)
% set(gca, 'XtickLabel', xtl)
% set(gca, 'YTick', [0:10:100], 'YTickLabel',[0:10:1]+92)
% legend('False positive','False negative','Location','northeast');

% immagine per false negative e false positive
figure(1)
hb = bar(data,0.9);
set(gca, 'XtickLabel', xtl)
set(gca, 'YTick', [0:10:2.2], 'YTickLabel',[0:10:1]+0)
legend('False positive','False negative','Location','northeast');