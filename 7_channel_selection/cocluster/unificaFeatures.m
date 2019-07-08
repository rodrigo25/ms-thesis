function [ eegTrain ] = unificaFeatures( X, type )
%UNIFICAFEATURES Summary of this function goes here
%   Detailed explanation goes here

  [exemples, feat_total] = size(X);
  feats_per_channel = feat_total/64;

  eegTrain = zeros(exemples,64);

  if strcmp(type,'mean')
    for i=1:64
      eegTrain(:,i) = mean( X(:,(i-1)*feats_per_channel+1:(i-1)*feats_per_channel+feats_per_channel) , 2);
    end
  elseif strcmp(type,'median')
    for i=1:64
      eegTrain(:,i) = median( X(:,(i-1)*feats_per_channel+1:(i-1)*feats_per_channel+feats_per_channel) , 2);
    end
  end

end

