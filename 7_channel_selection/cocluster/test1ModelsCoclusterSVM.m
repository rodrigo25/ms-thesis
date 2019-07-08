function [AccTest, AccDadosImag] = test1ModelsCocluster(biClustResult, eegReal, eegImag, models, modeloFinal, cluster_por_pessoa)
  %TEST_CLUSTER_MODELS - Testa modelos com os dados imaginados
  
  fprintf('\n\n\n--- TESTE 1 DOS MODELOS ---\n\n')
  
  % Acurácia dos dados Imaginados de teste para cada co-cluster
  %AccTest = zeros(biClustResult.ClusterNo,eegReal.c.NumTestSets);
  %AccDadosImag = zeros(biClustResult.ClusterNo,1);
  %resGeralFolds = cell(eegReal.c.NumTestSets,1);
  
  
  % Acurácia dos dados Imaginados de teste para cada co-cluster
  AccTest = zeros(eegReal.c.NumTestSets,1);
  
  for i_fold = 1:eegReal.c.NumTestSets  % Fold do Cross-Validation    
    % Define indices do fold
    indTr = eegReal.c.training(i_fold); % Indice dos dados de treinamento do fold atual
    indTest = eegReal.c.test(i_fold);   % Indice dos dados de teste do fold atual
  
    Xfold = eegReal.eeg(indTest,:);
    Yfold = eegReal.y(indTest,:);
    
    %[yResELM, ~] = predictELM(ELMchaveamento{i_fold},XChaveamento(indTest,:));  % Prediz rotulos dos dados de teste do fold atual
    indModel = cluster_por_pessoa; 
  
    Yresult2 = [];
    Ygeral = [];
    for i_clust=1:biClustResult.ClusterNo
      if sum(cluster_por_pessoa==i_clust)==0
        continue
      end
      
      channels = biClustResult.Clust(i_clust).cols; 
      [~,pessoas] = find(cluster_por_pessoa==i_clust);
      
      ind_rows = [];
      for i=1:length(pessoas)
        ind_rows = [ind_rows; find(Yfold==pessoas(i))];
      end
      
      X = formFeatureVector(Xfold(ind_rows,:), channels);
      Y = Yfold(ind_rows,:);
      Ygeral = [Ygeral; Y];
      
      [Yresult, ~, ~] = svmpredict(Y,X,models{i_clust,i_fold},'-q');  % Prediz rotulos dos dados de teste do fold atual
      Yresult2 = [Yresult2; Yresult];
      
      
    end
    AccTest(i_fold) = sum(Ygeral==Yresult2)/length(Ygeral); 

    fprintf('Fold %d: %f  -  ', i_fold, AccTest(i_fold) ) 
  end
  
  
  fprintf('\nMédia: %f±%f ', mean(AccTest), std(AccTest) )
  
  %XChaveamentoFinal = formFeatureVector(eegImag.eeg, canaisUsados);
  %[yResELM, ~] = predictELM(ELMchaveamentoFinal,XChaveamentoFinal);  % Prediz rotulos dos dados de teste do fold atual
  %indModel = transformClassLabels2Decimal(yResELM);
  
  Yresult2 = [];
  Ygeral = [];
  
  for i_clust=1:biClustResult.ClusterNo
    if sum(cluster_por_pessoa==i_clust)==0
      continue
    end
      
    channels = biClustResult.Clust(i_clust).cols; 
    [~,pessoas] = find(cluster_por_pessoa==i_clust);  
    
    ind_rows = [];
    for i=1:length(pessoas)
      ind_rows = [ind_rows; find(eegImag.y==pessoas(i))];
    end
    
    X = formFeatureVector(eegImag.eeg(ind_rows,:), channels);
    Y = eegImag.y(ind_rows,:);
    Ygeral = [Ygeral; Y];
    
    [Yresult, ~, ~] = svmpredict(Y,X,modeloFinal{i_clust},'-q');  % Prediz rotulos dos dados de teste do fold atual
    Yresult2 = [Yresult2; Yresult];
  end
  AccDadosImag = sum(Ygeral==Yresult2)/length(Ygeral); 
  
  fprintf('\nAcurácia dados Imaginados: %f  ', AccDadosImag )
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  return
  
  
  
  
  
  
  
  
  
  
  fprintf('\n\n\n--- TESTE 1 DOS MODELOS ---\n\n')
  
  % Acurácia dos dados Imaginados de teste para cada co-cluster
  AccTest = zeros(biClustResult.ClusterNo,eegReal.c.NumTestSets);
  AccDadosImag = zeros(biClustResult.ClusterNo,1);
  resGeralFolds = cell(eegReal.c.NumTestSets,1);
  
  
  for i_clust = 1:biClustResult.ClusterNo % FOR passando por cada co-cluster
    % Pessoas relacionadas ao co-cluster
    pessoas = find(cluster_por_pessoa==i_clust);
    % Se o co-cluster não tiver nenhum canal ou pessoa continua para o prox
    if length(biClustResult.Clust(i_clust).cols)<1 || length(biClustResult.Clust(i_clust).rows)<1 || length(pessoas)<1
      continue;
    end;
    
    channels = biClustResult.Clust(i_clust).cols; % Define os canais selecionados pelo co-cluster
    
    fprintf('\n\nClust %i \n',i_clust)
    fprintf('Channels - %s\n', sprintf('%d, ',biClustResult.Clust(i_clust).cols))
    for fold = 1:eegReal.c.NumTestSets  % Fold do Cross-Validation      
      
      % Define indices do fold
      indTr = eegReal.c.training(fold); % Indice dos dados de treinamento do fold atual
      indTest = eegReal.c.test(fold);   % Indice dos dados de teste do fold atual
      
      Xtest = eegReal.eeg(indTest,:);
      Ytest = eegReal.y(indTest,:);
      
      
      % Define os indices de linhas das pessoas relacionadas ao fold e ao co-cluster
      ind_rows = [];
      for i=1:length(pessoas)
        ind_rows = [ind_rows; find(Ytest==pessoas(i))];
      end
    
    
      % Forma o vetor de caracterísicas dos dados Imaginados com os canais do co-cluster
      [Xtest] = formFeatureVector(Xtest(ind_rows,:), channels);
      Ytest = Ytest(ind_rows,:);
      
      Yresult = predict(models{i_clust,fold},Xtest);  % Prediz rotulos dos dados imaginados
      AccTest(i_clust,fold) = sum(Ytest==Yresult)/length(Ytest);
      resGeralFolds{fold} = [resGeralFolds{fold}; Ytest==Yresult];
      fprintf('Fold %d: %f  -  ', fold, AccTest(i_clust,fold) ) 
    end
    
    fprintf('\nMédia: %f±%f ', mean(AccTest(i_clust,:)), std(AccTest(i_clust,:)) )
    
    % Define os indices de linhas das pessoas relacionadas ao co-cluster
    ind_rows = [];
    for i=1:length(pessoas)
      ind_rows = [ind_rows; find(eegImag.y==pessoas(i))];
    end
    
    Xtest = formFeatureVector(eegImag.eeg(ind_rows,:), channels);
    Ytest = eegImag.y(ind_rows,:);
    Yresult = predict(modelosFinal{i_clust,1},Xtest);  % Prediz rotulos dos dados imaginados
    AccDadosImag(i_clust,1) = sum(Ytest==Yresult)/length(Ytest);
    
    fprintf('\nAcurácia dados Reais: %f  ', AccDadosImag(i_clust,1) )
    
  end
  
  %fprintf('\n\n\nMédia dos Clusters dos dados Reais:  ', AccDadosReais(i_clust,1) )
  fprintf('\n\n\n');
  accPorFold = zeros(eegReal.c.NumTestSets,1);
  for fold = 1:eegReal.c.NumTestSets
    accPorFold(fold) = sum(resGeralFolds{fold})/length(resGeralFolds{fold});
    fprintf('Acc fold %d: %f - ', fold, accPorFold(fold));
  end
  fprintf('\nMédia dados Reais 10-folds: %f ', sum(sum(AccTest'))/(sum(sum(AccTest')>0)*10) )
  fprintf('\nMédia dados Reais 10-folds: %f±%f ', mean(accPorFold), std(accPorFold) )
  fprintf('\nMédia dados Imaginados: %f \n', sum(AccDadosImag)/sum(AccDadosImag>0) )

end
