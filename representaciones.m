%% Abrimos coeficientes LP
fileID = fopen('lp_3_4.txt','r');
formatSpec = '%f';
sizeA = [2 Inf];
LP = fscanf(fileID,formatSpec,sizeA);
LP = LP';
%% Abrimos coeficientes LPCC
fileID = fopen('lpcc_3_4.txt','r');
formatSpec = '%f';
sizeA = [2 Inf];
LPCC = fscanf(fileID,formatSpec,sizeA);
LPCC = LPCC';
%% Abrimos coeficientes LP
fileID = fopen('mfcc_3_4.txt','r');
formatSpec = '%f';
sizeA = [2 Inf];
MFCC = fscanf(fileID,formatSpec,sizeA);
MFCC = MFCC';
%% Plots
figure (1)
plot(LP(:,1),LP(:,2),'.r');
title('Coeficientes LP');
figure (2)
plot(LPCC(:,1),LPCC(:,2),'.r');
title('Coeficientes LPCC');
figure (3)
plot(MFCC(:,1),MFCC(:,2),'.r');
title('Coeficientes MFCC');