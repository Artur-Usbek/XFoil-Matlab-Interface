function Solution = calculate()
    %% Calculate Airfoils with XFoil
    %% Initialising
    clc;
    clear;
    close all;
    %
    [folder, ~] = fileparts(mfilename("fullpath"));
    cd(folder);
    
    [AirFoilTool_folder, ~] = fileparts(folder);

    %% Create Folders
    m_File_Path                 = fileparts(mfilename('fullpath'));
    refined_Airfoils_folder     = [AirFoilTool_folder, '\Corrected_Airfoils'];
    results_folder              = [AirFoilTool_folder, '\Results'];
    errors_folder               = [AirFoilTool_folder, '\Errors'];
    mkdir(results_folder);
    mkdir(errors_folder);

    %% Get all airfoil files
    airfoils  = dir(fullfile(refined_Airfoils_folder, '*.dat'));
    airfoils  = {airfoils.name}';
    airfoil_names = cell(size(airfoils));

    for i=1:length(airfoils)
        [~, foil_name, ~] = fileparts(airfoils{i});
        airfoil_names{i} = foil_name;
    end


    %%  Add necessary Information for XFoil calculation
    Setup.Airfoil = airfoil_names';
    %   Edit Re, Ma ... and further Options in the function below
    Setup = create_XFoil_Setup(Setup);

    %% Setup combinations
    Setup_table = create_combinationTable(Setup);

    %% Create Solution Table
    column_names    = Setup_table.Properties.VariableNames;
    Solution        = array2table(zeros(0, length(column_names)));
    Solution.Properties.VariableNames = column_names;

    %% Additional helpful columns
    Solution.Errors     = NaN(0);
    Solution.Warnings   = NaN(0);
    Solution.Converged  = NaN(0);
    % Solutions
    Solution.CL         = NaN(0);
    Solution.CD         = NaN(0);
    Solution.CDp        = NaN(0);
    Solution.CM         = NaN(0);
    Solution.Top_Xtr    = NaN(0);
    Solution.Bot_Xtr    = NaN(0);

    %% Starting Calculation for Airfoil
    Setup_table = sortrows(Setup_table, 'Alpha_max');
    Setup_table = Setup_table(randperm(height(Setup_table)), :);
    parfor i = 1:height(Setup_table) 
        try
        format = 'Iterationnummer: %1.0f of %1.0f\n';
        fprintf(format, i, height(Setup_table));

        %% Create necessary Paths
        Setup_line          = Setup_table(i,:);
        foil_name           = Setup_line.Airfoil{1,:};
        Re                  = Setup_line.Re;
        Ma                  = Setup_line.Mach;
        format              = '%s_Re_%i_Ma_%0.2f';
        fileSpecification   = sprintf(format, foil_name, Re, Ma);
        xfoil_input_file    = ['xfoil_input_', fileSpecification,'.txt'];         % create Xfoil input name

        airfoil_path        = [refined_Airfoils_folder, '/', foil_name, '.dat'];
        polare_name         = ['Results/', fileSpecification, '.txt'];
        write_xfoil_input(xfoil_input_file, polare_name, airfoil_path, Setup_line);

        %% Create Process  
        proc                                    = System.Diagnostics.Process(); % Create Process 
        proc.StartInfo.FileName                 = 'cmd.exe'; % cmd.exe should be starte
        proc.StartInfo.WindowStyle              = System.Diagnostics.ProcessWindowStyle.Hidden;
        proc.StartInfo.CreateNoWindow           = true; % should no windows be opened?
        proc.StartInfo.UseShellExecute          = false; % for output/input Redirection = false
        proc.StartInfo.RedirectStandardInput    = true; % automatic Input
        %proc.StartInfo.RedirectStandardOutput   = true; % output should be save and not only printed in console
        %proc.StartInfo.RedirectStandardError    = true;
        proc.EnableRaisingEvents                = true;
        
        %% Create Output Reader for saving output
        error_file_name     = ['error_', fileSpecification,'.txt'];          %creat Results file name                             
        errors_file_path    = fullfile(errors_folder, error_file_name);     % create Resultspath 
        errors_fid          = fopen(errors_file_path, 'w+');                      % create file
        fclose(errors_fid); %close file
        pause(1)
        %outputReader        =  System.IO.StreamWriter(errors_file_path);       %give path for writing Output
        %outputReader.AutoFlush = true;
        outputReader = struct();
        
        %% run xfoil with these commands  
        proc.Start();   %start Process/cmd window
       % proc.BeginOutputReadLine(); 
        
        exeFile = fullfile(m_File_Path, "xfoil.exe");   %Create path to exe file
        cmd     = sprintf("cd .. & xfoil.exe < %s > %s & exit", xfoil_input_file, errors_file_path) % create command line
        proc.StandardInput.WriteLine(cmd);                  %input command into cmd-Console->Starting xfoil
        proc.StandardInput.Flush();
        proc.StandardInput.Close();

        %% Calculation Control
        error = checkOutput(proc, outputReader, errors_file_path);

        %% Output Process & Closing Objects
       % outputReader.Write(proc.StandardOutput.ReadToEnd);
        %outputReader.Close;
        proc.Close;    

        T_Max = 0;
        %% Kill Xfoil
        name = 'xfoil'; %for example
        processes = System.Diagnostics.Process.GetProcessesByName(name);
        for jProcess = 1:processes.Length
           Process = processes(jProcess);
           pid = Process.Id; %You must index into p (not p.Id), as this changes the class type
           duration = (Process.StartTime.Now - Process.StartTime);
           diffInSeconds = duration.TotalSeconds;
           if diffInSeconds > T_Max
               %
                [~, ~] = system(sprintf('taskkill /PID %i /F', pid));
                fprintf("Killed XFOIL: %.0f\n", pid);
           end
        end
