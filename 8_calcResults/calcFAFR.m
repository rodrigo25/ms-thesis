function [ FAR, FRR, threshold, FAR_hist, FRR_hist ] = calcFAFR( y, y_val, Yreal, titulo_grafico)
  FAR = [];
  FRR = [];
  
  % Define intervalo de valores de teste 
  interval = unique(sort([0 ; y_val]));
  interval = (interval(2:end) + interval(1:end-1)) / 2;
  interval = [0 ; interval ; 1]';
  
  % Calcula o FAR e o FRR para cada valor no intervalo de testes
  for threshold=interval
    far = sum(y_val(y~=Yreal)>=threshold)/sum(y~=Yreal); % Calcula FAR
    frr = sum(y_val(y==Yreal)<threshold)/sum(y==Yreal);  % Calcula FRR
    %ARMAZENA FAR E FRR PARA MONTAR A CURVA
    FAR = [FAR; far];
    FRR = [FRR; frr];
  end

  % Cria o grafico de FAR e FRR
  im_FAFR = figure;
  hold on
  plot(interval,FAR,'b')
  plot(interval,FRR,'r')
  
  % Calcula melhor valor do threshold (onde o FAR e o FRR se cruzam)
  ind = find(FAR < FRR,1);
  threshold = (interval(ind-1)+interval(ind))/2;
  
  % Plota uma linha sobre o threshold
  x=threshold*ones(1,length(0:0.05:1));
  plot(x,0:0.05:1,'k--');
  
  % Plota CER
  plot(threshold,(FRR(ind-1)+FRR(ind))/2,'o','MarkerFaceColor','g')

  % Legendas do Gráfico
  legend('FAR','FRR','Limiar CER','CER')
  ylabel('Erro')
  xlabel('Limiar (Threshold)')
  if (nargin>3)
    title(['Gráfico de performance para ' titulo_grafico])
  end
  
  % Plot ROC Curve
  figure
  hold on
  plot(FAR,FRR,'b');
  plot([0 1],[0 1],'k');
  % Legendas do Gráfico
  xlabel('Taxa de Falsa Aceitação')
  ylabel('Taxa de Falsa Rejeição')
  if (nargin>3)
    title(['Curva ROC para ' titulo_grafico])
  end
  
  FAR_hist = FAR;
  FRR_hist = FRR;
  
  % Calcula os valores finais do FAR e FRR para o threshold final
  FAR = sum(y_val(y~=Yreal)>=threshold)/sum(y~=Yreal);
  FRR = sum(y_val(y==Yreal)<threshold)/sum(y==Yreal);

end

