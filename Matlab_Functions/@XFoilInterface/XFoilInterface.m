classdef XFoilInterface
    properties (Access = public)
        Re
        Ma
        Airfoils
    end
    
    methods (Access = public)
        calculate(obj);
    end
    
    methods (Access = private)
        error = checkOutput(obj, proc, outputReader, error_file);
        write_input(obj, x_foil_input_name, polar_name, airfoil_path, Setup);
        variable = create_Setup(obj, variable);
    end
    
    
    methods (Static)
        kill(maximum_runtime);
        
        xfoil_input_file = getInputFileName(foil_name, Re, Ma);
        xfoil_polar_file = getPolarFileName(foil_name, Re, Ma);
        xfoil_airfoil_file = getAirfoilFileName(foil_name);
        xfoil_error_file = getErrorFileName(foil_name, Re, Ma, errors_folder);
        xfoil_command = getCommand(xfoil_input_file, xfoil_error_file);
        
        [process, outputReader] = startXFoil(xfoil_command);
        closeXFoil(process, error, xfoil_error_file, maximum_runtime);
    end
    
    
end