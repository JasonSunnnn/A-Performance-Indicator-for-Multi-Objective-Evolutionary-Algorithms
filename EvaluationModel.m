function [output]=EvaluationModel(X,Y,V)         %  X, Y, and V represent the input matrix, 
% desirable output matrix, and undesirable output matrix, respectively. 
% Each row corresponds to a Decision Making Unit (DMU), and each column corresponds to a different metric.   
n=size(X,1);
nn_X=size(X,2);nn_Y=size(Y,2);nn_V=size(V,2);
for k=1:n
     c=[1;zeros(3*n,1);zeros(nn_X,1);-[(1/2*nn_V)*(1./V(k,:)')];-[(1/2*nn_X)*(1./X(k,:)')];zeros(nn_Y,1)];
     A=[X(k,:)',-X',-X',zeros(nn_X,n),diag(ones(nn_X,1)),zeros(nn_X,nn_V+nn_X+nn_Y);
        -V(k,:)',V',V',zeros(nn_V,n+nn_X),diag(ones(nn_V,1)),zeros(nn_V,nn_X+nn_Y);    
        -X(k,:)',X',zeros(nn_X,n),X',zeros(nn_X,nn_X+nn_V),diag(ones(nn_X,1)),zeros(nn_X,nn_Y);
        Y(k,:)',-Y',zeros(nn_Y,n),-Y',zeros(nn_Y,nn_X+nn_V+nn_X),diag(ones(nn_Y,1))];    
     b=[zeros(nn_X,1);      
        zeros(nn_V,1);                                            
        zeros(nn_X,1);
        zeros(nn_Y,1);]                                           
     Aeq=[1,zeros(1,3*n),(1/2*nn_X)*(1./X(k,:)),zeros(1,nn_V+nn_X),(1/2*nn_Y)*(1./Y(k,:));   
         zeros(nn_X,1+n),X',-X',zeros(nn_X,nn_X+nn_V+nn_X+nn_Y);
         -1,zeros(1,n),ones(1,n),zeros(1,n+nn_X+nn_V+nn_X+nn_Y);
         -1,zeros(1,2*n),ones(1,n),zeros(1,nn_X+nn_V+nn_X+nn_Y);
         ];
     beq=[1;zeros(nn_X,1);0;0];
     lb=[zeros(3*n+1+nn_X+nn_V+nn_X+nn_Y,1);];
     ub=[];
     W(:,k)=cplexlp(c,A,b,Aeq,beq,lb,ub);
end
     t=W(1,:);
     Slack_solution=W(3*n+2:3*n+1+nn_X+nn_V+nn_X+nn_Y,:);
     Slack_original=Slack_solution./t;    
     Matrix=[X,V,X,Y]';
     Corresponding_division=Slack_original./Matrix;

     X2slack_positive=Corresponding_division(1:nn_X,:);
     Vslack=Corresponding_division(nn_X+1:nn_X+nn_V,:);
     X2slack_negative=Corresponding_division(nn_X+nn_V+1:nn_X+nn_V+nn_X,:);
     Yslack=Corresponding_division(nn_X+nn_V+nn_X+1:nn_X+nn_V+nn_X+nn_Y,:);

     X2_cofficient_positve=mean(X2slack_positive); X2_cofficient_positve=X2_cofficient_positve./2;
     X2_cofficient_negative=mean(X2slack_negative); X2_cofficient_negative=X2_cofficient_negative./2;
     V_cofficient=mean(Vslack);  V_cofficient=V_cofficient./2;
     Y_cofficient=mean(Yslack);  Y_cofficient= Y_cofficient./2;

     Numerator=1.-(V_cofficient + X2_cofficient_negative);
     Denominator=1.+(X2_cofficient_positve + Y_cofficient);
     L=Numerator./Denominator;     
     [output]=L';
end                              