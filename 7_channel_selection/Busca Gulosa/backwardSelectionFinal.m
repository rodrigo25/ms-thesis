addpath(genpath('../../6_classification'))
eegReal = load('../eeg_seg05_AR_3_RealTask.mat');

% DEFINIÇÃO DE VARIÁVEIS
algoritmo = 'ELM'; %KNN, ELM ou SVM
k  = 1;     % k  - Vizinhos do KNN
nh = 2000;  % nh - Neurônios do ELM
C  = 180;  % C  - C do SVM

bestAcc = 0;  % Armazena a melhor acc
remainingChannels = 1:64; % Canais remanescentes

increased = true; % Variável de controle de aumento na acurácia

it=0;
while (increased)
  increased = false;
  it=it+1;
  fprintf('%iª Iteração\n',it);
  % Remove um dos canais remanecente por vez e verifica a acurácia
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
      bestAcc = acc; % Melhor Acurácia
      bestStd = stdDev; % Desvio padrão
      bestIndex = i; % Indice do canal de que removido resulta uma melhor acurácia
      increased = true; % Seta a variável de controle para continuar
      fprintf('-> ');
    end
    fprintf(['Remove ch%i - ( ' repmat('%i ',[1,size(aux,2)]) ') - %f\n'],remainingChannels(i), aux,acc);
    save dataBS-ELM-Interno.mat
  end
  
  if increased % Se houve aumento na acurácia remove o canal selecionado
    %selectedChannels = [selectedChannels remainingChannels(bestIndex)];
    remainingChannels(bestIndex) = [];
  end
  
  save dataBS-ELM-It.mat
  fprintf(['\nMelhor ( ' repmat('%i ',[1,size(remainingChannels,2)]) ') - %f\n\n'], remainingChannels,bestAcc);
end

fprintf(['\n\n\nCanais Selecionados: ' sprintf('%i ',remainingChannels) '   -  Acc: %f±%f\n'], bestAcc, bestStd);

[ eegPlot ] = plotEGG( remainingChannels );
figure(eegPlot)
remainingChannels