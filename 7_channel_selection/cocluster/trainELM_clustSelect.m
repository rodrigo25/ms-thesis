function [ ELMchaveamento, ELMchaveamentoFinal ] = trainELM_clustSelect( Xtr,Ytr, c, biClustResult,canaisUsados, eegImag )


  fprintf('\n\n\n--- TESTE 2 DOS MODELOS ---\n\n')
  
  fprintf('\n-> Treinando ELM de Chaveamento \n\n')

  ELMchaveamento = cell(c.NumTestSets,1);

  [cluster_por_pessoa] = relacionaPessoaCocluster(biClustResult, Ytr);
  Ytr2 = cluster_por_pessoa(Ytr);
  Xtr2 = formFeatureVector(Xtr, canaisUsados);
  y_binary = transformClassLabels2Binary(Ytr2');
  
  nh=2000;

  for fold = 1:c.NumTestSets
    % SEPARAÇÃO DE DADOS DOS FOLDS
    indTr = c.training(fold); % Indice dos dados de treinamento do fold atual
    indTest = c.test(fold);   % Indice dos dados de teste do fold atual
      
    % TREINAMENTO E TESTE DO MODELO
    ELMchaveamento{fold} = trainELM(Xtr2(indTr,:),y_binary(indTr,:),nh); % Treina modelo com dos dados do treinamento do fold atual
    [~, Acc] = predictELM(ELMchaveamento{fold},Xtr2(indTest,:),y_binary(indTest,:));  % Prediz rotulos dos dados de teste do fold atual
    fprintf('ELM do Fold %d - Acc de chaveamento %f\n', fold, Acc)
  end
  
  
  Yimag = cluster_por_pessoa(eegImag.y);
  Ximag = formFeatureVector(eegImag.eeg, canaisUsados);
  y_binary_imag = transformClassLabels2Binary(Yimag');
  
  ELMchaveamentoFinal = trainELM(Xtr2,y_binary,nh);
  [~, Acc] = predictELM(ELMchaveamentoFinal,Ximag,y_binary_imag);
  fprintf('ELM com dados Imaginados %d - Acc de chaveamento %f\n', fold, Acc)


end

