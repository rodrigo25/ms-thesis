addpath(genpath('../../6_classification'))
eegReal = load('../eeg_seg05_AR_3_RealTask.mat');

% DEFINI��O DE VARI�VEIS
algoritmo = 'ELM'; %KNN, ELM ou SVM
k  = 1;     % k  - Vizinhos do KNN
nh = 2000;  % nh - Neur�nios do ELM
C  = 180;   % C  - C do SVM

bestAcc = 0.994281;  % Armazena a melhor acc
remainingChannels = 1:64; % Canais remanescentes

%fprintf('1� Itera��o\n');

% CALCULA ACUR�CIA USANDO APENAS UM CANAL POR VEZ
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
%  % VERIFICA SE ACUR�CIA � MAIOR DO QUE OS CANAIS ANTERIORES
%  if acc>bestAcc
%    bestAcc = acc; % Melhor Acur�cia
%    bestStd = stdDev; % Desvio padr�o
%    selectedChannels = channel; % Canal com melhor acur�cia
%    bestIndex = channel; % Indice do canal de melhor acur�cia
%    fprintf('-> ');
%  end
%  fprintf('(%i)=%f\n', channel, acc);
%end
%fprintf('\nMelhor (%i)=%f\n\n', selectedChannels, bestAcc);

% RETIRA CANAL SELECIONADO DA LISTA DE CANAIS REMANESCENTES
%remainingChannels(bestIndex) = [];

selectedChannels = [64 46 44 28 53 1 36 37 38 22 43 51 62 3 11];
remainingChannels(selectedChannels) = [];

increased = true; % Vari�vel de controle de aumento na acur�cia

it=15;
while (increased)
  increased = false;
  it=it+1;
  fprintf('%i� Itera��o\n',it);
  % INCLUI CADA CANAL REMANESCENTE UM POR VEZ E VERIFICA SE HOUVE AUMENTO
  % NA ACUR�CIA
  for i=1:length(remainingChannels)
    % INCLUI O CANAL i
    aux = [selectedChannels remainingChannels(i)];
    
    % CALCULA ACUR�CIA COM OS CANAIS EM aux
    if strcmp(algoritmo,'KNN')
      acc = classifyKNN(eegReal.eeg, eegReal.y, eegReal.c, k, aux, 0);
    elseif strcmp(algoritmo,'ELM')
      acc = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, nh, aux, 0);
    elseif strcmp(algoritmo,'SVM')
      acc = 0;
    end
    stdDev = std(acc);
    acc = mean(acc);
    
    % VERIFICA SE HOUVE AUMENTO NA ACUR�CIA
    if acc>bestAcc
      bestAcc = acc; % Melhor Acur�cia
      bestStd = stdDev; % Desvio padr�o
      bestIndex = i; % Indice do canal de melhor acur�cia
      increased = true; % Seta a vari�vel de controle para continuar
      fprintf('-> ');
    end
    fprintf(['( ' repmat('%i ',[1,size(aux,2)]) ') - %f\n'], aux,acc);
  end
  
  if increased % Se houve aumento na acur�cia inclui o canal selecionado
    selectedChannels = [selectedChannels remainingChannels(bestIndex)];
    remainingChannels(bestIndex) = [];
  end
  
  save data.mat
  fprintf(['\nMelhor ( ' repmat('%i ',[1,size(selectedChannels,2)]) ') - %f�%f\n\n'], selectedChannels,bestAcc, bestStd);
end

fprintf(['\n\n\nCanais Selecionados: ' sprintf('%i ',selectedChannels) '   -  Acc: %f�%f\n'], bestAcc, bestStd);

[ eegPlot ] = plotEGG( selectedChannels );
figure(eegPlot)
selectedChannels