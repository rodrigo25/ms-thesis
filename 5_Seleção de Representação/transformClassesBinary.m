function [y_binary] = transformClassesBinary(y )

  classes = unique(y);    % Valor representante de cada classe
  qtdClasses = size(classes,1); % Quantidade total de classes no dataset
  [n] = size(y,1);        % Quantidade de amostras
  
  y_binary = zeros(n,qtdClasses);   
  
  for i=1:qtdClasses
    y_binary(y==classes(i),i) = 1;
  end
  
end

