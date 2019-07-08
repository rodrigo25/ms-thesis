% Separa tarefas reais e imaginarias

clear, clc
SEGs={'seg01','seg02','seg03','seg04','seg05'};
feature = 'AR';% or SAX
paramFeatures = {'1', '2', '3', '4', '5', '6', '7', '8', '9','10','15','20'};

%for paramFeat = {'15_10', '20_10'}
for indParamFeat = 1:length(paramFeatures)
  paramFeat = paramFeatures{indParamFeat};
  for indSeg= 1:length(SEGs)
    seg = SEGs{indSeg};
    
    filein = ['../3_featureExtractData/' feature '/eeg_' seg '_' feature '_' paramFeat];
    fprintf ('\n- Carregando arquivo ''%s''\n', filein)
    load(filein);

    qtdTotalSamples = length(eeg{1,1})*2; % Quantidade de total de exemplos por tipo de tarefa (para cada individuo)
    featPerChannel = size(eeg{1,1}{1},2);  % Quantidade de features em cada sinal

    eegRealTask =      zeros( 102*qtdTotalSamples, 64*featPerChannel);
    yRealTask   =      zeros( 102*qtdTotalSamples, 1);
    eegImaginaryTask = zeros( 102*qtdTotalSamples, 64*featPerChannel);
    yImaginaryTask   = zeros( 102*qtdTotalSamples, 1);

    for S=1:102  % Percorre cada indivíduo
      fprintf ('- Subject %d\n', S)

      auxRealTask = [eeg{S,1} eeg{S,3}];      % coloca os exemplos de tarefa real em auxRealTask
      auxImaginaryTask = [eeg{S,2} eeg{S,4}]; % coloca todos os exemplos de tarefa imaginaria em auxImaginaryTask
      
      iniIndexS = (S-1)*qtdTotalSamples;

      for sample=1:qtdTotalSamples

        new = auxRealTask{sample}';
        eegRealTask(iniIndexS+sample,:) = new(:)';
        yRealTask(iniIndexS+sample,:) = S;
        
        new = auxImaginaryTask{sample}';
        eegImaginaryTask(iniIndexS+sample,:) = new(:)';
        yImaginaryTask(iniIndexS+sample,:) = S;
        
      end
    end
    
    
    shuffleOrder = randperm(size(eegRealTask,1));
    eeg = eegRealTask(shuffleOrder,:);
    y = yRealTask(shuffleOrder,:);
    c = cvpartition(y,'KFold',10); 
    
    fileout = [feature '/eeg_' seg '_' feature '_' paramFeat '_RealTask'];
    fileout = ['G:\Meu Drive\mestrado\Physionet - EEG Motor Movement & Imagery Dataset\5_datasets\Testes Defesa\AR\' filein];
    fprintf('\n- Salvando arquivo %s \n\n', fileout)
    save(fileout,'eeg','y','c')
    
    
    shuffleOrder = randperm(size(eegImaginaryTask,1));
    eeg = eegImaginaryTask(shuffleOrder,:);
    y = yImaginaryTask(shuffleOrder,:);
    c = cvpartition(y,'KFold',10);
   
    fileout = [feature '/eeg_' seg '_' feature '_' paramFeat '_ImaginaryTask'];
    fileout = ['G:\Meu Drive\mestrado\Physionet - EEG Motor Movement & Imagery Dataset\5_datasets\Testes Defesa\AR\' filein];
    fprintf('\n- Salvando arquivo %s \n\n', fileout)
    save(fileout,'eeg','y','c')
    
    fprintf('\n- Arquivos salvos!\n')

  end
end
