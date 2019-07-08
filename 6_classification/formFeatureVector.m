% formFeatureVector - Separa os vetores 
%
function [ X ] = formFeatureVector( eeg, channels )
  fpc = size(eeg,2)/64;

  [~, totalFeatures] = size(eeg); % Quantidade total de exemplos e de features
  aux = 1:totalFeatures; 
  feat_per_channel = fix((aux-1)/fpc)+1; % Define o canal que cada feature pertence
  indFeatSelectedCh = ismember(feat_per_channel,channels); % Indice das features dos canais selecionados
  
  X = eeg(:,indFeatSelectedCh);
end
