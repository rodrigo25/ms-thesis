function [ eval ] = fitness_eeg( population, old_population, old_eval )
  
  n = size(population,1);
  eval = zeros(n,1);
  %eval = rand(n,1);
  %for i=1:n
  %  fprintf('%2d - %1.5f    ',i,eval(i));
  %  if rem(i,10) == 0
  %    fprintf('\n');
  %  end
  %end
  %return
  
%   global eeg y c;
%   eeg2 = eeg;
%   y2 = y;
%   c2 = c;
  
%  tic
  
  for i=1:n
    if nargin>1
      [contains, row] = ismember(population(i,:),old_population, 'rows');
      if contains
        eval(i) = old_eval(row);
        continue
      end
    end
    
    cromossomoChannels = population(i,1:64);
    cromossomoClassifier = population(i,65);
    cromossomoParameter = population(i,66:69);

    channels=find(cromossomoChannels);
    parameter = sum(fliplr(cromossomoParameter).*2.^(0:3))+1;
    if isempty(channels)
      eval(i) = 0;
      continue
    end
    
    if (cromossomoClassifier == 0)
      Acc = classifyKNN_global(parameter,channels,0);
      %Acc = classifyKNN(eeg2, y2, c2, parameter,channels,0);
      eval(i) = sum(Acc)/10;
      fprintf('%2d - %1.5f (KNN)   ',i,eval(i));
    else
      nh = parameter*100+200;
      Acc = classifyELM_global(nh,channels,0);
      %Acc = classifyELM(eeg2,y2,c2,nh,channels,0);
      eval(i) = sum(Acc)/10;
      fprintf('%2d - %1.5f (ELM)   ',i,eval(i));
    end
    
    if rem(i,20) == 0
      fprintf('\n');
    end
    
  end

  %disp(toc)
end

