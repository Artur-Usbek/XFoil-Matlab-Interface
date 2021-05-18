function save_path = getAirfoilSavePath()
    %% Path for saving the data 
    m_File_Path = fileparts(mfilename('fullpath'));             %path of this Matlab File
    [~, ~]      = mkdir([m_File_Path, '\..\..\Airfoils']);    	%Create new Folder at Mainfolder
    save_path   = [m_File_Path, '\..\..\Airfoils\'];            %Path for saving the Airfoils
end