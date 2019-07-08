%% Calcula resultados finais com os canais selecionados
% Os canais selecionados estão armazenados nas funções ga(),
%   ranqueamento() e cocluster(), além da função a64() com todos os canais.
% O código usa o conjunto de dados reais para o treinamento dos
%   classificadores e o conjunto de dados imagético motores para o teste.
% Após o treinamento e a classificação é calculado as Taxas de Falsa
%   Aceitação e de Falsa Rejeição, com o threshold selecionado a acurácia
%   final é calculada.
% O processo é feito para os três algoritmos de classifiação utilizados,
%   KNN, ELM e SVM.

% Carrega base de dados
addpath(genpath('../6_classification'));
eegReal = load('../eeg_seg05_AR_3_RealTask.mat');
%eegImag = load('../eeg_seg05_AR_3_ImaginaryTask.mat');
eegImag = load('../eeg_seg05_AR_3_baseline.mat');

% Define canais selecionados por qual algoritmo
%s = a64();
%s=ga();
s=ranqueamento();
%s=artigos();
%s = cocluster();


for i=1:size(s,1)
%for i=8:8
 
  fprintf(['\n\n#####\n\n' s(i).titulo s(i).name ' - %2d canais: ' getNmCanais(s(i).canais) '\n'], length(s(i).canais))  
  
  % --- KNN ---
  [Xtr] = formFeatureVector(eegReal.eeg, s(i).canais); % Define conjunto de treinamento com dados reais e os canais selecionados
  [Xtest] = formFeatureVector(eegImag.eeg, s(i).canais); % Define conjunto de teste com dados imagéticos e os canais selecionados
  [y,y_val] = KNN(Xtr,eegReal.y,Xtest,1); % Realiza a classificação com o KNN
  acc_orig = sum(y==eegImag.y)/length(y); % Obtém a acurácia original
  [ FAR, FRR, threshold, FAR_hist_KNN, FRR_hist_KNN ] = calcFAFR( y, y_val, eegImag.y, [s(i).titulo s(i).name ' com KNN'] ); % Calcula o FAR, FRR e o threshold
  [y,~] = KNN(Xtr,eegReal.y,Xtest,1,threshold); % Realiza a classificação com o KNN e com o novo threshold
  acc_final = sum(y==eegImag.y)/length(y); % Obtém a acurácia final
  % Display on screen
  fprintf(['\n  --- KNN --- \n'])
  fprintf(['- Threshold com o KNN: ' num2str(threshold) '\n'])
  fprintf(['- FAR: ' num2str(FAR) '\n'])
  fprintf(['- FRR: ' num2str(FRR) '\n'])
  fprintf(['- Acc Original: ' num2str(acc_orig) '\n'])
  fprintf(['- Acc Final: ' num2str(acc_final) '\n'])
  % Save values
  s(i).acc_KNN_orig = acc_orig;
  s(i).far_KNN = FAR;
  s(i).frr_KNN = FRR;
  s(i).acc_KNN = acc_final;
  s(i).thr_KNN = threshold;
  
  
  
  % --- ELM ---
  [~, ELMmodel] = classifyELM(eegReal.eeg, eegReal.y, eegReal.c, 2000, s(i).canais, 0); % Treina classificador ELM
  [X] = formFeatureVector(eegImag.eeg, s(i).canais); % Define conjunto de teste com dados imagéticos e os canais selecionados
  y_binary = transformClassLabels2Binary(eegImag.y); % Transforma classes do conjunto de teste em binário para a ELM
  [Yres, acc_orig, y_val] = predictELM(ELMmodel{1},X,y_binary); % Realiza a classificação com a ELM
  y = transformClassLabels2Decimal(Yres); % Transforma classes de resposta em valores inteiros novamente
  [ FAR, FRR, threshold, FAR_hist_ELM, FRR_hist_ELM ] = calcFAFR( y, y_val, eegImag.y, [s(i).titulo s(i).name ' com ELM'] ); % Calcula o FAR, FRR e o threshold
  y(y_val < threshold) = -1;
  acc_final = sum(y==eegImag.y)/length(y);
  
  % Realiza a classificação com o ELM e com o novo threshold
