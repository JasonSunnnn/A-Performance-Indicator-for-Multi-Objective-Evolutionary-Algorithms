clear;
clc;
close all;
%%                                    Load Data
load('indicators.mat')

Prob_set={'WFG1','WFG2','WFG3','WFG4','WFG5','WFG6','WFG7','WFG8','WFG9'}'; %Test problem set, corresponding to the column of the indicator cell
M_set=[2,3,5,8,10];  %Set of objective numbers, corresponding to rows of indicator cells
Algo_set={'SPEA2','NSGAII','GrEA','NSGAIII','SPEA2SDE','KnEA','tDEA','VaEA','SPEAR',...
    'MOEAD','MOEADDE','IDBEA','MOEADD','MaOEARD','EFRRR','RVEA',... 
    'IBEA','HypE','BiGE','MOMBIII','BCEIBEA'};

%%                                  Flat Data
cellArray = coverage;

flatData = cellfun(@(x) x(:), cellArray, 'UniformOutput', false);

resultMatrix = vertcat(flatData{:});

disp(resultMatrix);

disp(size(resultMatrix));  

coverage_flat=resultMatrix;          

%%                                   Calculate Correlation

array1=coverage_flat;
array2=array1;

[tau, p_value] = corr(array1, array2,'Type', 'Kendall');


%%                                          Model Evaluation
score=cell(5,9);
for i=1:9                                   
    for ii=1:5                              
        for iii=1:10                        
            Homogenous_set=[data_PD_31{ii,i}(:,iii),data_NFS{ii,i}(:,iii),data_HV_96{ii,i}(:,iii),data_GDPlus{ii,i}(:,iii),data_Spacing_39{ii,i}(:,iii)];                    %   鍒涘缓涓?涓寘鍚悓璐ㄥ崟鍏冪殑鏁版嵁缁?
            a=EvaluationModel(Homogenous_set(:,1:3),Homogenous_set(:,4:5));    
            score{ii,i}(:,iii)=a;
        end
    end
end

