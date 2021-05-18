function write_input(obj, x_foil_input_name, polar_name, airfoil_path, Setup)

    %% full paths
    %[folder, ~]     = fileparts(mfilename("fullpath"));
    %folderParts     = split(folder, filesep);
    %parentFolder    = string(join(folderParts(1:end-1), filesep));
    %polar_name      = char(fullfile(parentFolder, polar_name));
    %airfoil_path    = char(fullfile(parentFolder, airfoil_path));
    
    %% Escape paths
    airfoil_path    = replace(airfoil_path, "\", "/");
    airfoil_path    = replace(airfoil_path, "%", "%%");
    polar_name      = replace(polar_name, "\", "/");
    polar_name      = replace(polar_name, "%", "%%");
     
                        
    %% Start of XFoil Input
    x_input_fid = fopen(['..\..\', x_foil_input_name], 'w');   % creat Xfoil inputfile  
    
    %% Plot options
    if ~Setup.Visible
         fprintf(x_input_fid, ["PLOP\rG\r\r"]);
    end
    
    %% Load Airfoil
    fprintf(x_input_fid, 'LOAD '+ airfoil_path);   % load airfoil from corrected Airfoils folder
    fprintf(x_input_fid, '\r');
    
    
    %% Refinement of Airfoil
    
    % improve angles between nodes
    fprintf(x_input_fid,  'GDES\r'); %geometry Design
    for i = 1:Setup.FilteringSteps
        fprintf(x_input_fid,  'CADD\r'); %improve corner angles
        fprintf(x_input_fid,   '\r'); %Corner Angle
        fprintf(x_input_fid,  '\r'); %type of spline parameter
        fprintf(x_input_fid,  '\r'); %refinement limits
    end
    
    fprintf(x_input_fid,  '\r'); %leave GDES
    fprintf(x_input_fid,  'PCOP\r'); %leave GDES
    
    
    
    
    % Change Number of Panels
    fprintf(x_input_fid, '\r\r\r\r');
    fprintf(x_input_fid,  'PPAR\r'); %Panel Parameters
    fprintf(x_input_fid,  'N\r');
    fprintf(x_input_fid,  [mat2str(Setup.Panels), '\r']);
    fprintf(x_input_fid,  '\r\r');
    fprintf(x_input_fid,  'PCOP\r'); %leave GDES
    
    
    % Filtering
    fprintf(x_input_fid,  'PANE\r'); 
    fprintf(x_input_fid,  'MDES\r'); 
    fprintf(x_input_fid,  ['FILT ', mat2str(Setup.Filter), '\r']); %leave GDES
    fprintf(x_input_fid,  ['FILT ', mat2str(Setup.Filter), '\r']); %leave GDES
    
    for i = 1:Setup.FilteringSteps
        fprintf(x_input_fid,  ['EXEC', '\r']); 
    end
  	fprintf(x_input_fid,  '\r'); 
    %fprintf(x_input_fid,  'PCOP\r'); %leave GDES
    fprintf(x_input_fid,  ['PANE\r']); %leave MDES
    
    
    
    %% Setup of Calculation
    fprintf(x_input_fid, 'OPER\r'); % open Calculation Interface
    
    fprintf(x_input_fid, ['RE ', mat2str(Setup.Re), '\r']); % Reynoldsnumber
    if Setup.Mach <= 0.3
       Setup.Mach = 0; 
    end
        
    fprintf(x_input_fid, ['MACH ', mat2str(Setup.Mach), '\r']); % Machnumber
    
    %% Solver Settings
    
    if Setup.Viscous_mode == 1 % Viscous Calculation
        fprintf(x_input_fid, 'VISC\r'); 
    end
    
    fprintf(x_input_fid, ['TYPE ', mat2str(Setup.Calculation_Type), '\r']); % Calculation Type
    fprintf(x_input_fid, ['ITER ', mat2str(Setup.Iteration_limit), '\r']); % Maximum Iterations
    
    %Boundary Layer settings
    
    if Setup.BL_Init == 1 % Boundary already initialized
        fprintf(x_input_fid, 'INIT\r');
    end
    
    if Setup.Vpar == 1 %changing boundary parameters
        fprintf(x_input_fid, 'VPAR\r');
        fprintf(x_input_fid, ['XTR ', mat2str(Setup.XTR_top), ' ', ...
                               mat2str(Setup.XTR_bottom) , '\r']); % Trip Points
        fprintf(x_input_fid, ['N ', mat2str(Setup.Ncrit), '\r']); % Ncrit, Amplification Exponent
        fprintf(x_input_fid, ['VACC ', mat2str(Setup.Vacc), '\r']); % Newton Accelerationparameter
        
        fprintf(x_input_fid, 'LAG\r'); % Lag Equation
        fprintf(x_input_fid, [mat2str(Setup.Klag), '\r']); % Shear Lag Constant
        fprintf(x_input_fid, [mat2str(Setup.Uxwt), '\r']); % Shear lag Weight
        
        fprintf(x_input_fid, 'GB\r'); % Gbeta
        fprintf(x_input_fid, [mat2str(Setup.G_b_A), '\r']); % constant A
        fprintf(x_input_fid, [mat2str(Setup.G_b_B), '\r']); % constant B
        
        
        fprintf(x_input_fid, 'CTR\r'); % Ctau Transition
        fprintf(x_input_fid, [mat2str(Setup.CtiniK), '\r']); % initial Ctau konst.
        fprintf(x_input_fid, [mat2str(Setup.CtiniX), '\r']); % initial Ctau exp.
        
        fprintf(x_input_fid, '\r'); %ending boundary editing
              
    end
    
    %% Initiate Saving
    fprintf(x_input_fid, 'PACC\r'); % Plot Accumilationfor savin in right format
    fprintf(x_input_fid, polar_name + '\r'); %save file name
    fprintf(x_input_fid, '\r');                 %no dump file name
    
    %% Start Calculation
    if Setup.AlphaSeq == 1
        if Setup.Alpha_min < 0    % Split up calculation from 0 to min and 0 to max for better conergence 
            fprintf(x_input_fid, ['ASEQ 0 ',mat2str(Setup.Alpha_max),...
                                    ' ', mat2str(Setup.Alpha_step), '\r']);       
            fprintf(x_input_fid, ['ASEQ 0 ',mat2str(Setup.Alpha_min),...
                                    ' ', mat2str(Setup.Alpha_step), '\r']);           
            
        else
            fprintf(x_input_fid, ['ASEQ ', mat2str(Setup.Alpha_min),' ',...
                                       mat2str(Setup.Alpha_max),' ',...
                                       mat2str(Setup.Alpha_step), '\r']);
        end
        
    else
        fprintf(x_input_fid, ['ALFA ', mat2str(Setup.Alpha), '\r']); % Alpha
    end
    
    %% Quit Xfoil    
    fprintf(x_input_fid, '\r\r\r\r\rQuit\r');  %so many \r needed to detect end in Calculation
    fclose(x_input_fid);

end

