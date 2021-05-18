function xfoil_input_file = getInputFileName(foil_name, Re, Ma)
        format              = '%s_Re_%i_Ma_%0.2f';
        fileSpecification   = sprintf(format, foil_name, Re, Ma);
        xfoil_input_file    = ['xfoil_input_', fileSpecification,'.inp']; 
end