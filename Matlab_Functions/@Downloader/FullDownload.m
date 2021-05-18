function FullDownload(save_path)
    %check
    if nargin == 0
        save_path = Downloader.getAirfoilSavePath();
    end
    
    %because of the pause of 1 sec it is most efficient to download from all servers in parallel
    parpool(3);
    parfor core = 1:3
        if core == 1
            %Download Selig Database
            Downloader.Selig(save_path); 
            
        elseif core == 2
            %Download Delft Database
            Downloader.Delft(save_path);
            
        elseif core == 3
            %Download Database from AirfoilTools
            Downloader.AirFoilTools(save_path);
        end
    end
    
end