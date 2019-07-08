SEGs={'seg01','seg02','seg03','seg04','seg05'};
%SEGs={'seg04','seg05'};
%SEGs={'seg05'};

for n = [400]
  for alphabetSize = 5;
    for indSeg = 1: length(SEGs)
      seg = SEGs{indSeg};
      fprintf('\n\n-------\n\nExtraindo features dos arquivos de Segmentação %s\n\n', seg)

      eeg = cell(102,4);

      for exp=3:14
        filein = ['../2_segmentedData/' seg  '/eegexp' num2str(exp) seg];
        fprintf ('\n- Loading file ''%s''\n', filein)
        load(filein)
        task = rem((exp-3),4)+1; %numero da tarefa
        for S=1:102 %Percorre as 102 pessoas
          fprintf('- Extraindo features do sujeito %d\n', S)
          totalSamplesExp = size(EEG,2);
          signalSize = size(EEG{1,1},1);
          for i=1:totalSamplesExp
            X = zeros(64,n);
            for ch=1:64
              [X(ch,:), ~] =  timeseries2symbol(EEG{S,i}(:,ch), signalSize, n, alphabetSize); %Chama a função de extração de features
            end

            sampleTask = length(eeg{S,task})+1;
            eeg{S,task}{sampleTask} = X;
          end
        end
      end

      fileout = ['SAX/eeg_' seg '_SAX_' num2str(n) '_' num2str(alphabetSize)];

      fprintf('\n --- Salvando Arquivo %s', fileout)
      save(fileout,'eeg')
      fprintf('\n --- Arquivo Salvo!\n')
      clear eeg
    end
  end
end
