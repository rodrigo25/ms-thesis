% classifyKNN - Classify eeg data with KNN Classifier
%   [Acc] = classifyKNN(eeg, y, c, parameters, channels, imprime) returns
%   the accuracy for classification of an eeg dataset with cvpartition c
% IMPUT:
%   eeg                - vector with eeg signals ready for classification
%   y                  - vector of class labels
%   c                  - cvpartition structure for cross validation
%   parameters         - vector with the different numbers of neighbors
%   channels (opional) - channels to be used for classification
%   print_on (opional) - print classification status
% OUTPUT:
%   Acc             - accuracy of classification for each fold (rows) and
%                     neurons on the hidden layer (columns)
%
function [Acc] = classifyKNN2(eegTrain, eegTest, Ytr, Ytest, k, channels)
  
  % Forma o vetor de caracterísicas a partir dos canais
  [Xtr] = formFeatureVector(eegTrain, channels);
  [Xtest] = formFeatureVector(eegTest, channels);
      
  [y,y_val] = KNN(Xtr,Ytr,Xtest,k,'e');
      
  % CALCULA RESULTADOS
  Acc = sum(Ytest==y)/length(Ytest); % Calcula taxa de reconhecimento
  
  
  
  
  FRR = [];
  FAR = [];
  fN = 0;
  
  %DEFINE LIMIAR DE DECISAO
  for threshold=0:0.005:1
    fN = fN +1;
    
    %aceito
    FAR = sum(y(y_val>=threshold)~=Ytest(y_val>=threshold));
    
    %rejeito
    FRR = sum(y(y_val<threshold)~=Ytest(y_val<threshold));
    
    
    %CALCULA RESULTADOS
    [ confMatrix, ~, res_struct] = calc_result( Yd, Y );

    % SALVA RESULTADOS
    save([dirName 'Resultados' num2str(fN)],'confMatrix','res_struct','threshold');
    create_log(res_struct, dirName, redeConfig, fN);
    
    %ARMAZENA TPR E FPR PARA MONTAR A CURVA ROC
    FRR = [FRR; res_struct(2).TPR];
    FAR = [FAR; res_struct(2).FPR];
    
  end
  
  
end