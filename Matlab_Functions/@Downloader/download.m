function download(source, save_path)

    %%checking if this source is avaiable
    sources = ["Delft", "Selig", "AFT"];
    if ~contains(sources, source)
       error("Unknown Source: %s", source); 
    end

    %%get Foilnames and length
    airfoil_Names   = Downloader.getAirfoilNames(source);
    airfoil_Number  = length(airfoil_Names); 

    %% Pre-Allocation
        SOURCE              = upper(source);
        SOURCE_FOIL_PATH    = Downloader.(SOURCE + "_FOIL_PATH");
    % generate Url of airfoil
        urls                = arrayfun(@(foil) replace(SOURCE_FOIL_PATH, "#AIRFOIL#", foil), airfoil_Names);           
    % gernerate file path for saving
        file_Names          = save_path + airfoil_Names + "_" + source + ".dat";    
    % write airfoilname into the firstline
        firstLines          = airfoil_Names + "_" + source + "\n";                  
    
    %% Loop over everyfoil
    for iAirfoil = 1:airfoil_Number
        % Console Start Information
            Downloader.log(source, airfoil_Names(iAirfoil), iAirfoil, ...
                            iAirfoil/airfoil_Number*100, "Started");
        
        %Get Coordinates
            Coordinates = Downloader.getCoordinates(urls(iAirfoil), source);

        %Save File
            fileID = fopen(file_Names(iAirfoil), 'w');
            fprintf(fileID, firstLines(iAirfoil));   
            fprintf(fileID, Coordinates);        
            fclose(fileID);
        
        %if not paused, to many connections to website and error will be thrown (DDOS)
            pause(1);
        
        % Console Finish Information
            Downloader.log(source, airfoil_Names(iAirfoil), iAirfoil, ...
                            iAirfoil/airfoil_Number*100, "Finished");
    end

end