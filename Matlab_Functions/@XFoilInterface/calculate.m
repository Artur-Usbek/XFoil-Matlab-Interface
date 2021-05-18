function calculate(obj)
    %% Calculate Airfoils with XFoil
    
    maximum_runtime = 300;
    
    %% Initialising
    [folder, ~] = fileparts(mfilename("fullpath"));
    cd(folder);
    
    [AirFoilTool_folder, ~] = fileparts(folder);

    %% Create Folders
    m_File_Path                 = fileparts(mfilename('fullpath'));
    Airfoils_folder             = [AirFoilTool_folder, '\..\Corrected_Airfoils'];
    results_folder              = [AirFoilTool_folder, '\..\Results'];
    errors_folder               = [AirFoilTool_folder, '\..\Errors'];
    mkdir(results_folder);
    mkdir(errors_folder);

    %% Get all airfoil files
    airfoils  = dir(fullfile(Airfoils_folder, '*.dat'));
    airfoils  = {airfoils.name}';
    airfoil_names = cell(size(airfoils));

    for i=1:length(airfoils)
        [~, foil_name, ~] = fileparts(airfoils{i});
        airfoil_names{i} = foil_name;
    end


    %%  Add necessary Information for XFoil calculation
    Setup.Airfoil = airfoil_names';
    %   Edit Re, Ma ... and further Options in the function below
    Setup = obj.create_Setup(Setup);

    %% Setup combinations
    Setup_table = create_combinationTable(Setup);
    Setup_table = sortrows(Setup_table, 'Alpha_max');
    Setup_table = Setup_table(randperm(height(Setup_table)), :);
    
    %% Starting Calculation for Airfoil
    for i = 1:height(Setup_table) 
        try
            format = 'Iterationnummer: %1.0f of %1.0f\n';
            fprintf(format, i, height(Setup_table));

            % Create necessary Paths
            Setup_line          = Setup_table(i,:);
            foil_name           = Setup_line.Airfoil{1,:};

            % Get File Names
            xfoil_input_file    = XFoilInterface.getInputFileName(foil_name, Setup_line.Re, Setup_line.Mach); 
            xfoil_polar_file    = XFoilInterface.getPolarFileName(foil_name, Setup_line.Re, Setup_line.Mach);
            xfoil_airfoil_file  = XFoilInterface.getAirfoilFileName(foil_name);
            xfoil_error_file    = XFoilInterface.getErrorFileName(foil_name, Setup_line.Re, Setup_line.Mach, errors_folder);
            xfoil_command       = XFoilInterface.getCommand(xfoil_input_file, xfoil_error_file);

            % Write XFoil Input
            obj.write_input(xfoil_input_file, xfoil_polar_file, xfoil_airfoil_file, Setup_line);

            % Start XFoil
            [process, outputReader] = XFoilInterface.startXFoil(xfoil_command);

            % Calculation Control
            error = obj.checkOutput(process, outputReader, xfoil_error_file);

            % Close XFoil
            XFoilInterface.closeXFoil(process, error, xfoil_error_file, maximum_runtime);
        end
    end

end

