function [biClustResult2, models2, modeloFinal2, canaisUsados, cluster_por_pessoa2 ] = removeCoclustersVazios(biClustResult, models, modeloFinal, cluster_por_pessoa)
  biClustResult2 = biClustResult;
  models2=models;
  modeloFinal2=modeloFinal;
  canaisUsados = [];
  mantem = 1:biClustResult.ClusterNo;
  remove = [];
  
  for i_clust=1: 1:biClustResult.ClusterNo 
    pessoas = find(cluster_por_pessoa==i_clust);
    if length(biClustResult.Clust(i_clust).cols)<1 || length(biClustResult.Clust(i_clust).rows)<1 || length(pessoas)<1
      remove = [remove i_clust];
    else
      canaisUsados = [canaisUsados biClustResult.Clust(i_clust).cols];
    end
  end
  
  mantem(remove) = [];
  
  biClustResult2.RowxNum = biClustResult.RowxNum(:,mantem);
  biClustResult2.NumxCol = biClustResult2.NumxCol(mantem,:);
  biClustResult2.ClusterNo = biClustResult2.ClusterNo-size(remove,2);
  biClustResult2.Clust(remove)=[];
  models2(remove,:)=[];
  modeloFinal2(remove,:)=[];
  
  canaisUsados = unique(canaisUsados);
  
  aux = unique(cluster_por_pessoa);
  cluster_por_pessoa2 = zeros(size(cluster_por_pessoa));
  for i=1:length(aux)
    index = cluster_por_pessoa==aux(i);
    cluster_por_pessoa2(index) = i;
  end
  
end