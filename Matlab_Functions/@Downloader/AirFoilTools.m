function AirFoilTools(save_path)
    if nargin == 0
       save_path = Downloader.getAirfoilSavePath();
    end
    Downloader.download('AFT', save_path);
end
