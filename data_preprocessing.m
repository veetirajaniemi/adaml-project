%% Data Preprocessing and Visualization

clearvars
close all
clc

path = 'data.xlsx';
WT2 = readmatrix(path,Sheet=1,NumHeaderLines=1);
WT14 = readmatrix(path,Sheet=3,NumHeaderLines=1);
WT39 = readmatrix(path,Sheet=4,NumHeaderLines=1);

% WT2, remove extra variables
WT2(:,15) = [];
WT2(:,12) = [];
WT2(:, end) = [];
count2 = length(WT2);

% WT14, remove extra variables
WT14(:,15) = [];
WT14(:,12) = [];

% NaN value interpolation
nanInd = find(isnan(WT14));
WT14(5846) = mean(WT14(5845), WT14(5847));

% WT39, remove extra variables
WT39(:,15) = [];
WT39(:,12) = [];


%% Visualizing WT2
close all;clc
WT2_normalized = zscore(WT2); % z-score normalization

figure
for i = 1:25
    subplot(5,5,i)
    hist(WT2_normalized(:,i))
end
sgtitle('WT2 - Histograms of Normalized Variables')

figure
for i = 1:25
    subplot(5,5,i)
    plot(WT2_normalized(:,i))
end
sgtitle('WT2 Normalized Variables')

figure
plot(WT2_normalized(:,12)) % 1022, 1372, 1423

WT2_normalized(1022,12) = (WT2_normalized(1021,12)+WT2_normalized(1023,12))/2
WT2_normalized(1372,12) = (WT2_normalized(1371,12)+WT2_normalized(1373,12))/2
WT2_normalized(1423,12) = (WT2_normalized(1422,12)+WT2_normalized(1424,12))/2

figure
plot(WT2_normalized(:,12))

figure
plot(WT2_normalized(:,16))


%%
sensor16 = WT2_normalized(:,16);
m = mean(sensor16)
sensor16(861) = mean(sensor16);
m2 = mean(sensor16)


%% PCA Testing
close all

[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered',false, 'NumComponents', 25);

figure;
for i = 1:6
    subplot(3,2,i);
    biplot(coeffs(:,i:i+1), 'Scores', scores(:,i:i+1));
end