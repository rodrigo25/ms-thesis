function main ()
  global fileinpath fileoutpath;
  % define diretório raiz dos dados (fileinpath) e o diretório raiz onde os resultados serão armazenados (fileoutpath)
  fileinpath  = 'G:/Meu Drive/mestrado/Physionet - EEG Motor Movement & Imagery Dataset/5_datasets/Defesa/';
  fileoutpath = 'Resultados/';
  
  AR();
end

%--------
function AR ()
  fprintf('\n ### Iniciando testes da representação AR ###\n')
  feat = 'AR';
  coef_ar = [9 20];
  global fileinpath fileoutpath;
  
  for seg = {'seg02','seg03','seg05'}
  %for seg = {'seg04','seg05'}
    for param = coef_ar
      fprintf('\n%s - %2i coeficiente -> ', cell2mat(seg), param);
      filein = [fileinpath 'AR/eeg_' cell2mat(seg) '_' feat '_' num2str(param) '_RealTask'];
      fileinImaginary = [fileinpath 'AR/Imaginary/eeg_' cell2mat(seg) '_' feat '_' num2str(param) '_ImaginaryTask'];
      
      %fileout = [fileoutpath 'AR2/KNN/eeg_' cell2mat(seg) '_' feat '_' num2str(param) '_RealTask.txt'];
      %selecaoRepresentacaoKNN(filein,fileout,fileinImaginary);
      
      fileout = [fileoutpath 'AR3/ELM/eeg_' cell2mat(seg) '_' feat '_' num2str(param) '.txt'];
      selecaoRepresentacaoELM(filein,fileout,fileinImaginary);
      
      %fileout = [fileoutpath 'AR2/SVM/eeg_' cell2mat(seg) '_' feat '_' num2str(param) '_RealTask.txt'];
      %selecaoRepresentacaoSVM(filein,fileout,fileinImaginary);
    end
  end;
end

%--------
function SAX
  feat = 'SAX';
  window = [100]; % Window
  alphabet = 2:20; % Alphabet
  global fileinpath fileoutpath;
  
  for seg = {'seg03'}
    for w = window
      for a = alphabet
        fprintf('\n%s - %3i windows, %2i alphabet -> ', cell2mat(seg), w, a);
        filein = [fileinpath 'SAX/eeg_' cell2mat(seg) '_' feat '_a' num2str(a) '_w' num2str(w) '_RealTask'];
        %fileout = [fileoutpath 'SAX/KNN/eeg_' cell2mat(seg) '_' feat '_a' num2str(a) '_w' num2str(w) '_RealTask.txt'];
        %selecaoRepresentacaoKNN(filein,fileout);
        
        fileout = [fileoutpath 'SAX/ELM/eeg_' cell2mat(seg) '_' feat '_a' num2str(a) '_w' num2str(w) '_RealTask.txt'];
        selecaoRepresentacaoELM(filein,fileout);
        
      end
    end
  end;
  
end



%--------
function ESAX
  fprintf('\n## ESAX ##\n');
  feat = 'ESAX';
  window = [100 160 200 300 400]; % Window
  alphabet = 2:20; % Alphabet
  global fileinpath fileoutpath;
  
  for seg = {'seg03'}
    for w = window
      for a = alphabet
        fprintf('\n%s - %3i windows, %2i alphabet -> ', cell2mat(seg), w, a);
        filein = [fileinpath 'ESAX/eeg_' cell2mat(seg) '_' feat '_a' num2str(a) '_w' num2str(w) '_RealTask'];
        fileout = [fileoutpath 'ESAX/KNN/eeg_' cell2mat(seg) '_' feat '_a' num2str(a) '_w' num2str(w) '_RealTask.txt'];
        selecaoRepresentacaoKNN(filein,fileout);
      end
    end
  end;
  
end


%--------
%eSAX, SPTA, GASAX, DESAX, 1DSAX, SAXTD, aSAX, EFVD, EWD, EFD, ENSAX, VWSAX, DWT

