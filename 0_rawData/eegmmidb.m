% Download the EEG Motor Movement/Imagery Dataset from PhysioNet.
% For each experiment a file is created with a variable 'eeg' with 109
% cells, one for each subject

% Download dos dados de EEG da base de dados EEG Motor Movement/Imagery Dataset
% da PhysioNet. Os dados de cada experimento são armazenados em um arquivo
% com a variável 'eeg' com 109 celulas, uma para cada indivíduo.

function eegmmidb(subjects, experiments)
  fprintf('             ################################################################\n')
  fprintf('             ######## Downloading EEG Motor Movement/Imagery Dataset ########\n')
  fprintf('             ################################################################\n')

  if     nargin<2, experiments = 3:14;
  elseif nargin<1, subjects = 1:109;
  end

  for R=experiments % Experimentos percorridos
  
    fprintf('\n\n----------------------\n    Experimento %2d\n----------------------\n\n', R)
  
    eeg = cell(109,1); %Cria uma celula para cada pessoa para os resultados do experimento R
  
    fileout = ['eegexp' num2str(R)];
  
    for S=subjects %Pessoas percorridos
  
      %Define o nome do arquivo
      nm_arquivo = ['eegmmidb/S' num2str(S,'%03d') '/S' num2str(S,'%03d') 'R' num2str(R,'%02d') '.edf'];
      disp(nm_arquivo)
    
      %Baixa os dados da Physionet
      [tm,sig]=rdsamp(nm_arquivo,[],[],[],1,1);
      [sample,~,~,~,~,comments]=rdann(nm_arquivo,'event');
    
      code = [];
      duration = zeros(size(comments,1),1);
      for i=1:size(comments,1)
        temp=strsplit(comments{i});
        code = [code; cell2mat(temp(1))];
        duration(i) = str2double(cell2mat(temp(3)));
      end
    
      %Armazena os dados da pessoa S na celula 'eeg'
      eeg{S} = struct('sig',sig,'time',tm,'sample',sample,'code',code,'duration',duration);
      %eeg{S,1} = sig;
      %eegTask1{S,2} = tm;
    
      save(fileout,'eeg')
    end
  
    %Salva os dados em arquivo
    save(fileout,'eeg')
  
    clear eeg
  end
end