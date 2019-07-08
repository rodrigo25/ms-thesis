% classifyELM - Classify eeg data with ELM Classifier
%   [Acc] = classifyELM(eeg, y, c, parameters, channels, imprime) returns
%   the accuracy for classification of an eeg dataset with cvpartition c
% IMPUT:
%   eeg                - vector with eeg signals ready for classification
%   y                  - vector of class labels
%   c                  - cvpartition structure for cross validation
%   parameters         - vector with the number of neurons on the hidden 
%                        layer. Each entry will create a different model.
%   channels (opional) - channels to be used for classification
%   print_on (opional) - print classification status
% OUTPUT:
%   Acc             - accuracy of classification for each fold (rows) and
%                     neurons on the hidden layer (columns)
%
function [Acc, knnModels] = classifyELM(eeg, y, c, parameters, channels, print_on)

  if nargin<6, print_on = 1;
    if nargin<5, channels = 1:64;
    end
  end
  
  % Forma o vetor de caracterísicas a partir dos canais
  [X] = formFeatureVector(eeg, channels);
  y_binary = transformClassLabels2Binary(y);
  
  % Inicializa variável de resposta Acc
  Acc = zeros(c.NumTestSets, length(parameters));

	% Inicializa variável de resposta knnModels
  knnModels = cell(length(parameters),1);
	
  count = 0;
  for nh=parameters % Numero de neuronios da ELM
    if print_on, fprintf('nh%i',nh); end
    count = count+1;
    
    for fold = 1:c.NumTestSets  % Fold do Cross-Validation
      if print_on, fprintf('.'); end
      
      % SEPARAÇÃO DE DADOS DOS FOLDS
      indTr = c.training(fold); % Indice dos dados de treinamento do fold atual
      indTest = c.test(fold);   % Indice dos dados de teste do fold atual
      
      % TREINAMENTO E TESTE DO MODELO
      ELMmodel = trainELM(X(indTr,:),y_binary(indTr,:),nh); % Treina modelo com dos dados do treinamento do fold atual
      [Ytest, Acc(fold, count)] = predictELM(ELMmodel,X(indTest,:),y_binary(indTest,:));  % Prediz rotulos dos dados de teste do fold atual
    end
		
		knnModels{count} = trainELM(X,y_binary,nh);
		
  end
  
end