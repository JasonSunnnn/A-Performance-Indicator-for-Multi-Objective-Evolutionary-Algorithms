function [output]=EvaluationModel(Y,V)         %  Y and V represent the desirable output matrix and undesirable output matrix, respectively. 
% Each row corresponds to a Decision Making Unit (DMU), and each column corresponds to a different metric.   
n=size(Y,1);
nn_Y=size(Y,2);nn_V=size(V,2);
for k=1:n
     c=[1;zeros(2*n,1);-[(1/nn_V)*(1./V(k,:)')];zeros(nn_Y,1)];
     A=[-V(k,:)',V',zeros(nn_V,n),diag(ones(nn_V,1)),zeros(nn_V,nn_Y);    
        Y(k,:)',zeros(nn_Y,n),-Y',zeros(nn_Y,nn_V),diag(ones(nn_Y,1))];    
     b=[zeros(nn_V,1);                                            
        zeros(nn_Y,1);]                                           
     Aeq=[1,zeros(1,2*n),zeros(1,nn_V),(nn_Y)*(1./Y(k,:));   
         -1,ones(1,n),zeros(1,n),zeros(1,nn_V+nn_Y);
         -1,zeros(1,n),ones(1,n),zeros(1,nn_V+nn_Y);
         ];
     beq=[1;0;0];
     lb=[zeros(2*n+1+nn_V+nn_Y,1);];
     ub=[];
     % options = optimoptions('linprog', 'TolFun', 1e-10);
     W(:,k)=cplexlp(c,A,b,Aeq,beq,lb,ub);
end
     t=W(1,:);
     Slack_solution=W(2*n+2:2*n+1+nn_V+nn_Y,:);
     Slack_original=Slack_solution./t;    
     Matrix=[V,Y]';
     Corresponding_division=Slack_original./Matrix;

     Vslack=Corresponding_division(1:nn_V,:);
     Yslack=Corresponding_division(nn_V+1:nn_V+nn_Y,:);

     V_cofficient=mean(Vslack,1);
     Y_cofficient=mean(Yslack,1);

     Numerator=1.-V_cofficient ;
     Denominator=1.+Y_cofficient;
     L=Numerator./Denominator;     
     [output]=L';
end                                         