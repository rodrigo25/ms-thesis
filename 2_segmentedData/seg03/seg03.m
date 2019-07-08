function seg03(windowSize)

  fprintf ('---------------------------------------------------\n')
  fprintf ('----------------- Segmentation 03 -----------------\n')
  fprintf ('---------------------------------------------------\n')
  
  if nargin<1
    %windowSize =  960; % 6s   inicial
    %windowSize = 1920; % 12s
    %windowSize = 3840; % 24s
    windowSize = 4800; % 30s  melhor
    %windowSize = 6400; % 40s
    %windowSize = 9600; % 60s
  end
  
  for exp=3:14
    %filein = ['../../2_filteredData/eegexp' num2str(exp) '_filtered'];
    filein = ['../../1_acceptedData/eegexp' num2str(exp)];
    fprintf ('\n--- Loading file ''%s''\n', filein)
    load(filein)

    EEG = cell(102,1); % NOVA ESTRUTURA COM OS SINAIS

    fprintf('--- Segmentation in process\n')
    for S=1:102 %Percorre os 102 sujeitos

      qtdSamples = floor(length(eeg{S}.sig)/windowSize);
      %EEG{S} = cell(qtdSamples,1); %Inicia com so 2 e depois vai crescendo

      for i=1:qtdSamples

        interval = ((i-1)*windowSize+1:i*windowSize)';
        EEG{S,i} = eeg{S}.sig(interval,1:64);

      end
    end


    fileout = ['eegexp' num2str(exp) 'seg03'];
    fprintf('--- Saving File ''%s''\n', fileout)
    save(fileout,'EEG')
    fprintf('--- File Saved!\n')
  end
  
end