function [Acc] = selecaoRepresentacaoKNN(filein, fileout, fileinImaginary)
%SELECAOREPRESENTACAOKNN - Seleção de Representação com o classificador KNN
% 
% Realiza a classificação de um arquivo de dados usando todos os 64 canais
% com uma variação dos vizinhos k de 1 a 10.
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

  % Abre um arquivo com a matriz de dados
  load(filein)  % eeg - matriz de dados
                % y   - rotulos de cada
                % c   - cvpartition com um cross-validation de 10 folds
  eegImaginary = load(fileinImaginary);
  
  Acc = zeros(c.NumTestSets,10); % Armazena os resultados da Acc para cada fold com 10 valores de vizinhos k
  
  AccImaginary = zeros(10,1);
  
  for k=1:10 % Numero de vizinhos do knn
    fprintf('k%i',k);
    
    for fold = 1:c.NumTestSets  % Fold do Cross-Validation
      fprintf('.')
      
      % SEPARAÇÃO DE DADOS DOS FOLDS
      indTr = c.training(fold); % Indice dos dados de treinamento do fold atual
      indTest = c.test(fold);   % Indice dos dados de teste do fold atual
      
      % TREINAMENTO E TESTE DO MODELO
      knnModel = fitcknn(eeg(indTr,:),y(indTr),'NumNeighbors',k,'Distance','euclidean'); % Treina modelo com dos dados do treinamento do fold atual
      Ytest = predict(knnModel,eeg(indTest,:));  % Prediz rotulos dos dados de teste do fold atual
      
      % CALCULA RESULTADOS
      Acc(fold,k) = sum(Ytest==y(indTest))/length(Ytest); % Calcula taxa de reconhecimento
    end
    
    knnModel = fitcknn(eeg,y,'NumNeighbors',k,'Distance','euclidean'); % Treina modelo com todos os dados Reais
    Ytest = predict(knnModel,eegImaginary.eeg);
    AccImaginary(k) = sum(Ytest==eegImaginary.y)/length(Ytest); % Calcula taxa de reconhecimento
    
  end
  
  mediaAcc = mean(Acc);
  desvioAcc = std(Acc);
  
  
  % SALVA ARQUIVO DE SAIDA COM OS RESULTADOS
  fid = fopen(fileout,'w');
  for k=1:10
    fprintf(fid, 'k%2i - %f ± %f\n', k, mediaAcc(k), desvioAcc(k));
  end
  
  fprintf(fid,'\n\nAcc Imaginary\nk01     ,k02     ,k03     ,k04     ,k05     ,k06     ,k07     ,k08     ,k09     ,k10\n');
  for k=1:10
    fprintf(fid, '%.6f,', AccImaginary(k));
  end
  
  fprintf(fid,'\n\nAcc Real\nk01     ,k02     ,k03     ,k04     ,k05     ,k06     ,k07     ,k08     ,k09     ,k10\n');
  fclose(fid);
  dlmwrite(fileout, Acc, '-append', 'precision','%.6f');
  

  
end