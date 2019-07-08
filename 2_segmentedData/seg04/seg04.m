%function seg04()

  fprintf ('---------------------------------------------------\n')
  fprintf ('----------------- Segmentation 04 -----------------\n')
  fprintf ('---------------------------------------------------\n')
  
  tamJanela = 640; %4seg*160
  qtdJanela = 10;
  espacoTotalJanela = tamJanela * qtdJanela;
  qtdVazio = qtdJanela-1;
  
  for exp=3:14
    %filein = ['../../2_filteredData/eegexp' num2str(exp) '_filtered'];
    filein = ['../../1_acceptedData/eegexp' num2str(exp)];
    fprintf ('\n--- Loading file ''%s''\n', filein)
    load(filein)

    EEG = cell(102,1); % NOVA ESTRUTURA COM OS SINAIS

    fprintf('--- Segmentation in process\n')
    for S=1:102 %Percorre os 103 sujeitos

      espacoTotal = length(eeg{S}.sig);

      espacoTotalVazio = espacoTotal - espacoTotalJanela;
      tamVazio = floor(espacoTotalVazio/qtdVazio);

      for i=1:qtdJanela

        ini = (i-1)*(tamJanela + tamVazio)+1;
        interval = (ini:ini+tamJanela-1)';
        EEG{S,i} = eeg{S}.sig(interval,1:64);

      end
    end


    fileout = ['eegexp' num2str(exp) 'seg04'];
    fprintf('--- Saving File ''%s''\n', fileout)
    save(fileout,'EEG')
    fprintf('--- File Saved!\n')
  end
  
%end