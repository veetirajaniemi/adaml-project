%% Function scripts used in the project

% Not to run, only the helper function scripts so don't need to repeat all
% :)

classdef ownFunctions
    methods (Static)
        function [WT2, WT14, WT39] = preprocessData(path)
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
            nanInd = find(isnan(WT14))
            WT14(nanInd) = mean(WT14(nanInd-1), WT14(nanInd+1));
            
            % WT39, remove extra variables
            WT39(:,15) = [];
            WT39(:,12) = [];
        end
       
        function normalized = normalizeData(data)
            normalized = zscore(data)
        end

    end
end
