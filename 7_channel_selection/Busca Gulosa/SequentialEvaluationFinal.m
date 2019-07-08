addpath(genpath('../../6_classification'))
eegReal = load('../eeg_seg05_AR_3_RealTask.mat');

% DEFINIÇÃO DE VARIÁVEIS
%algoritmo = 'ELM'; %KNN, ELM ou SVM
k  = 1;     % k  - Vizinhos do KNN
nh = 2000;  % nh - Neurônios do ELM
C  = 180;  % C  - C do SVM

%bestAcc = 0;  % Armazena a melhor acc

%ranking = []; % Canais rankeados
auxRanking = zeros(1,64);

fprintf('## Rankeamento ##\n');

% CALCULA ACURÁCIA USANDO APENAS UM CANAL POR VEZ
for channel=7:64
  if strcmp(algoritmo,'KNN')
    acc = classifyKNN(eegReal.eeg, eegReal.y, eegReal.c, k, channel, 0);
  elseif strcmp(algoritmo,'ELM')
    acc = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, nh, channel, 0);
  elseif strcmp(algoritmo,'SVM')
    acc = 0;
  end
  auxRanking(channel) = mean(acc);
  
  fprintf('(%i)=%f\n', channel, auxRanking(channel));
  save dataSE-ELM
end

% RANKEIA OS CANAIS BASEADO NA ACC DA CLASSIFICAÇÃO
[~,ranking] = sort(auxRanking);

selectedChannels = [];

fprintf('\n## Sequential Evaluation ##\n')
for ind=1:64
  selectedChannels = [selectedChannels ranking(ind)];
  
  fprintf( ['\n %dºcanal - %d \n Canais: ' sprintf('%d ',selectedChannels) '\n'] , ind, ranking(ind))
  
  if strcmp(algoritmo,'KNN')
    acc = classifyKNN(eegReal.eeg, eegReal.y, eegReal.c, k, selectedChannels, 0);
  elseif strcmp(algoritmo,'ELM')
    acc = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, nh, selectedChannels, 0);
  elseif strcmp(algoritmo,'SVM')
    acc = 0;
  end
  stdDev = std(acc);
  acc = mean(acc);
  
  fprintf('Acc Média: %f\n',acc)
  
  if acc > bestAcc % Se a inclusão do canal for melhor, mantem
    bestAcc = acc;
    bestStd = stdDev; % Desvio padrão
    bestInd = ind;
    fprintf('Novo Máximo\n')
  else
    selectedChannels = selectedChannels(1:end-1);
  end
  save dataSE-ELM
end

fprintf(['\n\n\nCanais Selecionados: ' sprintf('%i ',selectedChannels) '   -  Acc: %f±%f\n'], bestAcc,bestStd);

[ eegPlot ] = plotEGG( selectedChannels );
figure(eegPlot)
selectedChannels