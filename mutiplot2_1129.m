% 初始化设置
clear
close all
clc
clear global processLog
global processLog

% 文件和变量设置
opts.files = {'Hourly_data_1970-2017.mat'};
opts.varNames = {'MK', 'SS', 'SZ', 'CW', 'DS', 'SSW', 'FBC', 'HP', 'ZY', 'GZ', 'DLS', 'HS', 'BJ', 'HJ', 'NH', 'HM', 'RQ', 'SD', 'SSJ', 'BSW', 'LS', 'NS', 'SSK', 'ZD'};
opts.varSymbols = {};
opts.varUnits = {};

% 加载数据
load('dataInputData/Results_dataInputDataWithResolutions.mat', 'R', 'opts');

% 目标变量范围设置
toVars = [10, 9, 11, 12, 13, 14, 18, 19, 20, 16, 8, 5, 6, 23, 22, 24, 21, 7, 15, 17];
fromVars = [1, 2, 3, 4];

% 定义统计量
statistics = {'I', 'IR', 'T', 'TR'};
sigThresholds = {'SigThreshI', 'SigThreshIR', 'SigThreshT', 'SigThreshTR'};

% 设置文件夹路径
outputFolders = {'I', 'IR', 'T', 'TR'}; % 输出文件夹

% 创建目标文件夹（如果不存在的话）
for i = 1:length(outputFolders)
    if ~exist(outputFolders{i}, 'dir')
        mkdir(outputFolders{i});
    end
end

% 循环每个统计量
for s = 1:length(statistics)
    % 循环每个目标变量
    for i = 1:length(toVars)
        % 设置绘图参数
        popts.testStatistic = statistics{s}; % 当前统计量
        popts.SigThresh = sigThresholds{s}; % 相应的显著性阈值
        popts.ToVar = toVars(i);
        popts.FromVars = fromVars;
        popts.fi = 1;
        popts.laglim = [0 50];
        popts.fignum = 1;
        popts.clearplot = 1;
   
        % 生成多耦合同步图
        [H] = multiCouplingSynchronyPlot3(R, popts);
       
        % 隐藏Y轴标签
        % set(gca, 'YTickLabel', []);  % 隐藏y轴标签
        set(gca,'Position',[0.1603 0.1625 0.548 0.69])
        % 关闭图例
        legend off;  % 禁用图例
        
        % 获取colorbar句柄并移除colorbar的标题（名称）
        colorbarHandle = colorbar;  % 获取colorbar句柄
        colorbarHandle.Title.String = '';  % 移除colorbar的标题

        % 设置图形窗口大小
        set(gcf, 'Position', [10, 10, 80, 80]);

        % 设置标题，标明当前变量
        title(sprintf('Target: %s', opts.varNames{toVars(i)}));

        % 保存为 tif 文件
        outputFileName = sprintf('%s/%s_Target_%s.tif', outputFolders{s}, statistics{s}, opts.varNames{toVars(i)});
        print(gcf, outputFileName, '-dtiff', '-r300');
        
        % 保存当前图像为 .fig 格式
        outputFigName = sprintf('%s/%s_Target_%s.fig', outputFolders{s}, statistics{s}, opts.varNames{toVars(i)});
        saveas(gcf, outputFigName, 'fig');
        
        % 关闭当前图形窗口，释放内存
        close(gcf);
    end
end
