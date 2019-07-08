function [ eval ] = fitness_eegKNN( population, old_population, old_eval )
  
  n = size(population,1);
  eval = zeros(n,1);
  
%  tic
  for i=1:n
    if rem(i-1,20) == 0
      fprintf('\n');
    end
    
    if nargin>1
      [contains, row] = ismember(population(i,:),old_population, 'rows');
      if contains
        eval(i) = old_eval(row);
        fprintf('%2d - %1.5f. ',i,eval(i));
        continue
      end
    end
    
    cromossomoChannels = population(i,1:64);
    cromossomoParameter = population(i,65:68);

    channels=find(cromossomoChannels);
    parameter = sum(fliplr(cromossomoParameter).*2.^(0:3))+1;
    if isempty(channels)
      eval(i) = 0;
      continue
    end
    
    Acc = classifyKNN_global(parameter,channels,0);
    %Acc = classifyKNN(eeg2, y2, c2, parameter,channels,0);
    eval(i) = sum(Acc)/10;
    fprintf('%2d - %1.5f  ',i,eval(i));
    
  end

  %disp(toc)
end

