%Summaries of the datasets

clearvars
close all
clc

%Wind-turbine datasets
path = 'data.xlsx';
WT2 = readmatrix(path,Sheet=1,NumHeaderLines=1);
WT3 = readmatrix(path,Sheet=2,NumHeaderLines=1);
WT14 = readmatrix(path,Sheet=3,NumHeaderLines=1);
WT39 = readmatrix(path,Sheet=4,NumHeaderLines=1);


%Summaries for datatables
row_names = {'Count','Mean','Std','Min','P25','P50','P75','Max'}
var_names = ""
%Turbine 2
for i = 1:size(WT2,2)
    var_names = var_names + " " + ['Var-',num2str(i)];
    WT2_count(i) = nnz(~isnan(WT2(:,i)));
    WT2_mean(i) = mean(WT2(:,i));
    WT2_std(i) = std(WT2(:,i));
    WT2_min(i) = min(WT2(:,i));
    WT2_p25(i) = prctile(WT2(:,i),25);
    WT2_p50(i) = prctile(WT2(:,i),50);
    WT2_p75(i) = prctile(WT2(:,i),75);
    WT2_max(i) = max(WT2(:,i));

end
var_names = split(var_names)
WT2_summary = table(WT2_count',WT2_mean',WT2_std', ...
    WT2_min',WT2_p25',WT2_p50',WT2_p75',WT2_max','VariableNames',row_names,'RowNames',var_names(2:end))



var_names = ""
%Turbine 3
for i = 1:size(WT3,2)
    var_names = var_names + " " + ['Var-',num2str(i)];
    WT3_count(i) = nnz(~isnan(WT3(:,i)));
    WT3_mean(i) = mean(WT3(:,i));
    WT3_std(i) = std(WT3(:,i));
    WT3_min(i) = min(WT3(:,i));
    WT3_p25(i) = prctile(WT3(:,i),25);
    WT3_p50(i) = prctile(WT3(:,i),50);
    WT3_p75(i) = prctile(WT3(:,i),75);
    WT3_max(i) = max(WT3(:,i));

end
var_names = split(var_names)
WT3_summary = table(WT3_count',WT3_mean',WT3_std', ...
    WT3_min',WT3_p25',WT3_p50',WT3_p75',WT3_max','VariableNames',row_names,'RowNames',var_names(2:end))


var_names = ""
%Turbine 14
for i = 1:size(WT14,2)
    var_names = var_names + " " + ['Var-',num2str(i)];
    WT14_count(i) = nnz(~isnan(WT14(:,i)));
    WT14_mean(i) = mean(WT14(~isnan(WT14(:,i)),i));
    WT14_std(i) = std(WT14(~isnan(WT14(:,i)),i));
    WT14_min(i) = min(WT14(:,i));
    WT14_p25(i) = prctile(WT14(:,i),25);
    WT14_p50(i) = prctile(WT14(:,i),50);
    WT14_p75(i) = prctile(WT14(:,i),75);
    WT14_max(i) = max(WT14(:,i));

end
var_names = split(var_names)
WT14_summary = table(WT14_count',WT14_mean',WT14_std', ...
    WT14_min',WT14_p25',WT14_p50',WT14_p75',WT14_max','VariableNames',row_names,'RowNames',var_names(2:end))

var_names = ""
%Turbine 39
for i = 1:size(WT39,2)
    var_names = var_names + " " + ['Var-',num2str(i)];
    WT39_count(i) = nnz(~isnan(WT39(:,i)));
    WT39_mean(i) = mean(WT39(:,i));
    WT39_std(i) = std(WT39(:,i));
    WT39_min(i) = min(WT39(:,i));
    WT39_p25(i) = prctile(WT39(:,i),25);
    WT39_p50(i) = prctile(WT39(:,i),50);
    WT39_p75(i) = prctile(WT39(:,i),75);
    WT39_max(i) = max(WT39(:,i));

end
var_names = split(var_names);
WT39_summary = table(WT39_count',WT39_mean',WT39_std', ...
    WT39_min',WT39_p25',WT39_p50',WT39_p75',WT39_max','VariableNames',row_names,'RowNames',var_names(2:end))



%% Visualizations of the measurements
clearvars
close all
clc
%Wind-turbine datasets
path = 'data.xlsx';
WT2 = readmatrix(path,Sheet=1,NumHeaderLines=1);
WT14 = readmatrix(path,Sheet=3,NumHeaderLines=1);
WT39 = readmatrix(path,Sheet=4,NumHeaderLines=1);

%Remove last column from turbine 2
WT2 = WT2(:,1:end-1);


%Plot sensor measurements.
%One figure for each sensor, subplots for turbines

for i = 1:27
    figure
    
    subplot(3,1,1)
    
    plot(WT2(:,i),'LineWidth',2)
    legend('WT2')

    ax = gca;
    ax.FontSize = 20;
    subplot(3,1,2)
    
    %Insert title, for some it doesn't work
    title(['Variable ',num2str(i)]);
    plot(WT14(:,i),'LineWidth',2)
    hold on
    %Draw lines to measurements with anomaly lines
    xline(288,'r--','LineWidth',2)
    xline(358,'r--','LineWidth',2)
    legend('WT14','Anomaly observation')

    ax = gca;
    ax.FontSize = 20;

    subplot(3,1,3)
    plot(WT39(:,i),'LineWidth',2)
    hold on
    xline(470,'r--','LineWidth',2)
    legend('WT39','Anomaly observation')
    
    ax = gca;
    ax.FontSize =20;
end

%%

%Compare wind-turbine variable values when healthy
clearvars
close all
clc
%Wind-turbine datasets
path = 'data.xlsx';
WT2 = readmatrix(path,Sheet=1,NumHeaderLines=1);
WT14 = readmatrix(path,Sheet=3,NumHeaderLines=1);
WT39 = readmatrix(path,Sheet=4,NumHeaderLines=1);

%Remove last column from turbine 2
WT2 = WT2(:,1:end-1);

for i = 1:27
    figure
    plot(WT2(:,i))
    hold on
    plot(WT14(359:end,i),'r--')
    plot(WT39(471:end,i),'o--')
end

%% Variable correlations
clearvars
close all
clc

path = 'data.xlsx';
WT2 = readmatrix(path,Sheet=1,NumHeaderLines=1);
WT14 = readmatrix(path,Sheet=3,NumHeaderLines=1);
WT39 = readmatrix(path,Sheet=4,NumHeaderLines=1);

%Remove last column from turbine 2
WT2 = WT2(:,1:end-1);


WTcombined = [WT2;WT14;WT39];

%Correlation
WTcombined(any(isnan(WTcombined),2),:) = [];
r=corr(WTcombined);

h = heatmap(round(r,2));
colorbar
