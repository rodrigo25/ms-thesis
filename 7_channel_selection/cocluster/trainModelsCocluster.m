function [Models, ModelosFinal] = trainModelsCocluster(biClustResult, eegReal, cluster_por_pessoa)

  fprintf('\n--- TREINANDO MODELOS ---\n\n')

  Models = cell(biClustResult.ClusterNo,eegReal.c.NumTestSets); % Modelo referente a cada co-cluster
  ModelosFinal = cell(biClustResult.ClusterNo,1); % Modelo referente a cada co-cluster
  
  for i_clust = 1:biClustResult.ClusterNo % Iteração passando por cada co-cluster
    
    pessoas = find(cluster_por_pessoa==i_clust); % Pessoas relacionadas ao co-cluster
    
    % Se o co-cluster não tiver nenhum canal ou pessoa continua para o prox
    if length(biClustResult.Clust(i_clust).cols)<1 || length(biClustResult.Clust(i_clust).rows)<1 || length(pessoas)<1
      continue;
    end;

    channels = biClustResult.Clust(i_clust).cols; % Define os canais selecionados pelo co-cluster
    
    fprintf('\n\nClust %i - %i cols\n',i_clust, length(channels) )
    fprintf('Channels - %s\n', sprintf('%d, ',biClustResult.Clust(i_clust).cols))
    fprintf('Pessoas - %s\n', sprintf('%d, ',pessoas))
    fprintf('Treinando Folds ')
    for fold = 1:eegReal.c.NumTestSets  % Fold do Cross-Validation      
      fprintf('%d ',fold)
      % Define indices do fold
      indTr = eegReal.c.training(fold); % Indice dos dados de treinamento do fold atual
      indTest = eegReal.c.test(fold);   % Indice dos dados de teste do fold atual
      
      Xtrain = eegReal.eeg(indTr,:);
      Ytrain = eegReal.y(indTr,:);
      
      % Define os indices de linhas das pessoas relacionadas ao fold e ao co-cluster
      ind_rows = [];
      for i=1:length(pessoas)
        ind_rows = [ind_rows; find(Ytrain==pessoas(i))];
      end
      
      % Forma o vetor de caracterísicas com os canais e exemplos do co-cluster
      [Xtrain] = formFeatureVector(Xtrain(ind_rows,:), channels);
      Ytrain = Ytrain(ind_rows,:);
      Models{i_clust,fold} = fitcknn(Xtrain,Ytrain,'NumNeighbors',1,'Distance','euclidean'); 
    end
    
    
    % Define os indices de linhas das pessoas relacionadas ao co-cluster
    ind_rows = [];
    for i=1:length(pessoas)
      ind_rows = [ind_rows; find(eegReal.y==pessoas(i))];
    end
    
    [Xtrain] = formFeatureVector(eegReal.eeg(ind_rows,:), channels);
    Ytrain = eegReal.y(ind_rows,:);
    ModelosFinal{i_clust,1} = fitcknn(Xtrain,Ytrain,'NumNeighbors',1,'Distance','euclidean'); 
    
  end
end