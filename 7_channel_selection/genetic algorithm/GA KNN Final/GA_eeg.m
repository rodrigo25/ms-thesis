% FUNCTION: Genetic Algorithm
%
% PARAMETERS: pop_size          - Population Size
%             num_bits          - Bit quantity on the cromossomes
%             prob_crossover    - Probability of crossover
%             prob_mutation     - Probability of mutation
%             prob_inversion    - Probability of inversion
%             perc_rouletteWheel- Percentual of data selected by Roulette Wheel
%             perc_tournament   - Percentual of data selected by Tournament
%             perc_elite        - Percentual of data selected by Elite
%             fitness_func_name - Name of the fitness function
%             it_max            - Maximum number of iterations
%             objective         - Objective value of evaluation function (optional)

%function [ans_cromossome, ans_eval] = GA_elitist(pop_size, num_bits, prob_mutation, fitness_func_name, it_max, objective)
function [ans_cromossome, ans_eval] = GA_eeg(pop_size, num_bits, prob_crossover, prob_mutation, prob_inversion, ...
                                                 perc_rouletteWheel, perc_tournament, perc_elite, fitness_func_name, it_max, objective, ...
                                                 it, population, eval)

  if perc_tournament + perc_rouletteWheel + perc_elite ~= 1
    error('Porcentagem total da seleção deve ser igual a 1');
  end

  if ~exist('objective','var')
    objective = inf;
  end; % initiating optional argument (if missing)

  % INITIAL POPULATION
  if ~exist('population','var')
    population = rand(pop_size, num_bits)>.5;
  end
  new_population = zeros(pop_size, num_bits);

  % EVALUATE FITNESS OF INITIAL POPULATION
  if ~exist('eval','var')
    fprintf('\nAvaliando População Inicial\n')
    eval = feval(fitness_func_name,population);
  end
  
  % INITIATE VARIABLES
  %keep_size = round(pop_size*0.1); % Size of the 10% elit cromossomes
  if ~exist('it','var')
    it = 0;
  end
  
  tournament_size = floor(pop_size*perc_tournament);
  rouletteWheel_size = floor(pop_size*perc_rouletteWheel);
  elite_size = floor(pop_size*perc_elite);
  if tournament_size + rouletteWheel_size + elite_size < pop_size
    remnent = pop_size - (tournament_size+rouletteWheel_size+elite_size);
    tournament_size = tournament_size + floor(remnent/2);
    rouletteWheel_size = rouletteWheel_size + ceil(remnent/2);
  end

  while max(eval)<objective && it<it_max % EPOCS ITERATIONS UNTIL FITNESS OBJECTIVE OR MAX ITERATIONS
    it = it+1; % increment iterator
    fprintf('\n\n------------------------ Iteração #%d ------------------------\n\n', it)
    
%%%%%SELECTION
    %Elite
    [~,sorted_index] = sort(eval,'descend');
    elite_values_index = sorted_index(1:elite_size);
    new_population(1:elite_size,:) = population(elite_values_index,:);
    
    %Tournament
    pool = randi(pop_size,25,tournament_size);
    [~, indBestPool] = max(eval(pool));
    iniTournament = elite_size;
    for i=1:tournament_size
      new_population(iniTournament+i,:) = population(pool(indBestPool(i),i),:);
    end
    
    %Roulette Wheel
    prob_selection = eval/sum(eval); % selection probability based on fitness evaluation
    cum_prob_selection = cumsum(prob_selection); % cumulative selection probability
    iniRW = elite_size + tournament_size;
    for i=1:rouletteWheel_size
      ind_c1 = 1 + sum( rand() > cum_prob_selection ); % Select index of new cromossome i
      new_population(iniRW+i,:) = population(ind_c1,:);
    end
    
