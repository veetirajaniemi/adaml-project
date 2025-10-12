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

%filter_vars = [1 2 3 4 5 6 10 11 13 14 15 16 17 19 20 21 22 23 24 25];
%Select variables to remove
filter_vars = [12,9,17];%,17,16,19,18,14,20,23,24,25,21,13,1,2,15,7];

WT2_mean = mean(WT2,1);
WT2_std = std(WT2,1);


WT39_normalized = funcs.normalizeData(WT39,WT2_mean,WT2_std);

%% Plot filtered variables
figure
for i = 1:length(filter_vars)
    fi = filter_vars(i);
    subplot(5,5,i)
    plot(WT39_normalized(:,fi),'LineWidth',2)
    hold on
    xline(470, 'Color', 'r', 'LineWidth', 2);
    title(['Variable ',num2str(fi)])
    ax = gca;
    ax.FontSize = 20;

end
sgt = sgtitle('Removed variables, WT39 normalized')
sgt.FontSize = 20;




WT2(:,filter_vars) = [];
WT39(:,filter_vars) = [];
vars(filter_vars) = [];

WT2_mean = mean(WT2,1);
WT2_std = std(WT2,1);
WT2_normalized = funcs.normalizeData(WT2,WT2_mean,WT2_std);
WT39_normalized = funcs.normalizeData(WT39,WT2_mean,WT2_std);


%% PCA with removed variables
[coeffs, scores, latent, tsq, explained] = pca(WT2_normalized, 'Centered', false);
figure;
bar(latent, 'FaceColor',[0.2 0.6 0.8]);
xlabel('Principal Component');
ylabel('Eigenvalue (Variance)');
title('Eigenvalues of Principal Components');
grid on;

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

sgt = sgtitle('PCA-based Control Charts')
sgt.FontSize = 20;


%%

% 470 is the anomaly point
anomaly = 470;
WT39_normalized_start = WT39_normalized(1:anomaly-1,:)
WT39_normalized_end = WT39_normalized(anomaly+1:end,:)


T2_f2 = funcs.t2comp(WT39_normalized, coeffs, latent, k);
Q_f2  = funcs.qcomp(WT39_normalized,  coeffs, k);
figure;

subplot(1,2,1)
funcs.plot_T2((T2_f2),(mu_T2),(warn_T2),(alarm_T2),k,plotcol)
ax = gca;
ax.FontSize = 20;
subplot(1,2,2)
funcs.plot_Q((Q_f2),(mu_Q), (warn_Q), (alarm_Q), k, plotcol)
ax = gca;
ax.FontSize = 20;
sgt = sgtitle('PCA-based Control Charts')
sgt.FontSize = 20;
% figure
% subplot(1,2,1)
% funcs.plot_T2(log10(T2_f2),log10(mu_T2),log10(warn_T2),log10(alarm_T2),k,plotcol)
% ylabel('log10 T^2')
% ax = gca;
% ax.FontSize = 20;
% subplot(1,2,2)
% funcs.plot_Q(log10(Q_f2),log10(mu_Q), log10(warn_Q), log10(alarm_Q), k, plotcol)
% ylabel('log10 Q')
% sgt = sgtitle('PCA-based Control Charts')
% sgt.FontSize = 20;
idx = 773;
idxObs = anomaly + idx;
ax = gca;
ax.FontSize = 20;
idxObs = 470;

xrow = WT39_normalized(idxObs, :);
T2_contrib = funcs.t2contr(xrow, coeffs, latent, k);

Q_contrib  = funcs.qcontr(xrow,  coeffs, k);
T2_val = funcs.t2comp(xrow, coeffs, latent, k);
Q_val  = funcs.qcomp(xrow,  coeffs, k);
funcs.plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k, vars)

%% Projecting to healthy pca


scores_WT39_projected = WT39_normalized * coeffs
scores_WT2 = scores

burgundy = [0.50 0.00 0.00];
darkCyan = [0.00 0.40 0.40];
lw = 3; ms = 3;

for p = 1:k-1
    q = p + 1;

    SH = scores_WT2(:,[p q]);
    SF = scores_WT39_projected(:,[p q]);
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