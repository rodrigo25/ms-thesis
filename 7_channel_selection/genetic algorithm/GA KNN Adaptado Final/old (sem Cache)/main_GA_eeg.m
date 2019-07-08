%load('D:/Documentos/Rodrigo/USP/Pós Graduação/Base de dados/Physionet - EEG Motor Movement & Imagery Dataset/5_datasets/AR/eeg_seg05_None_AR3_ChannelSelection')
addpath(genpath('../../../6_classification'))
%load('D:/Documentos/Rodrigo/USP/Pós Graduação/Base de dados/Physionet - EEG Motor Movement & Imagery Dataset/5_datasets/AR2/eeg_seg03_wind4800_None_AR7_ChannelSelection')

global eeg y c fpc cache;
fpc = size(eeg,2)/64;
load('../../eeg_seg05_AR_3_RealTask.mat');

cache = containers.Map('[ini]',-1);


%load('backup2.mat')
pop_size = 100;
num_bits = 68;
prob_crossover = .9;
prob_mutation = .1;
prob_inversion = .1;
perc_rouletteWheel = .5;
perc_tournament = .45;
perc_elite = .05;
fitness_func_name = 'fitness_eegKNN';
objective = 100;
it_max = 1000;

%[ans_cromossome, ans_eval] = GA(pop_size, num_bits, prob_mutation, fitness_func_name, it_max, objective);
%[ans_cromossome, ans_eval] = GAp(pop_size, num_bits, prob_mutation, fitness_func_name, it_max, objective);

[ans_cromossome, ans_eval] = GA_eeg(pop_size, num_bits, prob_crossover, prob_mutation, prob_inversion, perc_rouletteWheel, perc_tournament, perc_elite, fitness_func_name, it_max, objective);
%[ans_cromossome, ans_eval] = GA_eeg(pop_size, num_bits, prob_crossover, prob_mutation, prob_inversion, perc_rouletteWheel, perc_tournament, perc_elite, fitness_func_name, it_max, objective, it, population, eval);