%function seg02()

  fprintf ('---------------------------------------------------\n')
  fprintf ('----------------- Segmentation 02 -----------------\n')
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
          interval = (eeg{S}.sample(i)-320:eeg{S}.sample(i)+479)';
          %code = [zeros(320,1); repmat(str2double(eeg{S}.code(i,2)),480,1)];
          %if ~isempty(interval(interval<0))
          %  code = code(interval>0);
          %  interval = interval(interval>0);
          %end

          %EEG{S}{ind} = [eeg{S}.sig(interval,:) interval code];  
          EEG{S,ind} = eeg{S}.sig(interval,1:64);
        end

      end
    end

    
    fileout = ['eegexp' num2str(exp) 'seg02'];
    fprintf('--- Saving File ''%s''\n', fileout)
    save(fileout,'EEG')
    fprintf('--- File Saved!\n')
  end

%end