%%%%OPERATIONS
    candidates_size = pop_size-elite_size;
    rand_candidates = randperm(candidates_size)+elite_size;
    for i=1:2:candidates_size
      if (i~=candidates_size) % IF Not the last element (Create 2 new cromossomes i and i+1)
        c1 = new_population(rand_candidates(i),:);
        c2 = new_population(rand_candidates(i+1),:);
        
        % CROSSOVER
        if rand<prob_crossover
          split_position_aux = randi([1 num_bits-1],2,1);
          while split_position_aux(1) == split_position_aux(2)
            split_position_aux(2) = randi([1 num_bits-1]); % Select split position
          end
          split_position1 = min(split_position_aux);
          split_position2 = max(split_position_aux);
          
          %cromossomo1 = [ population(ind_c1,1:split_position) population(ind_c2,split_position+1:end) ];
          %cromossomo2 = [ population(ind_c2,1:split_position) population(ind_c1,split_position+1:end) ];
          cromossomo1 = [c1(1:split_position1) c2(split_position1+1:split_position2) c1(split_position2+1:end)];
          cromossomo2 = [c2(1:split_position1) c1(split_position1+1:split_position2) c2(split_position2+1:end)];
        else
          cromossomo1 = c1;
          cromossomo2 = c2;
        end
        
        % MUTATION
        mutation = rand(1,num_bits)<prob_mutation; % select bits to mutation at random by prob_mutation
        cromossomo1(mutation) = ~cromossomo1(mutation); % apply mutation to cromossome i

        mutation = rand(1,num_bits)<prob_mutation;
        cromossomo2(mutation) = ~cromossomo2(mutation); % apply mutation to cromossome i+1
        
        
        % INVERSION
        if rand<prob_inversion
          ind_inversion = randi(num_bits,2,1);
          cromossomo1(ind_inversion(1):ind_inversion(2)) = fliplr(cromossomo1(ind_inversion(1):ind_inversion(2)));
        end

        if rand<prob_inversion
          ind_inversion = randi(num_bits,2,1);
          cromossomo2(ind_inversion(1):ind_inversion(2)) = fliplr(cromossomo2(ind_inversion(1):ind_inversion(2)));
        end
        
        
        % ATUALIZA POPULACAO
        new_population(rand_candidates(i),:) = cromossomo1;
        new_population(rand_candidates(i+1),:) = cromossomo2;
      
      else % Last element (Create only 1 new cromossomes i, without crossover)
        cromossomo = new_population(rand_candidates(i),:);
        
        if rand<prob_mutation  
          ind_mutation = randi(num_bits);
          cromossomo(ind_mutation) = ~cromossomo(ind_mutation); % apply mutation to cromossome i
        end
        
        if rand<prob_inversion
          ind_inversion = randi(num_bits,2,1);
          cromossomo(ind_inversion(1):ind_inversion(2)) = fliplr(cromossomo(ind_inversion(1):ind_inversion(2)));
        end

        % ATUALIZA POPULACAO
        new_population(rand_candidates(i),:) = cromossomo;
      end
    end

    % EVALUATE FITNESS OF NEW POPULATION
    eval = feval(fitness_func_name,new_population,population,eval);
    population = new_population;
    tic
    fprintf('\nMelhor Resultado it #%d - %f\n',it, max(eval))
    if rem(it,2)==1, fileBackup = 'backup1';
    else fileBackup = 'backup2'; end
    save(fileBackup, 'pop_size', 'num_bits', 'prob_crossover', 'prob_mutation', 'prob_inversion', 'perc_rouletteWheel', ...
                     'perc_tournament', 'perc_elite', 'fitness_func_name', 'it_max', 'objective', 'it', 'population', 'eval');
    
    if rem(it,20)==0
      fileBackup2 = ['backup' num2str(it)];
      save(fileBackup2, 'pop_size', 'num_bits', 'prob_crossover', 'prob_mutation', 'prob_inversion', 'perc_rouletteWheel', ...
                     'perc_tournament', 'perc_elite', 'fitness_func_name', 'it_max', 'objective', 'it', 'population', 'eval');
    end
    %timeSaving = toc
    %save resultadoParcial1 pop_size num_bits prob_crossover prob_mutation prob_inversion perc_rouletteWheel perc_tournament ...
    %      perc_elite fitness_func_name it_max objective it population eval;
    
  end

  [ans_eval,i] = max(eval);
  ans_cromossome = population(i,:);
end