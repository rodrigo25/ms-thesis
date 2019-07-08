function [ eval ] = fitness_eegKNN( population )
  
	global cache;
  n = size(population,1);
  eval = zeros(n,1);
  
  desconto = 0.0003;
  %desconto = 0.0002
  %desconto = 0.0001;
  %desconto = 0.00009  <-
  %desconto = 0.00008
  %desconto = 0.00007
  %desconto = 0.00006
  %desconto = 0.00005
  %desconto = 0
  
%  tic
  for i=1:n
    if rem(i-1,20) == 0
      fprintf('\n');
    end
    
		
		if cache.isKey(mat2str(population(i,:)))
			eval(i) = cache(mat2str(population(i,:)));
			fprintf('%2d - %1.5f. ',i,eval(i));
      continue
		end
    
    cromossomoChannels = population(i,1:64);
    cromossomoParameter = population(i,65:68);

    channels=find(cromossomoChannels);
    parameter = sum(fliplr(cromossomoParameter).*2.^(0:3))+1;
    if isempty(channels)
      eval(i) = 0;
      continue
    end
    
    nCh = length(channels);
    
    Acc = classifyKNN_global(parameter,channels,0);
    eval(i) = (sum(Acc)/10) - desconto*nCh;
    fprintf('%2d - %1.5f  ',i,eval(i));
    
		cache(mat2str(mat2str(population(i,:)))) = eval(i);
		
  end

  %disp(toc)
end

