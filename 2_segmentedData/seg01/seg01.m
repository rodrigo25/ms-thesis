%function seg01()

  fprintf ('---------------------------------------------------\n')
  fprintf ('----------------- Segmentation 01 -----------------\n')
  fprintf ('---------------------------------------------------\n')
  
  for exp=3:14
    %filein = ['../../2_filteredData/eegexp' num2str(exp) '_filtered'];
    filein = ['../../1_acceptedData/eegexp' num2str(exp)];
    fprintf ('\n--- Loading file ''%s''\n', filein)
    load(filein)

    EEG = cell(102,1); % NOVA ESTRUTURA COM OS SINAIS

    fprintf('--- Segmentation in process\n')
    for S=1:102 %Percorre os 102 sujeitos

      qtdSamples = size(eeg{S}.sample,1);
      %EEG{S} = cell(2,1); %Inicia com so 2 e depois vai crescendo
      ind = 0;
      for i=1:qtdSamples
        code = eeg{S}.code(i,:);

        if strcmp(code,'T1') || strcmp(code,'T2')  
          ind = ind+1;
          if (i<qtdSamples) %CORTA ATE A PROXIMA AMOSTRA
            interval = (eeg{S}.sample(i):eeg{S}.sample(i+1)-1)';
          else %CORTA ATE O FIM
            if eeg{S}.sample(i)+655 > size(eeg{S}.sig,1)
              interval = (eeg{S}.sample(i):size(eeg{S}.sig,1))';
            else
              interval = (eeg{S}.sample(i):eeg{S}.sample(i)+655)';
            end
          end
          %code = repmat(str2double(eeg{S}.code(i,2)),length(interval),1);
          
          %EEG{S,ind} = [eeg{S}.sig(interval,:) interval code];
          EEG{S, ind} = eeg{S}.sig(interval,1:64);
        end

      end
    end


    fileout = ['eegexp' num2str(exp) 'seg01'];
    fprintf('--- Saving File ''%s''\n', fileout)
    save(fileout,'EEG')
    fprintf('--- File Saved!\n')
  end
  
%end