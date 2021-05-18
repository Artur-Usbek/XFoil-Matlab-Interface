function   xfoil_error_file = getErrorFileName(foil_name, Re, Ma, errors_folder)
    format              = '%s_Re_%i_Ma_%0.2f';
 	fileSpecification   = sprintf(format, foil_name, Re, Ma);
    error_file_name     = ['error_', fileSpecification,'.txt'];       	%creat Results file name                             
    xfoil_error_file    = fullfile(errors_folder, error_file_name);     % create Resultspath 
    errors_fid          = fopen(xfoil_error_file, 'w+');                % create file
    fclose(errors_fid); %close file
end