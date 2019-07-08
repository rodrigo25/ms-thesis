addpath(genpath('../../6_classification'))
eegReal = load('../eeg_seg05_AR_3_RealTask.mat');

% DEFINI��O DE VARI�VEIS
algoritmo = 'ELM'; %KNN, ELM ou SVM
k  = 1;     % k  - Vizinhos do KNN
nh = 2000;  % nh - Neur�nios do ELM
C  = 180;  % C  - C do SVM

bestAcc = 0;  % Armazena a melhor acc
remainingChannels = 1:64; % Canais remanescentes

increased = true; % Vari�vel de controle de aumento na acur�cia

it=0;
while (increased)
  increased = false;
  it=it+1;
  fprintf('%i� Itera��o\n',it);
  % Remove um dos canais remanecente por vez e verifica a acur�cia
  for i=1:length(remainingChannels)
    aux = remainingChannels; 
    aux(i) = []; % exclui o canal i
    %calcula a acuracia com os canais em aux
    
    if strcmp(algoritmo,'KNN')
      acc = classifyKNN(eegReal.eeg, eegReal.y, eegReal.c, k, aux, 0);
    elseif strcmp(algoritmo,'ELM')
      acc = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, nh, aux, 0);
    elseif strcmp(algoritmo,'SVM')
      acc = 0;
    end
    stdDev = std(acc);
    acc = mean(acc);

    
    if acc>=bestAcc
      bestAcc = acc; % Melhor Acur�cia
      bestStd = stdDev; % Desvio padr�o
      bestIndex = i; % Indice do canal de que removido resulta uma melhor acur�cia
      increased = true; % Seta a vari�vel de controle para continuar
      fprintf('-> ');
    end
    fprintf(['Remove ch%i - ( ' repmat('%i ',[1,size(aux,2)]) ') - %f\n'],remainingChannels(i), aux,acc);
    save dataBS-ELM-Interno.mat
  end
  
  if increased % Se houve aumento na acur�cia remove o canal selecionado
    %selectedChannels = [selectedChannels remainingChannels(bestIndex)];
    remainingChannels(bestIndex) = [];
  end
  
  save dataBS-ELM-It.mat
  fprintf(['\nMelhor ( ' repmat('%i ',[1,size(remainingChannels,2)]) ') - %f\n\n'], remainingChannels,bestAcc);
end

fprintf(['\n\n\nCanais Selecionados: ' sprintf('%i ',remainingChannels) '   -  Acc: %f�%f\n'], bestAcc, bestStd);

[ eegPlot ] = plotEGG( remainingChannels );
figure(eegPlot)
remainingChannels