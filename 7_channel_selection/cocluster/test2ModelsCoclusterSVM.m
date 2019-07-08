function [AccTest, AccDadosImag] = test2ModelsCocluster(eegReal, eegImag, biClustResult, models, modeloFinal, ELMchaveamento, ELMchaveamentoFinal, canaisUsados)
  %TEST_CLUSTER_MODELS - Testa modelos com os dados imaginados
  
  fprintf('\n-> Teste dos modelos com chaveamento da ELM \n\n')
  
  % Acurácia dos dados Imaginados de teste para cada co-cluster
  %AccTest = zeros(biClustResult.ClusterNo,1);
  AccTest = zeros(eegReal.c.NumTestSets,1);

  XChaveamento = formFeatureVector(eegReal.eeg, canaisUsados);
  
  for i_fold = 1:eegReal.c.NumTestSets  % Fold do Cross-Validation      
      
    % Define indices do fold
    indTr = eegReal.c.training(i_fold); % Indice dos dados de treinamento do fold atual
    indTest = eegReal.c.test(i_fold);   % Indice dos dados de teste do fold atual
  
    Xfold = eegReal.eeg(indTest,:);
    Yfold = eegReal.y(indTest,:);
    
    [yResELM, ~] = predictELM(ELMchaveamento{i_fold},XChaveamento(indTest,:));  % Prediz rotulos dos dados de teste do fold atual
    indModel = transformClassLabels2Decimal(yResELM);
    
    Yresult2 = [];
    Ygeral = [];
    for i_clust=1:biClustResult.ClusterNo
      if sum(indModel==i_clust)==0
        continue
      end
      
      channels = biClustResult.Clust(i_clust).cols; 
      
      X = formFeatureVector(Xfold(indModel==i_clust,:), channels);
      Y = Yfold(indModel==i_clust,:);
      Ygeral = [Ygeral; Y];
      
      [Yresult, ~, ~] = svmpredict(Y,X,models{i_clust,i_fold},'-q');  % Prediz rotulos dos dados de teste do fold atual
      Yresult2 = [Yresult2; Yresult];
    end
    AccTest(i_fold) = sum(Ygeral==Yresult2)/length(Ygeral); 

    fprintf('Fold %d: %f  -  ', i_fold, AccTest(i_fold) ) 
  end
  
  fprintf('\nMédia: %f±%f ', mean(AccTest), std(AccTest) )
  
  
  XChaveamentoFinal = formFeatureVector(eegImag.eeg, canaisUsados);
  [yResELM, ~] = predictELM(ELMchaveamentoFinal,XChaveamentoFinal);  % Prediz rotulos dos dados de teste do fold atual
  indModel = transformClassLabels2Decimal(yResELM);
  Yresult2 = [];
  Ygeral = [];
  for i_clust=1:biClustResult.ClusterNo
    if sum(indModel==i_clust)==0
      continue
    end
      
    channels = biClustResult.Clust(i_clust).cols; 
      
    X = formFeatureVector(eegImag.eeg(indModel==i_clust,:), channels);
    Y = eegImag.y(indModel==i_clust,:);
    Ygeral = [Ygeral; Y];
    
    [Yresult, ~, ~] = svmpredict(Y,X,modeloFinal{i_clust},'-q');  % Prediz rotulos dos dados de teste do fold atual
    Yresult2 = [Yresult2; Yresult];
  end
  AccDadosImag = sum(Ygeral==Yresult2)/length(Ygeral); 
  
  fprintf('\nAcurácia dados Imaginados: %f  ', AccDadosImag )
  
%   for i_clust = 1:biClustResult.ClusterNo % FOR passando por cada co-cluster
%     pessoas = find(cluster_por_pessoa==i_clust); % Pessoas relacionadas ao co-cluster
%     % Se o co-cluster não tiver nenhum canal ou pessoa continua para o prox
%     if length(biClustResult.Clust(i_clust).cols)<1 || length(biClustResult.Clust(i_clust).rows)<1 || length(pessoas)<1
%       continue;
%     end;
%     
%     channels = biClustResult.Clust(i_clust).cols; % Define os canais selecionados pelo co-cluster
%     
%     fprintf('\n\nClust %i \n',i_clust)
%     fprintf('Channels - %s\n', sprintf('%d, ',biClustResult.Clust(i_clust).cols))
%     for fold = 1:eegReal.c.NumTestSets  % Fold do Cross-Validation      
%       
%       % Define indices do fold
%       indTr = eegReal.c.training(fold); % Indice dos dados de treinamento do fold atual
%       indTest = eegReal.c.test(fold);   % Indice dos dados de teste do fold atual
%       
%       Xtest = eegReal.eeg(indTest,:);
%       Ytest = eegReal.y(indTest,:);
%       
%     end
    
%     Xtest = formFeatureVector(eegImag.eeg(ind_rows,:), channels);
%     Ytest = eegImag.y(ind_rows,:);
%     Yresult = predict(modelosFinal{i_clust,1},Xtest);  % Prediz rotulos dos dados imaginados
%     AccDadosImag(i_clust,1) = sum(Ytest==Yresult)/length(Ytest);
%     
%     fprintf('\nAcurácia dados Reais: %f  ', AccDadosImag(i_clust,1) )
%     
%   end
%   
%   %fprintf('\n\n\nMédia dos Clusters dos dados Reais:  ', AccDadosReais(i_clust,1) )
%   fprintf('\n\n\nMédia da média dos folds dos dados Reais: %f ', sum(sum(AccTest'))/(sum(sum(AccTest')>0)*10) )
%   fprintf('\nMédia dados Imaginados: %f \n', sum(AccDadosImag)/sum(AccDadosImag>0) )

end
