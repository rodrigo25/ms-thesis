function [cluster_por_pessoa] = relacionaPessoaCocluster(biClustResult, y)
  % RELACIONA_PESSOA_COCLUSTER - Define qual cluster possui mais exemplos para cada pessoa  

  %Matrix de relação da quantidade de exemplos de cada pessoa por cluster
  qtd_expessoa_por_cluster = zeros(biClustResult.ClusterNo,102);

  %Contabiliza quantidade de exemplos de cada pessoa por cluster
  for i_clust = 1:biClustResult.ClusterNo 
    % Se o co-cluster não tiver nenhum canal retorna
    if length(biClustResult.Clust(i_clust).cols)<1 || length(biClustResult.Clust(i_clust).rows)<1, continue; end;

    ind_rows = biClustResult.Clust(i_clust).rows; % Define os exemplos selecionados pelo co-cluster

    %Indice das pessoas com ao menos em exemplo selecionado pelo cluster
    pessoas_i_cluster = unique(y(ind_rows));

    for i_pessoa = 1:length(pessoas_i_cluster) % itera por cada pessoa selecionada pelo cluster
      % Calcula a quantidade de exemplos da pessoa selecionado pelo cluster
      qtd_expessoa_por_cluster(i_clust,pessoas_i_cluster(i_pessoa)) = sum(y(ind_rows)==pessoas_i_cluster(i_pessoa));
    end
  end
  
  % Define cluster com mais exemplos de cada pessoa
  [~,cluster_por_pessoa] = max(qtd_expessoa_por_cluster);
  
  ind_clust = unique(cluster_por_pessoa);
  for i = 1:length(ind_clust)
    qtdPessoasCluster = length( find(cluster_por_pessoa == ind_clust(i)) );
    if qtdPessoasCluster == 1
      pessoa = find(cluster_por_pessoa==ind_clust(i));
      qtd_ex_pessoa = qtd_expessoa_por_cluster(:,pessoa);
      qtd_ex_pessoa(ind_clust(i)) = 0;
      controle = true;
      while controle
        [~, clust_seguinte ] = max(qtd_ex_pessoa);
        if length( find(cluster_por_pessoa == clust_seguinte) ) > 1
          controle = false;
          cluster_por_pessoa(pessoa) = clust_seguinte;
        else
          qtd_ex_pessoa(clust_seguinte) = 0;
        end
      end
    end
  end
  
end
