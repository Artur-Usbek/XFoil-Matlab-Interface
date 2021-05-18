function download(source, save_path)

    %checking if this source is avaiable
    sources = ["Delft", "Selig", "AFT"];
    if ~contains(sources, source)
       error("Unknown Source: %s", source); 
    end

    %get Foilnames and length
    airfoil_Names   = Downloader.getAirfoilNames(source);
    airfoil_Number  = length(airfoil_Names); 

    %Pre-Allocation
    SOURCE              = upper(source);
    SOURCE_FOIL_PATH    = Downloader.(SOURCE + "_FOIL_PATH");
    urls                = arrayfun(@(foil) replace(SOURCE_FOIL_PATH, "#AIRFOIL#", foil), airfoil_Names);            % generate Url of airfoil
    file_Names          = save_path + airfoil_Names + "_" + source + ".dat";    % gernerate file path for saving
    firstLines          = airfoil_Names + "_" + source + "\n";                  % write airfoilname into the firstline
    
    % Loop over everyfoil
    for iAirfoil = 1:airfoil_Number
        % Console Information
        fprintf('>>> Downloading-%s:\t %i of %i Files\n', source, iAirfoil, airfoil_Number);
        
        %Get Coordinates
        Coordinates = Downloader.getCoordinates(urls(iAirfoil), source);

        %Save File
        fileID = fopen(file_Names(iAirfoil), 'w');
        fprintf(fileID, firstLines(iAirfoil));   
        fprintf(fileID, Coordinates);        
        fclose(fileID);
        
        %PrintOutput
        fprintf('    Downloaded-%s:\t\t %s\n', source, airfoil_Names(iAirfoil));

        %if not paused, to many connections to website and error will be thrown (DDOS)
        %tried smaller values too, but doesnt work.
        pause(1);
    end

end