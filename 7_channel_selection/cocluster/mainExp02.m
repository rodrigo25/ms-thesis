%EXP_COCLUSTER02 Summary of this function goes here
  % Co-Clusteriza os dados reais.
  % Usa os clusters de linha e de coluna para criar modelos com os diferentes
  % conjuntos de canais usando os apenas os dados do co-cluster para o
  % trenamento. Esses modelos são então usados para testar os dados
  % imaginados e o voto majoritário de todos os modelos define a classe de
  % cada exemplo.
  
  
% ADICIONA DIRETÓRIOS
  addpath('../mtba')
  addpath('coclusters')
  addpath(genpath('../../../6_classification'))
  addpath(genpath('../../../../matlab'))
 
% CARREGA ARQUIVOS REAIS E IMAGINÁRIOS
  eegReal = load('../../eeg_seg05_AR_3_RealTask.mat');
  %eegReal = load('../../eeg_seg03_AR_3_RealTask.mat');
  eegImag = load('../../eeg_seg05_AR_3_ImaginaryTask.mat');

% TIRA MEDIANA OU MEDIA
  biclustDATA = unificaFeatures(eegReal.eeg,'mean'); %'mean'

% NORMALIZAÇÃO
%  biclustDATA = normalization(biclustDATA,'zscore'); %'minmax'
  
% CARREGA ARQUIVO DO BICLUSTER OU EXECUTA O ALGORITMO
nome_arquivo = 'biClustResult_spctral30Seg05_03';
  load(nome_arquivo)
  if ~exist('biClustResult','var')
  % EXECUTA ALGORITMO DE CO-CLUSTER
    biClustResult = spectralCoClustering(biclustDATA,10,1);  %biClustResult = spectralCoClustering(input,numClust,display)
    %biClustResult = qubic(eegTrain,0.06,1,0.95,10,1);   %biClustResult = qubic(datamatrix, quantile, rank, consistancy, output_bicluster, filter_proportion)
    %biClustResult = LAS(eegTrain, 50, 1, 10, 1);   %biClustResult = LAS(matrix, numBC, threads, iterationsPerBC, scoreThreshold)
    
    save biClustResult_spctral10Seg05_mean biClustResult
  end
  
  fprintf(['\n' nome_arquivo '\n'])
  
% RELACIONA INDIVÍDUOS A CADA CLUSTER
  [cluster_por_pessoa] = relacionaPessoaCocluster(biClustResult, eegReal.y);
  
% TREINA MODELOS COM K-FOLD PARA CADA CO-CLUSTER
%KNN ou ELM
  %[models, modeloFinal] = trainModelsCocluster(biClustResult, eegReal, cluster_por_pessoa);
  %[models, modeloFinal] = trainModelsCoclusterELM(biClustResult, eegReal, cluster_por_pessoa);
  [models, modeloFinal] = trainModelsCoclusterSVM(biClustResult, eegReal, cluster_por_pessoa);
  
  
% TESTE 1 DE MODELOS COM K-FOLD PARA CADA CO-CLUSTER
% TESTE INDICANDO OS CLUSTERS
[biClustResult2, models2, modeloFinal2, canaisUsados, cluster_por_pessoa2 ] = removeCoclustersVazios(biClustResult, models, modeloFinal, cluster_por_pessoa);
%[AccTest, AccDadosImag] = test1ModelsCocluster_old(biClustResult, eegReal, eegImag, models, modeloFinal, cluster_por_pessoa);

%KNN ou ELM
%[AccTest, AccDadosImag] = test1ModelsCocluster(biClustResult2, eegReal, eegImag, models2, modeloFinal2, cluster_por_pessoa2);
%[AccTest, AccDadosImag] = test1ModelsCoclusterELM(biClustResult2, eegReal, eegImag, models2, modeloFinal2, cluster_por_pessoa2);
[AccTest, AccDadosImag] = test1ModelsCoclusterSVM(biClustResult2, eegReal, eegImag, models2, modeloFinal2, cluster_por_pessoa2);
  





% TESTE 2 DE MODELOS COM K-FOLD PARA CADA CO-CLUSTER
% TESTE COM REDE DE DECISÃO

% TREINA ELM DE DECISÃO PARA CADA K-FOLD
%[biClustResult2, models2, modeloFinal2, canaisUsados] = removeCoclustersVazios(biClustResult, models, modeloFinal, cluster_por_pessoa);
[ ELMchaveamento, ELMchaveamentoFinal ] = trainELM_clustSelect( eegReal.eeg,eegReal.y, eegReal.c, biClustResult2,canaisUsados, eegImag );
% TESTE

%KNN ou ELM
%[AccTest, AccDadosImag] = test2ModelsCocluster(eegReal, eegImag, biClustResult2, models2, modeloFinal2, ELMchaveamento, ELMchaveamentoFinal, canaisUsados);
%[AccTest, AccDadosImag] = test2ModelsCoclusterELM(eegReal, eegImag, biClustResult2, models2, modeloFinal2, ELMchaveamento, ELMchaveamentoFinal, canaisUsados);
[AccTest, AccDadosImag] = test2ModelsCoclusterSVM(eegReal, eegImag, biClustResult2, models2, modeloFinal2, ELMchaveamento, ELMchaveamentoFinal, canaisUsados);

  
  
  
  
  
  
  
  
  
  
  
 
% CLUSTERIZA
% PARA CADA FOLD
  % PARA CADA COCLUSTER
    % SEPARA INDIVIDUOS
    % SEPARA CANAIS
  % CRIA CLASSIFICADOR
  
