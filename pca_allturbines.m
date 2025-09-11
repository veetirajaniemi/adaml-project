clearvars
close all
clc

path = 'data.xlsx';
WT2 = readmatrix(path,Sheet=1,NumHeaderLines=1);
WT14 = readmatrix(path,Sheet=3,NumHeaderLines=1);
WT39 = readmatrix(path,Sheet=4,NumHeaderLines=1);

%%

WT2(:,15) = [];
WT2(:,12) = [];
WT2(:, end) = [];
count2 = length(WT2);

%%

WT14(:,15) = [];
WT14(:,12) = [];
WT14(358,:) = [];
WT14_all = WT14;

%%
WT14_faulty = WT14(1:357,:);
WT14_good = WT14(358:end,:);
count14 = length(WT14_good);

%%

WT39(:,15) = [];
WT39(:,12) = [];
WT39_all = WT39;
WT39_faulty = WT39(1:470, :);
WT39_good = WT39(471:end,:);
count39 = length(WT39_good);
WT_good = [WT2;WT39_good;WT14_good];

%%
X_obs = WT_good;
X_z = zscore(X_obs); % z-score normalization
X_cov = cov(X_z);


[eigVec, eigVal] = eig(X_cov);
[lamb, idx] = sort(diag(eigVal), 'descend');
W = eigVec(:, idx);

T = X_z * W

pcs = 6 % rule of thumb, close to one

PC = X_z * W(:,1:pcs)

cumLamb = cumsum(lamb / sum(lamb))
figure
semilogy(cumLamb)
xlabel("Principal Component")
ylabel("Cumulative Variance Explained")
%%
% Let's try a 3D plot
close all

index2_end = count2
index14_end = index2_end + count14
index39_end = index14_end + count39

WT14_faulty_norm = zscore(WT14_faulty)
WT39_faulty_norm = zscore(WT39_faulty)

WT14_faulty_PC = WT14_faulty_norm * W(:,1:pcs)
WT39_faulty_PC = WT39_faulty_norm * W(:,1:pcs)



subplot(1,2,1)
grid on
hold on
plot(PC(1:index2_end,1),PC(1:index2_end,2), 'g*')
hold on
plot(PC(index14_end+1:index39_end,1),PC(index14_end+1:index39_end,2), 'k*')
hold on
plot(PC(index2_end+1:index14_end,1),PC(index2_end+1:index14_end,2), 'c*')
hold on
plot(WT14_faulty_PC(:,1), WT14_faulty_PC(:,2), 'm*')
hold on
plot(WT39_faulty_PC(:,1), WT39_faulty_PC(:,2), 'y*')
xlabel('PC1'), ylabel('PC2')
legend('WT2', 'WT39', 'WT14', 'WT14 faulty', 'WT39 faulty')

subplot(1,2,2)
hold on
grid on
hold on
plot3(PC(1:index2_end,1),PC(1:index2_end,2),PC(1:index2_end,3), 'g*')
hold on
plot3(PC(index14_end+1:index39_end,1),PC(index14_end+1:index39_end,2),PC(index14_end+1:index39_end,3), 'k*')
hold on
plot3(PC(index2_end+1:index14_end,1),PC(index2_end+1:index14_end,2),PC(index2_end+1:index14_end,3), 'c*')
hold on
plot3(WT14_faulty_PC(:,1), WT14_faulty_PC(:,2), WT14_faulty_PC(:,3), 'm*')
hold on
plot3(WT39_faulty_PC(:,1), WT39_faulty_PC(:,2), WT39_faulty_PC(:,3), 'y*')
xlabel('PC1'), ylabel('PC2'), zlabel('PC3')
axis([-10 10  -3 5  -3 3])
view(25, 20)
%legend('WT2', 'WT39', 'WT14', 'WT14 faulty', 'WT39 faulty')
sgtitle("2D and 3D PCA Plots")

%%
close all


sgtitle('Biplot for each Turbine')
subplot(1,3,1)
biplot(W(:,1:2), scores=T(1:index2_end,1:2))
title('WT2')
subplot(1,3,2)
scoreMatrix = [T(index2_end+1:index14_end,1:2);WT14_faulty_norm(:,1:2)]
biplot(W(:,1:2), scores=scoreMatrix)
title('WT14')
subplot(1,3,3)
scoreMatrix = [T(index14_end+1:index39_end,1:2);WT39_faulty_norm(:,1:2)]
biplot(W(:,1:2), scores=scoreMatrix)
title('WT39')


