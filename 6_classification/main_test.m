addpath('KNN')
addpath('ELM')
load('D:\Documentos\Rodrigo\USP\Pós Graduação\OneDrive\Projeto\Códigos\defesa\7_channel_selection\eeg_seg05_AR_3_RealTask.mat')

[AccKNN] = classifyKNN(eeg, y, c, [1 2], 1:64)

[AccELM] = classifyELM(eeg, y, c, [500 1000], 1:64)