%         %% Kill console
%         name = 'conhost'; %for example
%         processes = System.Diagnostics.Process.GetProcessesByName(name);
%         for jProcess = 1:processes.Length
%            Process = processes(jProcess);
%            pid = Process.Id; %You must index into p (not p.Id), as this changes the class type
%            duration = (Process.StartTime.Now - Process.StartTime);
%            diffInSeconds = duration.TotalSeconds;
%            if diffInSeconds > T_Max
%                %
%                 [~, ~] = system(sprintf('taskkill /PID %i /F', pid));
%                 fprintf("Killed : %.0f\n", pid);
%            end
%         end
        
        
        if error == 0
            delete(errors_file_path);
        end
        pause(1);
            %% Add Solution to Table and delete file
            polar_Path = fullfile(m_File_Path, '..' ,polare_name);
            solution_data = get_Solution_Data(polar_Path);
            %%not fully implemented yet
            solution_data.Errors = error * ones(length(solution_data.Alpha),1);
            solution_data.Warnings = zeros(length(solution_data.Alpha),1);
            %%
            if error == 0
                solution_data.Converged = ones(length(solution_data.Alpha),1);
            else
                solution_data.Converged = zeros(length(solution_data.Alpha),1);            
            end
            %% Check if all Alpha in Solution (not beautiful programmed)      
            alpha_all = return_calculated_alphas(Setup_line)';
            alpha_no_Solution = setdiff(alpha_all, solution_data.Alpha); %no solution avaiable for these alphas


            arr = table2array(solution_data);
            No_Solution = NaN(length(alpha_no_Solution),width(solution_data));
            No_Solution(:, 1)    = alpha_no_Solution;
            No_Solution(:, end) = zeros(length(alpha_no_Solution),1);
            z = [arr; No_Solution];        
            solution_data = array2table(z,'VariableNames', solution_data.Properties.VariableNames);

            airfoil_solution = Setup_line;       
            for ii=1:length(solution_data.Alpha)
                airfoil_solution(ii,:) = Setup_line;           
            end
            airfoil_solution = horzcat(airfoil_solution, solution_data(:,2:end));
            airfoil_solution.Alpha = solution_data.Alpha;

            Solution = [Solution;  airfoil_solution];

            %% delete Input file
            %delete(polar_Path);
            delete(fullfile(AirFoilTool_folder, xfoil_input_file)); 
        end
    end

    %% Save Solutions
    time_str            = datestr(now, "yyyy-mm-dd+HH-MM-SS");
    save_path = fullfile(results_folder,['Solution_', time_str, '.mat']);
    save(save_path, 'Solution')

end

