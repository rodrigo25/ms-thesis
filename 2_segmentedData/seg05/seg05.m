function seg05()

  fprintf ('---------------------------------------------------\n')
  fprintf ('----------------- Segmentation 05 -----------------\n')
  fprintf ('---------------------------------------------------\n')
  
  for exp=3:14
    %filein = ['../../2_filteredData/eegexp' num2str(exp) '_filtered'];
    filein = ['../../1_acceptedData/eegexp' num2str(exp)];
    fprintf ('\n--- Loading file ''%s''\n', filein)
    load(filein)

    EEG = cell(102,1); % NOVA ESTRUTURA COM OS SINAIS

    fprintf('--- Segmentation in process\n')
    for S=1:102 %Percorre os 103 sujeitos

      tamTotal = length(eeg{S}.sig);
      ini = floor((tamTotal-16000)/2);
      
      for i=1:20
        interval = (ini+(i-1)*800+1:ini+i*800)';
        EEG{S,i} = eeg{S}.sig(interval,1:64);
      end
    end


    fileout = ['eegexp' num2str(exp) 'seg05'];
    fprintf('--- Saving File %''s''\n', fileout)
    save(fileout,'EEG')
    fprintf('--- File Saved!\n')
  end
  
end