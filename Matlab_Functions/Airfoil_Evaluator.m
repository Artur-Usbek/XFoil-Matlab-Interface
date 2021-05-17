
clc;
clear all
warning('off','all')

%% Load data
load('Results\Solution_2020-04-09+10-17-59.mat')

%% Deselect not necessary data before
columns =   {'Airfoil', 'Re', 'Mach', 'Alpha', 'CL', 'CD', 'CDp', 'CM'};
columns_all     = Solution.Properties.VariableNames;
columns_delete  = setdiff(columns_all, columns);
Solution_filtered_columns      = removevars(Solution,columns_delete);

%% Filter Data
data = rmmissing(Solution_filtered_columns);
% Solution_filtered = Solution_filtered_NaN;
% filter = (Solution_filtered.Converged==1);
% Solution_filtered(~logical(filter),:) = [];


%% Evaluation parameters
data.Eff = data.CL ./ data.CD; %%prelocating for speed

%% Generate Interesting Valuation Data
% Valuation Criteria a
Evaluation.Airfoil      = {};                          %Add Airfoil Column as cell
Evaluation.Re           = [];
Evaluation.Mach         = [];

Evaluation.Eff_Max      = [];
Evaluation.CL_Max       = [];
Evaluation.alpha_Max    = [];

Evaluation = struct2table(Evaluation);

%% Grouping 
airfoilnames    = unique(data.Airfoil); % get all airfoilnames
Re_numbers      = unique(data.Re);        % get all Re number
Mach_numbers    = unique(data.Mach);    % get all Mach number

%% Iterate over groups
for i = 1:length(airfoilnames)
    for j= 1:length(Re_numbers)
        for k = 1:length(Mach_numbers)
            %% Here Adding Criteria is possible
            
            % gerate "filter" for selecting the right rows 
            filter = (string(data.Airfoil) == airfoilnames{i}) .* ...
                     (data.Re == Re_numbers(j)) .* ...
                     (data.Mach == Mach_numbers(k));
                 
                 
            if sum(filter)> 0     %if values are avaiable for this group
                filter = logical(filter);  %change to logical so assigning is possihle    
                
                %calculate Criteria Values 
                alpha_Max = max(data(filter,:).Alpha);
                CL_Max    = max(data(filter,:).CL);
                Eff_Max   = max(data(filter,:).Eff);
                
                %Assigning the values
                %Group
                Evaluation.Airfoil(end+1)   = airfoilnames(i);
                Evaluation.Re(end)          = Re_numbers(j);
                Evaluation.Mach(end)        = Mach_numbers(k);
                %Criteria
                Evaluation.CL_Max(end)      = CL_Max;
                Evaluation.alpha_Max(end)   = alpha_Max;
                Evaluation.Eff_Max(end)     = Eff_Max;
                %interesting
                
            end
        end
    end                        
end

%% Points Evaluation!
Alpha_Pts = (Evaluation.alpha_Max > 10)*100;
Eff_Pts = Evaluation.Eff_Max*2;
CL_Pts = Evaluation.CL_Max*100;

Evaluation.Points = Alpha_Pts + Eff_Pts + CL_Pts;
Evaluation = sortrows(Evaluation,'Points','descend');


%% Drop Columns not neccessary
columns =   {'Airfoil', 'Re', 'Mach', 'Eff_Max', ...
            'alpha_Max', 'CL_Max', 'Points'}; % necessary Points
columns_all     = Evaluation.Properties.VariableNames;
columns_delete  = setdiff(columns_all, columns);
Evaluation_filtered      = removevars(Evaluation,columns_delete);





