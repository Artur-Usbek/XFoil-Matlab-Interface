function xfoil_polar_file = getPolarFileName(foil_name, Re, Ma)
        format              = '%s_Re_%i_Ma_%0.2f';
        fileSpecification   = sprintf(format, foil_name, Re, Ma);
        xfoil_polar_file  	= "Results\" + fileSpecification + '.pol';
end