function [foil_Coord] = get_Coordinates(foil_Path)
% foil_Path: str            is the Path to the *.dat file
% foil_Coord: table         returns table with X and Y coordinates
%% Extracting Coordinated from Airfoil File

    %% Initialize
    X = [];
    Y = [];
    
    %% Read File
    fileID = fopen(foil_Path); 
    
    %% Loop over every Line in File
    while ~feof(fileID)                                 % While not end of file has been reached
        line = fgetl(fileID);                           % Read line  
        if isempty(line)                                % if line is empty read new line and continue with loop
            line = fgetl(fileID);
            continue
        end
        
        data = textscan(line, "%f%f");                  % If line not empty check 
        if ~isempty(data{1}) * ~isempty(data{2}) == 1   % if 2 float numbers can be read
            X(end+1) = data{1}(1);                      % if numbers can be read
            Y(end+1) = data{2}(1);                      % Saving in X and Y
        end
    end
    
    %% Close File and create Table
    fclose(fileID);
    foil_Coord = table(X',Y');
    foil_Coord.Properties.VariableNames = {'X', 'Y'};
end