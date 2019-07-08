% classifyKNN - Classify eeg data with KNN Classifier
%   [Acc] = classifyKNN_global(eeg, y, c, parameters, channels, imprime) 
%   returns the accuracy for classification of an eeg dataset with
%   cvpartition c
% IMPUT:
%   parameters         - vector with the different numbers of neighbors
%   channels (opional) - channels to be used for classification
%   print_on (opional) - print classification status
%   (global variables expected  - eeg, y, c)
% OUTPUT:
%   Acc             - accuracy of classification for each fold (rows) and
%                     neurons on the hidden layer (columns)
%
function [Acc] = classifyKNN_global(parameters, channels, print_on)
  
  if nargin<3, print_on = 1;
    if nargin<2, channels = 1:64;
    end
  end
  
  % Forma o vetor de caracterísicas a partir dos canais
  [X] = formFeatureVector_global(channels);
  global y c;
  
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