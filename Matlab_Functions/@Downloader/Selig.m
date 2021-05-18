function Selig(save_path)
    if nargin == 0
       save_path = Downloader.getAirfoilSavePath();
    end
    Downloader.download('Selig', save_path);
end
