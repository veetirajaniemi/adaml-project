%% Function scripts used in the project

% Not to run, only the helper function scripts so don't need to repeat all
% :)

% The functions for computing and visualizing T^2 and SPEx control charts
% from Workshop 1 material by Zina-Sabrina Duma

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
            nanInd = find(isnan(WT14));
            WT14(nanInd) = mean(WT14(nanInd-1), WT14(nanInd+1));
            
            % WT39, remove extra variables
            WT39(:,15) = [];
            WT39(:,12) = [];
        end
       
        function normalized = normalizeData(data,mean,sd)
            normalized = (data - mean)./sd;
        end

        function WT2  = removeOutliers(WT2)
            WT2(1423:1426,12) = NaN;
            WT2(1372:1373,12) = NaN;
            WT2(1022:1023,12) = NaN;
            WT2(861,16) = NaN;
            WT2 = fillmissing(WT2, 'linear');
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

        function plot_T2(data, mu_T2, warn_T2, alarm_T2, k,plotcol)
 
            plot(data,'-','LineWidth',1.2,'Color',plotcol);
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
        end

        function plot_Q(data, mu_Q, warn_Q, alarm_Q, k,plotcol)
            plot(data,'-','LineWidth',1.2,'Color',plotcol);
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
        end

        function plot_var_contr(T2_contrib,Q_contrib, T2_val, Q_val, idxObs, k, varLabels)
            burgundy = [0.50 0.00 0.00];
            darkCyan = [0.00 0.40 0.40];
            
            figure('Color','w');
            tiledlayout(2,1,'TileSpacing','compact','Padding','compact');
            
            nexttile;
            bar(T2_contrib, 'FaceColor', burgundy, 'EdgeColor', 'none');
            title(sprintf('T^2 Variable Contributions — obs %d (k=%d), T^2=%.3g', idxObs, k, T2_val));
            ylabel('Contribution');
            xticks(1:length(varLabels));
            xticklabels(varLabels)
            grid on; box on;
            
            nexttile;
            bar(Q_contrib, 'FaceColor', darkCyan, 'EdgeColor', 'none');
            title(sprintf('SPE (Q) Variable Contributions — obs %d (k=%d), Q=%.3g', idxObs, k, Q_val));
            xticks(1:length(varLabels));
            xticklabels(varLabels)
            ylabel('Contribution');
            grid on; box on;
        end

        
    end
end
