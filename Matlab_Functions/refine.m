
function refine()
	%% Refinement
	% Refines the the airfoils, by increasing Panel number/Points to 160
	% Can be still improved by changing the refinement in Xfoil in
	% 'Generate Xfoil Input' Section


	%% Initialising
	clc;
	clear;
	close all;

	%% Variables!!!
	panels  =   200; 

	%% Create Folders
	m_File_Path                 = fileparts(mfilename('fullpath'));
	corrected_Airfoils_folder   = [m_File_Path, '\..\Corrected_Airfoils'];
	refined_Airfoils_folder     = [m_File_Path, '\..\Refined_Airfoils'];
	mkdir(refined_Airfoils_folder);

	%% Get all airfoil files
	airfoils  = dir(fullfile(corrected_Airfoils_folder, '*.dat'));
	airfoils  = {airfoils.name}';

	%% Starting Refinement
	parfor i = 1:length(airfoils)  
		%% Get Foil Name
		foil  = airfoils{i};
		fprintf('Refining Foil: %s\n', foil);

		%% Generate XFoil input
		[~, foil_name, ~] = fileparts(foil);                            % get foilname
		xfoil_input_file = ['xfoil_input_', foil_name ,'.txt'];         % create Xfoil input name
		x_input_fid = fopen(xfoil_input_file, 'w');                     % creat Xfoil inputfile
		
		%Input text same as doing Xfoil manually
		fprintf(x_input_fid,['load Corrected_Airfoils/', foil, '\n']);   % load airfoil from corrected Airfoils folder
		 % improve angles between nodes
        fprintf(x_input_fid,  'GDES\r'); %geometry Design
        for i = 1:5
            fprintf(x_input_fid,  'CADD\r'); %improve corner angles
            fprintf(x_input_fid,   '\r'); %Corner Angle
            fprintf(x_input_fid,  '\r'); %type of spline parameter
            fprintf(x_input_fid,  '\r'); %refinement limits
        end

        fprintf(x_input_fid,  '\r'); %leave GDES
        fprintf(x_input_fid,  'PCOP\r'); %leave GDES
    
        
        fprintf(x_input_fid, 'ppar\n');                                  % open change Paneling
		fprintf(x_input_fid, ['N ', int2str(panels), '\n\n\n']);         % Setting Panelnumber N to panels
		fprintf(x_input_fid, ['Save Refined_Airfoils/', foil, '\n']);    % Save Airfoil
		fprintf(x_input_fid, 'Quit\n');                                  % Quit XFoil
		
		fclose(x_input_fid);                                             % close file after input has been written
		
		%% Run Xfoil 
		cmd = sprintf('xfoil.exe < %s', xfoil_input_file);               % Create command Input line
		[~, ~] = system(cmd);                                            % start calculation process/ output = [status, results]
		
		%% delete Input file
		delete(xfoil_input_file);                                        % Delete Input file
	end

	disp("***********************************************************")
	disp("FINISHED")
	disp("***********************************************************")
end









