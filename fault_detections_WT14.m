%% INFO

% In this script we try to detect faulty sensors by removing different variables
% from our PCA model and seeing its' effects. Control charts and biplots
% are used. 

%% Data Preprocessing, remove variables

clearvars
close all
clc

funcs = ownFunctions(); % use helper functions

% preprocess + normalize data
path = 'data.xlsx';
[WT2, WT14, WT39] = funcs.preprocessData(path);
[WT2] = funcs.removeOutliers(WT2);

vars = "var-" + (1:25);


%Remove variables
WT2(:,[1 2 3 4 5 6 10 11 13 14 15 16 17 19 20 21 22 23 24 25]) = [];
WT14(:,[1 2 3 4 5 6 10 11 13 14 15 16 17 19 20 21 22 23 24 25]) = [];
WT39(:,[1 2 3 4 5 6 10 11 13 14 15 16 17 19 20 21 22 23 24 25]) = [];
vars([1 2 3 4 5 6 10 11 13 14 15 16 17 19 20 21 22 23 24 25]) = []

WT2_mean = mean(WT2,1);
WT2_std = std(WT2,1);
WT2_normalized = funcs.normalizeData(WT2,WT2_mean,WT2_std);

%% PCA with removed variables
k=5;
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

sgtitle('PCA-based Control Charts')  

%% Testing WT14
close all

WT14_normalized = funcs.normalizeData(WT14,WT2_mean,WT2_std);

% figure
% for i = 11:15
%     subplot(1,5,i-10)
%     plot(WT14_normalized(:,i))
%     hold on
%     xline(359, 'Color', 'r', 'LineWidth', 2);
% end
% sgtitle('Variables 11-15, WT14 normalized')

%%

% 359 is the anomaly point
anomaly = 359;
WT14_normalized_start = WT14_normalized(1:anomaly-1,:)
WT14_normalized_end = WT14_normalized(anomaly+1:end,:)


T2_f2 = funcs.t2comp(WT14_normalized, coeffs, latent, k);   
Q_f2  = funcs.qcomp(WT14_normalized,  coeffs, k);   
figure;

subplot(1,2,1)
funcs.plot_T2(T2_f2,mu_T2,warn_T2,alarm_T2,k,plotcol)

subplot(1,2,2)
funcs.plot_Q(Q_f2,mu_Q, warn_Q, alarm_Q, k, plotcol)
sgtitle('PCA-based Control Charts') 

%anomaly = 359;
%idx = 217;
%idxObs = anomaly + idx;

idxObs = 170

xrow = WT14_normalized(idxObs, :);  
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);  
            
Q_contrib  = funcs.qcontr(xrow,  coeffs, k);            
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);
funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k, vars)

%% Projecting to healthy pca


scores_WT14_projected = WT14_normalized * coeffs
scores_WT2 = scores

burgundy = [0.50 0.00 0.00];
darkCyan = [0.00 0.40 0.40];
lw = 3; ms = 3;

for p = 1:4
    q = p + 1;

    SH = scores_WT2(:,[p q]);
    SF = scores_WT14_projected(:,[p q]);
    scores_pair = [SH; SF];

    allScores = [SH; SF];
    xmin = min(allScores(:,1)); xmax = max(allScores(:,1));
    ymin = min(allScores(:,2)); ymax = max(allScores(:,2));
    mx = 0.05*max(1, xmax - xmin); my = 0.05*max(1, ymax - ymin);

    figure('Color','w');
    tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

    nexttile;
    biplot(coeffs(:,[p q]), 'Scores', scores_pair, 'VarLabels', vars);
    title(sprintf('Biplot PC%d–PC%d', p, q));
    xlabel(sprintf('PC%d (%.1f%%)', p, explained(p)));
    ylabel(sprintf('PC%d (%.1f%%)', q, explained(q)));

    nexttile; hold on; box on; grid on;
    plot(SH(:,1), SH(:,2), 'o', 'MarkerFaceColor', burgundy, ...
        'MarkerEdgeColor', burgundy, 'LineWidth', lw, 'MarkerSize', ms);
    plot(SF(:,1), SF(:,2), 'o', 'MarkerFaceColor', darkCyan, ...
        'MarkerEdgeColor', darkCyan, 'LineWidth', lw, 'MarkerSize', ms);
    xlabel(sprintf('PC%d (%.1f%%)', p, explained(p)));
    ylabel(sprintf('PC%d (%.1f%%)', q, explained(q)));
    title('Score plot');
    legend({'Healthy','Faulty'}, 'Location','best');
    xlim([xmin-mx, xmax+mx]); ylim([ymin-my, ymax+my]);
    hold off;
end