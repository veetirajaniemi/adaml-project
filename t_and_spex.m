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
plot(T2_h,'-','LineWidth',1.2,'Color',plotcol);
hold on
yline(mu_T2,'-','Color',[0.2 0.2 0.2]);
yline(warn_T2,'--','Color',[0.3 0.3 0.3],'LineWidth',2);
yline(alarm_T2,'-','Color',[0.3 0.3 0.3],'LineWidth',2);
xlabel('Sample index');
ylabel('T^2');
title(sprintf('T^2 Control Chart',k));
legend({'T^2','Mean','Warning (95%C.I.)','Alarm (99.5%C.I.)'},'Location','best');
grid on
hold off

subplot(1,2,2)
plot(Q_h,'-','LineWidth',1.2,'Color',plotcol);
hold on
yline(mu_Q,'-','Color',[0.2 0.2 0.2]);
yline(warn_Q,'--','Color',[0.3 0.3 0.3],'LineWidth',2);
yline(alarm_Q,'-','Color',[0.3 0.3 0.3],'LineWidth',2);
xlabel('Sample index');
ylabel('Q (SPE)');
title(sprintf('Q Control Chart',k));
legend({'Q','Mean','Warning (95%C.I.)','Alarm (99.5%C.I.)'},'Location','best');
grid on
hold off

sgtitle('PCA-based Control Charts')  % yhteinen otsikko

figure
plot(WT2_normalized(:,12))
xlabel('Sample index');
title("Variable n.o 12")



%% remove outliers


WT2(1423:1426,12) = WT2(1422,12);
WT2(1372:1373,12) = WT2(1371,12);
WT2(1022:1023,12) = WT2(1021,12);
plot(WT2(:,16))
WT2(861,16) = WT2(860,16);

WT2_normalized = zscore(WT2);
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
plot(T2_h,'-','LineWidth',1.2,'Color',plotcol);
hold on
yline(mu_T2,'-','Color',[0.2 0.2 0.2]);
yline(warn_T2,'--','Color',[0.3 0.3 0.3],'LineWidth',2);
yline(alarm_T2,'-','Color',[0.3 0.3 0.3],'LineWidth',2);
xlabel('Sample index');
ylabel('T^2');
title(sprintf('T^2 Control Chart',k));
legend({'T^2','Mean','Warning (95%C.I.)','Alarm (99.5%C.I.)'},'Location','best');
grid on
hold off

subplot(1,2,2)
plot(Q_h,'-','LineWidth',1.2,'Color',plotcol);
hold on
yline(mu_Q,'-','Color',[0.2 0.2 0.2]);
yline(warn_Q,'--','Color',[0.3 0.3 0.3],'LineWidth',2);
yline(alarm_Q,'-','Color',[0.3 0.3 0.3],'LineWidth',2);
xlabel('Sample index');
ylabel('Q (SPE)');
title(sprintf('Q Control Chart',k));
legend({'Q','Mean','Warning (95%C.I.)','Alarm (99.5%C.I.)'},'Location','best');
grid on
hold off

sgtitle('PCA-based Control Charts')  % yhteinen otsikko

