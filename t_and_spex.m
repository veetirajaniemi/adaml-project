%% Data Preprocessing

clearvars
close all
clc

funcs = ownFunctions(); % use helper functions

% preprocess + normalize data
path = 'data.xlsx';
[WT2, WT14, WT39] = funcs.preprocessData(path);
WT2_normalized = funcs.normalizeData(WT2);


%% PCA healthy data
k=11;
[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered', false, 'NumComponents', k);

T2_h        = funcs.t2comp(WT2_normalized, coeffs, latent, k);   
Q_h         = funcs.qcomp(WT2_normalized,  coeffs, k);            

mu_T2       = mean(T2_h);  
sd_T2       = std(T2_h);
mu_Q        = mean(Q_h);   
sd_Q        = std(Q_h);

warn_T2     = mu_T2 + 2*sd_T2;   
alarm_T2    = mu_T2 + 3*sd_T2;
warn_Q      = mu_Q  + 2*sd_Q;    
alarm_Q     = mu_Q  + 3*sd_Q;

plotcol     = [0.5 0 0];   
figure;
subplot(1,2,1)
funcs.plot_T2(T2_h,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(T2_h,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts')  % yhteinen otsikko

% variable contribution charts can be used to spot the variable that causes
% outlier
for idxObs = [1423, 1022, 1372]
    xrow = WT2_normalized(idxObs, :);  
    T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
    Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
    T2_val = funcs.t2comp(xrow, coeffs, latent, k);
    Q_val  = funcs.qcomp(xrow,  coeffs, k);
    
    burgundy = [0.50 0.00 0.00];
    darkCyan = [0.00 0.40 0.40];
    
    figure('Color','w');
    tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
    
    nexttile;
    bar(T2_contrib, 'FaceColor', burgundy, 'EdgeColor', 'none');
    title(sprintf('T^2 Variable Contributions — obs %d (k=%d), T^2=%.3g', idxObs, k, T2_val));
    ylabel('Contribution');
    grid on; box on;
    
    nexttile;
    bar(Q_contrib, 'FaceColor', darkCyan, 'EdgeColor', 'none');
    title(sprintf('SPE (Q) Variable Contributions — obs %d, Q=%.3g', idxObs, Q_val));
    ylabel('Contribution');
    grid on; box on;
end
figure
plot(WT2_normalized(:,12))
xlabel('Sample index');
title("Variable n.o 12")


%% remove outliers from column 12


WT2(1423:1426,12) = WT2(1422,12);
WT2(1372:1373,12) = WT2(1371,12);
WT2(1022:1023,12) = WT2(1021,12);

WT2_normalized = funcs.normalizeData(WT2);
% PCA healthy data
k=11;
[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered', false, 'NumComponents', k);

T2_h        = funcs.t2comp(WT2_normalized, coeffs, latent, k);   
Q_h         = funcs.qcomp(WT2_normalized,  coeffs, k);            

mu_T2       = mean(T2_h);  
sd_T2       = std(T2_h);
mu_Q        = mean(Q_h);   
sd_Q        = std(Q_h);

warn_T2     = mu_T2 + 2*sd_T2;   
alarm_T2    = mu_T2 + 3*sd_T2;
warn_Q      = mu_Q  + 2*sd_Q;    
alarm_Q     = mu_Q  + 3*sd_Q;

plotcol     = [0.5 0 0];   

figure;

subplot(1,2,1)
funcs.plot_T2(T2_h,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(T2_h,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts')  
% there is still outlier

idxObs = 861;
xrow = WT2_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);

burgundy = [0.50 0.00 0.00];
darkCyan = [0.00 0.40 0.40];

figure('Color','w');
tiledlayout(2,1,'TileSpacing','compact','Padding','compact');

nexttile;
bar(T2_contrib, 'FaceColor', burgundy, 'EdgeColor', 'none');
title(sprintf('T^2 Variable Contributions — obs %d (k=%d), T^2=%.3g', idxObs, k, T2_val));
ylabel('Contribution');
grid on; box on;

nexttile;
bar(Q_contrib, 'FaceColor', darkCyan, 'EdgeColor', 'none');
title(sprintf('SPE (Q) Variable Contributions — obs %d, Q=%.3g', idxObs, Q_val));
ylabel('Contribution');
grid on; box on;

figure
plot(WT2(:,16))
% remove outlier from column 16
WT2(861,16) = WT2(860,16);

% pca without outliers:

WT2_normalized = funcs.normalizeData(WT2);
% PCA healthy data
k=11;
[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered', false, 'NumComponents', k);

T2_h        = funcs.t2comp(WT2_normalized, coeffs, latent, k);   
Q_h         = funcs.qcomp(WT2_normalized,  coeffs, k);            

mu_T2       = mean(T2_h);  
sd_T2       = std(T2_h);
mu_Q        = mean(Q_h);   
sd_Q        = std(Q_h);

warn_T2     = mu_T2 + 2*sd_T2;   
alarm_T2    = mu_T2 + 3*sd_T2;
warn_Q      = mu_Q  + 2*sd_Q;    
alarm_Q     = mu_Q  + 3*sd_Q;

plotcol     = [0.5 0 0];   

figure;

subplot(1,2,1)
funcs.plot_T2(T2_h,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(T2_h,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts')  % yhteinen otsikko


%% faulty turbines projected

% Normalization
WT39_normalized = funcs.normalizeData(WT39);

T2_f = funcs.t2comp(WT39_normalized, coeffs, latent, k);   
Q_f  = funcs.qcomp(WT39_normalized,  coeffs, k);   
figure;

subplot(1,2,1)
funcs.plot_T2(T2_f,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(T2_f,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts') 

% Normalization
WT14_normalized = funcs.normalizeData(WT14);

T2_f2 = funcs.t2comp(WT14_normalized, coeffs, latent, k);   
Q_f2  = funcs.qcomp(WT14_normalized,  coeffs, k);   
figure;

subplot(1,2,1)
funcs.plot_T2(T2_f2,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(T2_f2,mu_Q, warn_Q, alarm_Q, k, plotcol)
sgtitle('PCA-based Control Charts') 

%% Variable contributions WT14 (T^2&Q piikin kohdalla)

idxObs = 358;
xrow = WT14_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);

funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k)

% Variable contributions WT39 (T^2&Q piikin kohdalla)

idxObs = 470;
xrow = WT39_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);

funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k)
