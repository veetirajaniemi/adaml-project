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

        % The following functions from workshop 1 codes!
        
        function T2varcontr    = t2contr(data, loadings, latent, comp)
            score           = data * loadings(:,1:comp);
            standscores     = bsxfun(@times, score(:,1:comp), 1./sqrt(latent(1:comp,:))');
            T2contr         = abs(standscores*loadings(:,1:comp)');
            T2varcontr      = sum(T2contr,1);
        end
        
        function Qcontr   = qcontr(data, loadings, comp, aggregate)
            score         = data * loadings(:,1:comp);
            reconstructed = score * loadings(:,1:comp)';
            residuals     = bsxfun(@minus, data, reconstructed);
        
            contrib = residuals.^2;  
        
            if nargin < 4 || isempty(aggregate)
                Qcontr = contrib;                 
            elseif strcmpi(aggregate, 'per-variable')
                Qcontr = sum(contrib, 1);         
            elseif strcmpi(aggregate, 'per-observation')
                Qcontr = sum(contrib, 2);        
            else
                error('qcontr:BadArg', 'aggregate must be [], ''per-variable'', or ''per-observation''.');
            end
        end
        
        function T2     = t2comp(data, loadings, latent, comp)
            score       = data * loadings(:,1:comp);
            standscores = bsxfun(@times, score(:,1:comp), 1./sqrt(latent(1:comp,:))');
            T2          = sum(standscores.^2,2);
        end
        
        function Qfac   = qcomp(data, loadings, comp)
            score       = data * loadings(:,1:comp);
            reconstructed = score * loadings(:,1:comp)';
            residuals   = bsxfun(@minus, data, reconstructed);
            Qfac        = sum(residuals.^2,2);
        end

    end
end
