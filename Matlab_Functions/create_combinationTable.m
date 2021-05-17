function combination_table = create_combinationTable(var_par)
%Creates combination Table from given parameters.

    var_par_names = fieldnames(var_par).';
    
%% reshape all variation vectors, in a 1xn dimension
    for i_par = 1:numel(var_par_names)
        var_par.(var_par_names{i_par}) = reshape(var_par.(var_par_names{i_par}),1,[]);
    end


    for i_par = 1:numel(var_par_names)
        values = var_par.(var_par_names{i_par});
        
        if iscell(values)
            values = 1:numel(values); % can't combine text values
        end
        
        if i_par == 1
            combination_array = values; % first vector is the initial vector
        else
            combination_array = combvec(combination_array,values); % create combination of current array with new vector
        end
        
    end
    combination_array = combination_array.'; % transpose the array

    %% table creation
    combination_table = array2table(combination_array, 'VariableNames', var_par_names); % turn Array into table for better readability

    %% replace numbers with text, where applicable:
    for i_par = 1:numel(var_par_names)
        if iscell(var_par.(var_par_names{i_par}))
            cell_column = var_par.(var_par_names{i_par})(combination_table.(var_par_names{i_par}));
            combination_table.(var_par_names{i_par}) = reshape(cell_column,[numel(cell_column),1]); 
        end
    end
    %% sort by airfoil
   combination_table = sortrows(combination_table, "Airfoil");
end

