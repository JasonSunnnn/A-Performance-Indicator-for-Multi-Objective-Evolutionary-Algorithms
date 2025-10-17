function [output]=EvaluationModel(X,Y,V)         %  X, Y, and V represent the input matrix, 
% desirable output matrix, and undesirable output matrix, respectively. 
% Each row corresponds to a Decision Making Unit (DMU), and each column corresponds to a different metric.   
n=size(X,1);
nn_X=size(X,2);nn_Y=size(Y,2);nn_V=size(V,2);
for k=1:n
     c=[1;zeros(2*n,1);-[(1/2*nn_V)*(1./V(k,:)')];-[(1/2*nn_X)*(1./X(k,:)')];zeros(nn_Y,1)];
     A=[X(k,:)',-X',zeros(nn_X,n),zeros(nn_X,nn_V+nn_X+nn_Y);
        -V(k,:)',V',zeros(nn_V,n),diag(ones(nn_V,1)),zeros(nn_V,nn_X+nn_Y);    
        -X(k,:)',zeros(nn_X,n),X',zeros(nn_X,nn_V),diag(ones(nn_X,1)),zeros(nn_X,nn_Y);
        Y(k,:)',zeros(nn_Y,n),-Y',zeros(nn_Y,nn_V+nn_X),diag(ones(nn_Y,1))];    
     b=[zeros(nn_X,1);      
        zeros(nn_V,1);                                            
        zeros(nn_X,1);
        zeros(nn_Y,1);]                                           
     Aeq=[1,zeros(1,2*n),zeros(1,nn_V+nn_X),(nn_Y)*(1./Y(k,:));   
         -1,ones(1,n),zeros(1,n),zeros(1,nn_V+nn_X+nn_Y);
         -1,zeros(1,n),ones(1,n),zeros(1,nn_V+nn_X+nn_Y);
         ];
     beq=[1;0;0];
     lb=[zeros(2*n+1+nn_V+nn_X+nn_Y,1);];
     ub=[];
     W(:,k)=cplexlp(c,A,b,Aeq,beq,lb,ub);
end
     t=W(1,:);
     Slack_solution=W(2*n+2:2*n+1+nn_V+nn_X+nn_Y,:);
     Slack_original=Slack_solution./t;    
     Matrix=[V,X,Y]';
     Corresponding_division=Slack_original./Matrix;

     Vslack=Corresponding_division(1:nn_V,:);
     Xslack=Corresponding_division(nn_V+1:nn_V+nn_X,:);
     Yslack=Corresponding_division(nn_V+nn_X+1:nn_V+nn_X+nn_Y,:);

     X_cofficient=mean(Xslack,1); X_cofficient=X_cofficient./2;
     V_cofficient=mean(Vslack,1);  V_cofficient=V_cofficient./2;
     Y_cofficient=mean(Yslack,1);

     Numerator=1.-(V_cofficient + X_cofficient);
     Denominator=1.+Y_cofficient;
     L=Numerator./Denominator;     
     [output]=L';
end                              