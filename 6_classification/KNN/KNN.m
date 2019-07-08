 function [result, result_similarity] = KNN(DATAX, DATAY, SAMPLES, k, threshold)
  
  qtdSample = size(SAMPLES,1);
  result = zeros(qtdSample,1);
  result_similarity = zeros(qtdSample,1);
  
  for i=1:qtdSample
    sample = SAMPLES(i,:);
    
    D = dist(DATAX,sample');
    [ values, sortInd ] = sort( D );
    %kNeighborsIndex = sortInd(2:k+1,:)

    kNeighborsIndex = sortInd(1:k);
    mode(DATAY(kNeighborsIndex));
    result(i) = mode(DATAY(kNeighborsIndex));
    
    
    aux = 1-(D/max(D));
    result_similarity(i) = aux(kNeighborsIndex);
    
    %[ valNormalizado, ~, ~, min_val, max_val ] = normalization( D, 'minmax' );
    %result_FAFR(i) = abs(valNormalizado(kNeighborsIndex));
  end
  
  if exist('threshold','var')
    result(result_similarity < threshold) = -1;
  end
  
  
  return
  
  qtdSample = size(SAMPLES,1);
  result = zeros(qtdSample,1);
  
  for i=1:qtdSample
    sample = SAMPLES(i,:);
    
    D = distance(sample, DATAX, 'e');

    [ ~, sortInd ] = sort( D );

    kNeighborsIndex = sortInd(2:k+1);

    if strcmp(type,'classification')
      result(i) = mode(DATAY(kNeighborsIndex));
    else %regression
      result(i) = sum(DATAY(kNeighborsIndex))/k;
    end
  end
end

% FUNÇÃO DE DISTÂNCIAS
% calcula a distancia do ponto p aos pontos em POINTS
% de acordo com uma distancia (dist) euclidiana ('e') ou manhattan ('m')
function D = distance(p, POINTS, fDist)
  [n,~] = size(POINTS);
  P = repmat(p,n,1);
  if strcmp(fDist,'e') %distancia euclidiana
    D = sqrt(sum((P-POINTS).^2, 2));
  elseif strcmp(fDist,'m') %distancia manhattan
    D = sum(abs(P-POINTS), 2);
  end
end