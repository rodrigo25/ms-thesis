SEGs={'seg01','seg02','seg03','seg04','seg05'};
%SEGs={'seg04','seg05'};
%SEGs={'seg05'};

for param = [1,2,3,4,5,6,7,8,9,10,15,20]
  for indSeg = 1: length(SEGs)
    seg = SEGs{indSeg};
    fprintf('\n\n-------\n\nExtraindo features dos arquivos de Segmentação %s\n\n', seg)

    eeg = cell(102,4);

    for exp=1:2
      filein = ['../2_segmentedData/' seg  '/eegexp' num2str(exp) seg];
      fprintf ('\n- Loading file ''%s''\n', filein)
      load(filein)
      task = rem((exp-3),4)+1; %numero da tarefa
      for S=1:102 %Percorre as 102 pessoas
        fprintf('- Extraindo features do sujeito %d\n', S)
        totalSamplesExp = size(EEG,2);
        for i=1:totalSamplesExp
          X = aryule(EEG{S,i},param); %Chama a função de extração de features
          sampleTask = length(eeg{S,task})+1;
          eeg{S,task}{sampleTask} = X(:,2:end);
        end
      end
    end

    fileout = ['AR/eeg_' seg '_AR_' num2str(param)];

    fprintf('\n --- Salvando Arquivo %s', fileout)
    save(fileout,'eeg')
    fprintf('\n --- Arquivo Salvo!\n')
    clear eeg
  end
end
