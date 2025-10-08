%% Data Preprocessing and Visualization

%% Preprocess and normalize data
clearvars
close all
clc

funcs = ownFunctions(); % use helper functions

% preprocess + normalize data
path = 'data.xlsx';
[WT2, WT14, WT39] = funcs.preprocessData(path)
WT2_normalized = funcs.normalizeData(WT2)


%% Visualizing preprocessed data

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


%% PCA Testing
close all
vars = "var-" + (1:25)

[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered',false, 'NumComponents', 11);

figure;
for i = 1:6
    subplot(3,2,i);
    biplot(coeffs(:,i:i+1), 'Scores', scores(:,i:i+1), 'VarLabels',vars);
end

figure
plot(cumsum(explained))
grid on
title('Cumulative Explained Variance of PCA')
xlabel('Number of PCs used')

figure
title('Biplot with the First 2 PCs')
hold on
grid on
biplot(coeffs(:,1:2), 'Scores', scores(:,1:2), 'VarLabels',vars);
xlabel('PC1')
ylabel('PC2')

