descontos = [0.01 0.009 0.007 0.003 0.001 0.0003 0.0001 0.00009 0.00007 0.0];

for d=descontos

  file_name = ['GAadaptadoKNN_' num2str(d,'%.5f') '.mat'];
  load(file_name);
  
  [a,i] = max(eval);
  cromossomoChannels = population(i,1:64);
  cromossomoParameter = population(i,65:68);
  channels=find(cromossomoChannels);
  parameter = sum(fliplr(cromossomoParameter).*2.^(0:3))+1;
  fprintf('\n GA KNN %f - %d', d, length(channels));
  fprintf(['\nCanais ( ' sprintf('%d ',channels) ') - K=%d - eval=%f\n'], parameter,a);
end