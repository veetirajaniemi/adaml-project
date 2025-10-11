%% INFO

% This script was used for testing the PCA and investigating it, possible outliers
% and the control charts.


% The PCA model with the healthy data is first created. We detect 
% outliers and see how PCA's behaviour changes based on then and try to confirm
% our findings. Then, we visualize also the faulty turbine data with the
% control charts and try to find variables causing the errors.


%% Data Preprocessing

clearvars
close all
clc

funcs = ownFunctions(); % use helper functions

% preprocess + normalize data
path = 'data.xlsx';
[WT2, WT14, WT39] = funcs.preprocessData(path);

WT2_mean = mean(WT2,1);
WT2_std = std(WT2,1);
WT2_normalized = funcs.normalizeData(WT2,WT2_mean,WT2_std);



%% PCA with healthy data
close all

k=6; % rule of thumb, eigenvals > 1
[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered', false, 'NumComponents', k);

% values for T^2 and Q statistics

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

%plotting explained variance
figure
plot(cumsum(explained)/sum(explained))

% plotting control charts  
figure;
subplot(1,2,1)
funcs.plot_T2(T2_h,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(Q_h,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts')  

% variable contribution charts can be used to spot the variable that causes
% outliers

for idxObs = [1423, 1022, 1372] % testing possible outlier values
    xrow = WT2_normalized(idxObs, :);  
    T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
    Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
    T2_val = funcs.t2comp(xrow, coeffs, latent, k);
    Q_val  = funcs.qcomp(xrow,  coeffs, k);
    
    funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k)
end


%% Interpolate outliers from variable 12
close all

figure
plot(WT2(:,12))

WT2(1423:1426,12) = NaN;
WT2(1372:1373,12) = NaN;
WT2(1022:1023,12) = NaN;
WT2 = fillmissing(WT2, 'linear')

plot(WT2(:,12))

%% PCA again after variable 12 modified, same visualizations
close all

WT2_mean = mean(WT2,1);
WT2_std = std(WT2,1);
WT2_normalized = funcs.normalizeData(WT2,WT2_mean,WT2_std);

[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered', true, 'NumComponents', k);

k=6;
figure

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
funcs.plot_Q(Q_h,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts')  

% Still possible outlier

%% Visualizing possible outlier in variable 16 
close all

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
title('Variable 16')
plot(WT2(:,16))

%% Removing outlier from variable 16
close all
% remove outlier from column 16

figure
plot(WT2(:,16))
WT2(861,16) = NaN
WT2 = fillmissing(WT2, 'linear')
figure
plot(WT2(:,16))

%% PCA for healthy data without outliers
close all

WT2_mean = mean(WT2,1);
WT2_std = std(WT2,1);
WT2_normalized = funcs.normalizeData(WT2,WT2_mean,WT2_std);
% PCA healthy data
k=6;
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
funcs.plot_Q(Q_h,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts')  % yhteinen otsikko

%% Variable contributions WT2 
close all

idxObs = 1376;
xrow = WT2_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);

funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k)



%% Control charts with faulty turbine WT14


WT14_normalized = funcs.normalizeData(WT14,WT2_mean,WT2_std);

% 359 is the found anomaly point
anomaly = 359;
WT14_normalized_start = WT14_normalized(1:anomaly-1,:)
WT14_normalized_end = WT14_normalized(anomaly+1:end,:)

figure
for i = 1:25
    subplot(5,5,i)
    plot(WT14_normalized_end(:,i))
end
figure
for i = 1:25
    subplot(5,5,i)
    plot(WT14_normalized_end(:,i))
end

T2_f2 = funcs.t2comp(WT14_normalized_end, coeffs, latent, k);   
Q_f2  = funcs.qcomp(WT14_normalized_end,  coeffs, k);   
figure;

subplot(1,2,1)
funcs.plot_T2(T2_f2,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(Q_f2,mu_Q, warn_Q, alarm_Q, k, plotcol)
sgtitle('PCA-based Control Charts') 

%% Variable contributions WT14
close all
% Errors in indices 18, 27, 217, 285
anomaly = 359;
idx = 217;

idxObs = anomaly + idx;
xrow = WT14_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);
funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k)

% Variable number 12 is contributing to everything!

%% Control charts with faulty turbine WT39


% Normalization
WT39_normalized = funcs.normalizeData(WT39,WT2_mean,WT2_std);

% figure
% for i = 1:25
%     subplot(5,5,i)
%     plot(WT39_normalized(1:469,i))
% end
% figure
% for i = 1:25
%     subplot(5,5,i)
%     plot(WT39_normalized(472:end,i))
% end

sgtitle('WT2 Normalized Variables')
WT39_normalized = WT39_normalized(472:end,:)

T2_f = funcs.t2comp(WT39_normalized, coeffs, latent, k);   
Q_f  = funcs.qcomp(WT39_normalized,  coeffs, k);   
figure;

subplot(1,2,1)
funcs.plot_T2(T2_f,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(Q_f,mu_Q, warn_Q, alarm_Q, k, plotcol)

sgtitle('PCA-based Control Charts') 

%% Variable contributions WT39

idxObs = 470;
xrow = WT39_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);

funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k)
