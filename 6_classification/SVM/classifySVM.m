% classifyKNN - Classify eeg data with SVM Classifier
%   [Acc] = classifySVM(eeg, y, c, parameters, channels, imprime) returns
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
function [Acc] = classifySVM(eeg, y, c, parameters, channels, print_on)
  
  if nargin<5, channels = 1:64;
    if nargin<6, print_on = 1;
    end
  end
  
  % Forma o vetor de caracterísicas a partir dos canais
  [X] = formFeatureVector(eeg, channels);
  
  % Inicializa variável de resposta Acc
  Acc = zeros(c.NumTestSets, length(parameters));

  count = 0;
  for k=parameters % Numero de vizinhos do knn
    if print_on, fprintf('k%i',k); end
    count = count+1;
    
    for fold = 1:c.NumTestSets  % Fold do Cross-Validation
      if print_on, fprintf('.'); end
      
      % SEPARAÇÃO DE DADOS DOS FOLDS
      indTr = c.training(fold); % Indice dos dados de treinamento do fold atual
      indTest = c.test(fold);   % Indice dos dados de teste do fold atual
      
      % TREINAMENTO E TESTE DO MODELO
      knnModel = fitcknn(X(indTr,:),y(indTr),'NumNeighbors',k,'Distance','euclidean'); % Treina modelo com dos dados do treinamento do fold atual
      Ytest = predict(knnModel,X(indTest,:));  % Prediz rotulos dos dados de teste do fold atual
      
      % CALCULA RESULTADOS
      Acc(fold,count) = sum(Ytest==y(indTest))/length(Ytest); % Calcula taxa de reconhecimento
    end
  end
end