clear;
clc;
close all;
%%                                    Load Data
load('indicators.mat')

Prob_set={'WFG1','WFG2','WFG3','WFG4','WFG5','WFG6','WFG7','WFG8','WFG9'}'; %Test problem set, corresponding to the column of the indicator cell
M_set=[2,3,5,8,10];  %Set of objective numbers, corresponding to rows of indicator cells
Algo_set={'SPEA2','NSGAII','GrEA','NSGAIII','SPEA2SDE','KnEA','tDEA','VaEA','SPEAR',...%基于支配
    'MOEAD','MOEADDE','IDBEA','MOEADD','MaOEARD','EFRRR','RVEA',... %基于分解
    'IBEA','HypE','BiGE','MOMBIII','BCEIBEA'};%,...%基于指标

%%                                  Flat Data
cellArray = coverage;

% 将cell数组内部的数据排成一�?
flatData = cellfun(@(x) x(:), cellArray, 'UniformOutput', false);

% 连接�?有单列元胞的数据
resultMatrix = vertcat(flatData{:});

% 输出结果
disp(resultMatrix);

% 查看结果矩阵的大�?
disp(size(resultMatrix));  

coverage_flat=resultMatrix;          %    cell平铺为矩�?

%%                                   Calculate Correlation

array1=coverage_flat;
array2=array1;


% 计算相关系数矩阵
correlationMatrix = corrcoef(array1, array2);

% 提取线�?�相关系�?
linearCorrelation = correlationMatrix(1, 2);

% 显示结果
disp('Correlation coefficient matrix�?');
disp(correlationMatrix);

disp(['Linear correlation coefficient', num2str(linearCorrelation)]);

% 绘制散点图以可视化线性关�?
scatter(array1, array2);
xlabel('Array 1');
ylabel('Array 2');
title('Linear correlation coefficient');
grid on;                                   %     计算array1和array2的皮尔�?�相关系�?
 

%r is close to 1, and we believe there is a strong positive linear correlation.
%r is close to -1, and we believe there is a strong negative linear correlation.
%r is close to 0, and we believe that the linear correlation between the two variables is weak.
%The specific criteria for judgment may vary, but the following general guidance can usually be used:
%| r |<  0.3: Linear correlation is weak.
%0.3 <? | r | <0.7: Linear correlation is moderate.
%| r | >? 0.7: Strong linear correlation.

%%                                          Model Evaluation
Score=cell(5,9);
 
for i=1:9                                   %   问题�?�?
    for ii=1:5                              %   目标
        for iii=1:10                        %   重复实验次数
            Homogenous_set=[powerconsum{ii,i}(:,iii),data_DM_66{ii,i}(:,iii),data_HV_96{ii,i}(:,iii),data_DeltaP_75{ii,i}(:,iii),...
			data_GD_17{ii,i}(:,iii),data_IGD_85{ii,i}(:,iii),data_PD_31{ii,i}(:,iii),data_IGDp_86{ii,i}(:,iii),data_epsilon_81{ii,i}(:,iii),...
			data_Spacing_39{ii,i}(:,iii),data_Spread_101{ii,i}(:,iii)];          %   创建�?个包含同质单元的数据�?          
            a=EvaluationModel(Homogenous_set(:,1),Homogenous_set(:,2:3),Homogenous_set(:,4:11));    %  算效�?
            Score{ii,i}(:,iii)=a;
        end
    end
end