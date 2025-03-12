%% Create the options structure
clear
close all
clc
clear global processLog
global processLog

% File specification and variable designation
opts.files = {'Hourly_data_1970-2017.mat'};
opts.varNames = {'MK', 'SS', 'SZ', 'CW', 'DS', 'SSW', 'FBC', 'HP', 'ZY', 'GZ', 'DLS', 'HS', 'BJ', 'HJ', 'NH', 'HM', 'RQ', 'SD', 'SSJ', 'BSW', 'LS', 'NS', 'SSK', 'ZD'};
opts.varSymbols = {};
opts.varUnits = {};

% Load Results
load('dataInputData/Results_dataInputDataWithResolutions.mat', 'R', 'opts');

% Define variablePairs groups
allVariablePairs1 = {[1 10; 2 10; 3 10; 4 10]; [1 9; 2 9; 3 9; 4 9]; [1 11; 2 11; 3 11; 4 11]; [1 12; 2 12; 3 12; 4 12]; [1 13; 2 13; 3 13; 4 13]; [1 14; 2 14; 3 14; 4 14]};
allVariablePairs2 = {[1 18; 2 18; 3 18; 4 18]; [1 19; 2 19; 3 19; 4 19]; [1 20; 2 20; 3 20; 4 20]; [1 16; 2 16; 3 16; 4 16]};
allVariablePairs3 = {[1 8; 2 8; 3 8; 4 8]; [1 5; 2 5; 3 5; 4 5]; [1 6; 2 6; 3 6; 4 6]; [1 23; 2 23; 3 23; 4 23]; [1 22; 2 22; 3 22; 4 22]};
allVariablePairs4 = {[1 24; 2 24; 3 24; 4 24]; [1 21; 2 21; 3 21; 4 21]; [1 7; 2 7; 3 7; 4 7]; [1 15; 2 15; 3 15; 4 15]; [1 17; 2 17; 3 17; 4 17]};

colors = {'b', 'r', 'g', 'k'};
lineStyles = {'-', '--', ':', '-.'};
letters = 'abcdefghijklmnopqrstuvwxyz';

% Function to plot each figure based on a given statistic
function plotVariablePairsForStatistic(allVariablePairs, R, colors, lineStyles, letters, figName, statistic, thresholdField, ylabelText)
    figure;
    for k = 1:length(allVariablePairs)
        variablePairs = allVariablePairs{k};
        targetVarName = R.varNames{variablePairs(1, 2)};
        subplot(3, 2, k);
        hold on;
        legendEntries = {};

        for i = 1:size(variablePairs, 1)
            ri = variablePairs(i, 1);
            ci = variablePairs(i, 2);
            lagIndex = R.lagVect >= 0 & R.lagVect <= 50;
            Xp = squeeze(R.(statistic)(ri, ci, lagIndex));
            plot(R.lagVect(lagIndex), Xp, 'Color', colors{i}, 'LineStyle', lineStyles{i}, 'LineWidth', 1.5);
            legendEntries{end+1} = sprintf('%s to %s', R.varNames{ri}, R.varNames{ci});
        end

        significanceLevel = R.(thresholdField)(1, 1);
        plot([0 50], [significanceLevel significanceLevel], 'k--', 'LineWidth', 1.5);
        legendEntries{end+1} = 'Significance level';
        legend(legendEntries, 'Location', 'best');
        xlabel('Lag');
        ylabel(ylabelText);
        title(['(' letters(k) ') Target Variable: ', targetVarName]);
        hold off;
    end
    set(gcf,"Position",[50 50 1200 800]);
    print(gcf, figName, '-dtiff', '-r300');
end

% Plot each set of variable pairs for I
plotVariablePairsForStatistic(allVariablePairs1, R, colors, lineStyles, letters, 'combined_I1.tif', 'I', 'SigThreshI', 'Coupling Statistic (I)');
plotVariablePairsForStatistic(allVariablePairs2, R, colors, lineStyles, letters, 'combined_I2.tif', 'I', 'SigThreshI', 'Coupling Statistic (I)');
plotVariablePairsForStatistic(allVariablePairs3, R, colors, lineStyles, letters, 'combined_I3.tif', 'I', 'SigThreshI', 'Coupling Statistic (I)');
plotVariablePairsForStatistic(allVariablePairs4, R, colors, lineStyles, letters, 'combined_I4.tif', 'I', 'SigThreshI', 'Coupling Statistic (I)');

% Plot each set of variable pairs for IR
plotVariablePairsForStatistic(allVariablePairs1, R, colors, lineStyles, letters, 'combined_IR1.tif', 'IR', 'SigThreshIR', 'Coupling Statistic (IR)');
plotVariablePairsForStatistic(allVariablePairs2, R, colors, lineStyles, letters, 'combined_IR2.tif', 'IR', 'SigThreshIR', 'Coupling Statistic (IR)');
plotVariablePairsForStatistic(allVariablePairs3, R, colors, lineStyles, letters, 'combined_IR3.tif', 'IR', 'SigThreshIR', 'Coupling Statistic (IR)');
plotVariablePairsForStatistic(allVariablePairs4, R, colors, lineStyles, letters, 'combined_IR4.tif', 'IR', 'SigThreshIR', 'Coupling Statistic (IR)');

% Plot each set of variable pairs for TR
plotVariablePairsForStatistic(allVariablePairs1, R, colors, lineStyles, letters, 'combined_TR1.tif', 'TR', 'SigThreshTR', 'Coupling Statistic (TR)');
plotVariablePairsForStatistic(allVariablePairs2, R, colors, lineStyles, letters, 'combined_TR2.tif', 'TR', 'SigThreshTR', 'Coupling Statistic (TR)');
plotVariablePairsForStatistic(allVariablePairs3, R, colors, lineStyles, letters, 'combined_TR3.tif', 'TR', 'SigThreshTR', 'Coupling Statistic (TR)');
plotVariablePairsForStatistic(allVariablePairs4, R, colors, lineStyles, letters, 'combined_TR4.tif', 'TR', 'SigThreshTR', 'Coupling Statistic (TR)');
