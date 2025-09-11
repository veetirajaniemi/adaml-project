clearvars
close all
clc

%Wind-turbine datasets
path = 'data.xlsx';
WT2 = readtable(path,Sheet=1,NumHeaderLines=1);
WT3 = readtable(path,Sheet=2,NumHeaderLines=1);
WT14 = readtable(path,Sheet=3,NumHeaderLines=1);
WT9 = readtable(path,Sheet=4,NumHeaderLines=1);