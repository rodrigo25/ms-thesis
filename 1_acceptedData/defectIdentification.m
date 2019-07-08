% Identifies subjects with incomplete recordings, with less than 2 min (30 samples)

% Verifica subjects com exames incompletos, com menos de 2 min de duracao (30 amostras)

fprintf('             ################################################################\n')
fprintf('             ################## Identificação de Defeitos ###################\n')
fprintf('             ################################################################\n')

falhos = [];

% Verifica sujeitos defeituosos
for exp=3:14
  filein = ['../0_rawData/eegexp' num2str(exp)];
  fprintf ('\n- Carregando arquivo ''%s''\n', filein)
  load(filein);
  
  fprintf ('- Sujeitos com gravações defeituosas\n')
  for S=1:109 %Percorre os 109 sujeitos
    if (length(eeg{S}.sample)<30) || ismember(1,isnan(eeg{S}.sig))
      fprintf('S%3d -> %d samples - %d pontos\n',S,length(eeg{S}.sample),length(eeg{S}.sig))
      if ~ismember(S,falhos)
        falhos = [falhos S];
      end
    end   
  end
  
end

fprintf('\n\n\n\n------------------------------------------------------\n\nSujeitos com gravações defeituosas: ')
falhos
fprintf('\n\n------------------------------------------------------\n\n')



% Remove sujeitos defeituosos
for exp=3:14
  filein = ['../0_rawData/eegexp' num2str(exp)];
  fprintf ('\n--- Removendo sujeitos do arquivo ''%s''\n', filein)
  load(filein);
  
  for S=1:109 %Percorre os 109 sujeitos
    if ismember(S,falhos)
      eeg{S}=[];
    end   
  end
  
  eeg = eeg(~cellfun(@isempty, eeg));
  
  fileout = ['eegexp' num2str(exp)];
  save(fileout,'eeg')
end
