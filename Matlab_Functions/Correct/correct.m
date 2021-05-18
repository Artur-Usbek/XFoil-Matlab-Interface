
function correct()
	%% Correction of airfoil files

	%% Initialising
	clc;
	clear;
	close all;

	%% Create Folders
	m_File_Path                 = fileparts(mfilename('fullpath'));
	airfoils_Folder             = [m_File_Path, '\..\..\Airfoils'];
	corrected_Airfoils_folder   = [m_File_Path, '\..\..\Corrected_Airfoils'];
	[~, ~] = mkdir(corrected_Airfoils_folder);

	%% Get all airfoil files
	airfoils  = dir(fullfile(airfoils_Folder, '*.dat'));
	airfoils  = {airfoils.name}';

	parfor i = 1:length(airfoils)
		%% Read Airfoil Data
		foil       = airfoils{i};
		foil_Path  = fullfile(airfoils_Folder, foil);
		foil_Coord = get_Coordinates(foil_Path);
		
		%% Filtering
	%    foil_Coord = unique(foil_Coord, 'stable');          % use only unique points without sorting    
		if height(foil_Coord(foil_Coord.X > 1,:)) < 3       % sometimes falsly airfoil names can be found in Coordinates
			foil_Coord = foil_Coord(foil_Coord.X <= 1,:);  % Deleting entries with names of airfoils     
		end
		
		%% Normalizing
		X_Max = max(foil_Coord.X);              % normalizing with maximum length
		foil_Coord.X = foil_Coord.X ./ X_Max;
		foil_Coord.Y = foil_Coord.Y ./ X_Max;
		
		%% Check if Data in Lednicer format
		Diff = foil_Coord.X(1:end-1) - foil_Coord.X(2:end); %Calculate Distance of points
		Dist = sign(Diff).* Diff;
		[maxDist, max_idx] = max(Dist);
		if max(Dist > 0.5)      % if data is 
			
			if foil_Coord.X(max_idx)>foil_Coord.X(max_idx+1)
				foil_upper = foil_Coord(1:max_idx,:);
				foil_lower = foil_Coord(max_idx+1:end,:);
			else
				foil_lower = foil_Coord(1:max_idx,:);
				foil_upper = foil_Coord(max_idx+1:end,:);
			end
			
			foil_upper = sortrows(foil_upper, "X", "descend")
			foil_lower = sortrows(foil_lower, "X")
			foil_Coord = [foil_upper; foil_lower]; 
		end
		
		%% Write data
		corrected_name      = strrep(foil(1:end-4),"-","_") + foil(end-3:end)
		corrected_foil      = fullfile(corrected_Airfoils_folder, corrected_name);
		fileID              = fopen(corrected_foil, 'w');
		formatSpec          = "%7.6f %7.6f\r\n";
		[~, foil_name, ~]   = fileparts(corrected_foil);
		fprintf(fileID, "%s\r\n", foil_name);
		fprintf(fileID, formatSpec, table2array(foil_Coord)');
		fclose(fileID);
		
	end
end