% Display on screen
  fprintf(['\n -- ELM --\n'])
  fprintf(['- Threshold com o ELM: ' num2str(threshold) '\n'])
  fprintf(['- FAR: ' num2str(FAR) '\n'])
  fprintf(['- FRR: ' num2str(FRR) '\n'])
  fprintf(['- Acc Original: ' num2str(acc_orig) '\n'])
  fprintf(['- Acc Final: ' num2str(acc_final) '\n'])
  % Save values
  s(i).acc_ELM_orig = acc_orig;
  s(i).far_ELM = FAR;
  s(i).frr_ELM = FRR;
  s(i).acc_ELM = acc_final;
  s(i).thr_ELM = threshold;
  
  
  
  % --- SVM ---
  [~, SVMmodel] = classifySVM(eegReal.eeg, eegReal.y, eegReal.c, 180, s(i).canais, 0); % Treina classificador SVM
  [X] = formFeatureVector(eegImag.eeg, s(i).canais); % Define conjunto de teste com dados imagéticos e os canais selecionados
  [y, acc_orig, y_val] = svmpredict(eegImag.y,X,SVMmodel{1},'-q -b 1');  % Realiza a classificação com a SVM
  %[~,aux] = unique(eegReal.y);
  %[~,ordem] = sort(aux);
  [y_val_2,b] = max(y_val,[],2); % seleciona valor da probabilidade das classes escolhidas
  [ FAR, FRR, threshold, FAR_hist_SVM, FRR_hist_SVM ] = calcFAFR( y, y_val_2, eegImag.y, [s(i).titulo s(i).name ' com SVM']); % Calcula o FAR, FRR e o threshold
  %temp = y;
  y(y_val_2 < threshold) = -1;
  acc_final = sum(y==eegImag.y)/length(y);
  
    % Realiza a classificação com o ELM e com o novo threshold
% Display on screen
  fprintf(['\n -- SVM --\n'])
  fprintf(['- Threshold com o SVM: ' num2str(threshold) '\n'])
  fprintf(['- FAR: ' num2str(FAR) '\n'])
  fprintf(['- FRR: ' num2str(FRR) '\n'])
  fprintf(['- Acc Original: ' num2str(acc_orig(1)/100) '\n'])
  fprintf(['- Acc Final: ' num2str(acc_final) '\n'])
  % Save values
  s(i).acc_SVM_orig = acc_orig(1)/100;
  s(i).far_SVM = FAR;
  s(i).frr_SVM = FRR;
  s(i).acc_SVM = acc_final;
  s(i).thr_SVM = threshold;

  
  
  
  figure
  hold on
  plot(FAR_hist_KNN,FRR_hist_KNN,'b');
  plot(FAR_hist_ELM,FRR_hist_ELM,'r');
  plot(FAR_hist_SVM,FRR_hist_SVM,'g');
  plot([0 1],[0 1],'k');
  % Legendas do Gráfico
  xlabel('Taxa de Falsa Aceitação')
  ylabel('Taxa de Falsa Rejeição')
  title(['Curva ROC para ' s(i).titulo s(i).name ])
  legend('KNN','ELM','SVM')
  
  
  %save ga_baseline s
  save gulosa_baseline s
  
  %save cocluster s
  %save cocluster2 s
  %save a64 s
  %save a64_2 s
  %save artigos s
  %save artigos2 s
  %save gulosa s
  %save gulosa2 s
  %save gulosa_NOVA s
end

  %save ga_baseline s
  save gulosa_baseline s
  
  %save cocluster s
  %save cocluster2 s
  %save a64 s
  %save a64_2 s
  %save artigos s
  %save artigos2 s