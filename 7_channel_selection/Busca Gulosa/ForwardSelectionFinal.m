addpath(genpath('../../6_classification'))
eegReal = load('../eeg_seg05_AR_3_RealTask.mat');

% DEFINIÇÃO DE VARIÁVEIS
algoritmo = 'ELM'; %KNN, ELM ou SVM
k  = 1;     % k  - Vizinhos do KNN
nh = 2000;  % nh - Neurônios do ELM
C  = 180;   % C  - C do SVM

bestAcc = 0.994281;  % Armazena a melhor acc
remainingChannels = 1:64; % Canais remanescentes

%fprintf('1ª Iteração\n');

% CALCULA ACURÁCIA USANDO APENAS UM CANAL POR VEZ
%for channel=1:64
%  if strcmp(algoritmo,'KNN')
%    acc = classifyKNN(eegReal.eeg, eegReal.y, eegReal.c, k, channel, 0);
%  elseif strcmp(algoritmo,'ELM')
%    acc = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, nh, channel, 0);
%  elseif strcmp(algoritmo,'SVM')
%    acc = 0;
%  end
%  stdDev = std(acc);
%  acc = mean(acc);
%  
%  % VERIFICA SE ACURÁCIA É MAIOR DO QUE OS CANAIS ANTERIORES
%  if acc>bestAcc
%    bestAcc = acc; % Melhor Acurácia
%    bestStd = stdDev; % Desvio padrão
%    selectedChannels = channel; % Canal com melhor acurácia
%    bestIndex = channel; % Indice do canal de melhor acurácia
%    fprintf('-> ');
%  end
%  fprintf('(%i)=%f\n', channel, acc);
%end
%fprintf('\nMelhor (%i)=%f\n\n', selectedChannels, bestAcc);

% RETIRA CANAL SELECIONADO DA LISTA DE CANAIS REMANESCENTES
%remainingChannels(bestIndex) = [];

selectedChannels = [64 46 44 28 53 1 36 37 38 22 43 51 62 3 11];
remainingChannels(selectedChannels) = [];

increased = true; % Variável de controle de aumento na acurácia

it=15;
while (increased)
  increased = false;
  it=it+1;
  fprintf('%iª Iteração\n',it);
  % INCLUI CADA CANAL REMANESCENTE UM POR VEZ E VERIFICA SE HOUVE AUMENTO
  % NA ACURÁCIA
  for i=1:length(remainingChannels)
    % INCLUI O CANAL i
    aux = [selectedChannels remainingChannels(i)];
    
    % CALCULA ACURÁCIA COM OS CANAIS EM aux
    if strcmp(algoritmo,'KNN')
      acc = classifyKNN(eegReal.eeg, eegReal.y, eegReal.c, k, aux, 0);
    elseif strcmp(algoritmo,'ELM')
      acc = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, nh, aux, 0);
    elseif strcmp(algoritmo,'SVM')
      acc = 0;
    end
    stdDev = std(acc);
    acc = mean(acc);
    
    % VERIFICA SE HOUVE AUMENTO NA ACURÁCIA
    if acc>bestAcc
      bestAcc = acc; % Melhor Acurácia
      bestStd = stdDev; % Desvio padrão
      bestIndex = i; % Indice do canal de melhor acurácia
      increased = true; % Seta a variável de controle para continuar
      fprintf('-> ');
    end
    fprintf(['( ' repmat('%i ',[1,size(aux,2)]) ') - %f\n'], aux,acc);
  end
  
  if increased % Se houve aumento na acurácia inclui o canal selecionado
    selectedChannels = [selectedChannels remainingChannels(bestIndex)];
    remainingChannels(bestIndex) = [];
  end
  
  save data.mat
  fprintf(['\nMelhor ( ' repmat('%i ',[1,size(selectedChannels,2)]) ') - %f±%f\n\n'], selectedChannels,bestAcc, bestStd);
end

fprintf(['\n\n\nCanais Selecionados: ' sprintf('%i ',selectedChannels) '   -  Acc: %f±%f\n'], bestAcc, bestStd);

[ eegPlot ] = plotEGG( selectedChannels );
figure(eegPlot)
selectedChannels