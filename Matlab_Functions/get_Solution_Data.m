function solution = get_Solution_Data(polar_Path)
% polar_Path: str            is the Path to the *.txt file
% foil_Coord: table          returns table with Solution
%% Extracting Coordinated from Airfoil File

    %% Initialize
    Alpha   = [];
    CL      = [];
    CD      = [];
    CDp     = [];
    CM      = [];
    Top_Xtr = [];
    Bot_Xtr = [];
    
    %% Read File
    fileID = fopen(polar_Path); 
    try
        %% Loop over every Line in File
        while ~feof(fileID)                                 % While not end of file has been reached
            line = fgetl(fileID);                               % Read first line 

            if isempty(line)                                % if line is empty read new line and continue with loop
                line = fgetl(fileID);
                continue
            end

            data = textscan(line, "%f%f%f%f%f%f%f");                  % If line not empty check 
            if ~isempty(data{6}) * ~isempty(data{7}) == 1             % if 2 float numbers can be read
                Alpha(end+1,1)    = data{1}(1); 
                CL(end+1,1)       = data{2}(1);                         % if numbers can be read
                CD(end+1,1)       = data{3}(1);
                CDp(end+1,1)      = data{4}(1);
                CM(end+1,1)       = data{5}(1);
                Top_Xtr(end+1,1)  = data{6}(1);
                Bot_Xtr(end+1,1)  = data{7}(1);
            end
        end

        %% Close File and create Table
        fclose(fileID);
    end
    solution = table(Alpha, CL, CD, CDp, CM, Top_Xtr, Bot_Xtr);
end