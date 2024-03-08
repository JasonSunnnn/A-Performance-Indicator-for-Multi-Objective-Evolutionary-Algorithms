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


correlationMatrix = corrcoef(array1, array2);

linearCorrelation = correlationMatrix(1, 2);

disp('Correlation coefficient matrix');
disp(correlationMatrix);

disp(['Linear correlation coefficient', num2str(linearCorrelation)]);

scatter(array1, array2);
xlabel('Array 1');
ylabel('Array 2');
title('Linear correlation coefficient');
grid on;                                  
 

%r is close to 1, and we believe there is a strong positive linear correlation.
%r is close to -1, and we believe there is a strong negative linear correlation.
%r is close to 0, and we believe that the linear correlation between the two variables is weak.
%The specific criteria for judgment may vary, but the following general guidance can usually be used:
%| r |<  0.3: Linear correlation is weak.
%0.3 < | r | <0.7: Linear correlation is moderate.
%| r | > 0.7: Strong linear correlation.

%%                                          Model Evaluation
Score=cell(5,9);
 
for i=1:9                                 
    for ii=1:5                            
        for iii=1:10                       
            Homogenous_set=[powerconsum{ii,i}(:,iii),data_DM_66{ii,i}(:,iii),data_HV_96{ii,i}(:,iii),data_DeltaP_75{ii,i}(:,iii),...
			data_GD_17{ii,i}(:,iii),data_IGD_85{ii,i}(:,iii),data_PD_31{ii,i}(:,iii),data_IGDp_86{ii,i}(:,iii),data_epsilon_81{ii,i}(:,iii),...
			data_Spacing_39{ii,i}(:,iii),data_Spread_101{ii,i}(:,iii)];            
            a=EvaluationModel(Homogenous_set(:,1),Homogenous_set(:,2:3),Homogenous_set(:,4:11));  
            Score{ii,i}(:,iii)=a;
        end
    end
end
