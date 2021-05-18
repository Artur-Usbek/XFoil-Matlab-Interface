classdef Downloader
    
    properties (Constant, Hidden)
        %websites
        SELIG_WEBSITE   = "https://m-selig.ae.illinois.edu/ads/coord_seligFmt/";
        DELFT_WEBSITE   = "https://aerodynamics.lr.tudelft.nl/cgi-bin/afCDb";
        AFT_WEBSITE     = "http://airfoiltools.com/search/airfoils?m=a";
        
        %Airfoilbasepath
        SELIG_FOIL_PATH = "https://m-selig.ae.illinois.edu/ads/coord_seligFmt/#AIRFOIL#.dat";
        DELFT_FOIL_PATH = "https://aerodynamics.lr.tudelft.nl/cgi-bin/afCDb?#AIRFOIL#";
        AFT_FOIL_PATH   = "http://airfoiltools.com/airfoil/seligdatfile?airfoil=#AIRFOIL#";
    end
    
    methods (Static, Access = public)
        FullDownload(save_path);
        Delft(save_path);
        Selig(save_path);
        AirFoilTools(save_path);
    end
    
    methods (Static, Access = private)
        download(source, save_path);
        save_path       = getAirfoilSavePath();
        airfoil_Names   = getAirfoilNames(source);
        Coordinates     = getCoordinates(url, source);
    end
    
end