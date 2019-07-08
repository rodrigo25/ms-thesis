function [Acc] = selecaoRepresentacaoELM(filein, fileout, fileinImaginary)
%SELECAOREPRESENTACAOELM - Seleção de Representação com o classificador ELM
% 
% Realiza a classificação de um arquivo de dados usando todos os 64 canais
% com uma variação dos neuronios nh de 100 a 2000 em intervalos de 100.
%
% Entrada:
%   filein - Nome do arquivo com os dados a serem classificados e uma
%            partição de cross-validation (cvpartition)
%   fileout - Nome do arquivo onde os resultados serão armazenados
%
% Saida:
%   Acc - Matriz de resultados com validação cruzada de 10 folds para cada
%         variação de k.
%   [Arquivo Resposta] - Arquivo txt com a acurácia média e o desvio padrão
%                        para todas as variações de k, além da matriz Acc.

  addpath(genpath('../6_classification'))
  % Abre um arquivo com a matriz de dados
  load(filein)  % eeg - matriz de dados
                % y   - rotulos de cada
                % c   - cvpartition com um cross-validation de 10 folds
                
  eegImaginary = load(fileinImaginary);
  eegImaginary.y = transformClassLabels2Binary(eegImaginary.y);
  

  parameters = 100:100:2000;
  channels = 1:64;
  [Acc, knnModels] = classifyELM(eeg, y, c, parameters, channels, 1);
  
  mediaAcc = mean(Acc);
  desvioAcc = std(Acc);
  
  for i=1:length(parameters)
    [Ytest, AccImaginary(i)] = predictELM(knnModels{i},eegImaginary.eeg, eegImaginary.y);
    %AccImaginary(i) = sum(Ytest==eegImaginary.y)/length(Ytest); % Calcula taxa de reconhecimento
  end
  
  % SALVA ARQUIVO DE SAIDA COM OS RESULTADOS
  fid = fopen(fileout,'w');
  for nh=1:length(parameters)
    fprintf(fid, 'nh%2i - %f ± %f\n', nh, mediaAcc(nh), desvioAcc(nh));
  end
  
  fprintf(fid,'\n\nnh100   ,nh200   ,nh300   ,nh400   ,nh500   ,nh600   ,nh700   ,nh800   ,nh900   ,nh1000  ,nh1100  ,nh1200  ,nh1300  ,nh1400  ,nh1500  ,nh1600  ,nh1700  ,nh1800  ,nh1900  ,nh2000\n');
  for nh=1:length(parameters)
    fprintf(fid, '%.6f,', AccImaginary(nh));
  end
  
  fprintf(fid,'\n\nnh100   ,nh200   ,nh300   ,nh400   ,nh500   ,nh600   ,nh700   ,nh800   ,nh900   ,nh1000  ,nh1100  ,nh1200  ,nh1300  ,nh1400  ,nh1500  ,nh1600  ,nh1700  ,nh1800  ,nh1900  ,nh2000\n');
  fclose(fid);
  dlmwrite(fileout, Acc, '-append', 'precision','%.6f');
end
