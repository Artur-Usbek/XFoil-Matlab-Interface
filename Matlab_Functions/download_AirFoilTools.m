




function download_AirFoilTools()
    %% Download all airfoils from Homepage
    % angelehnt an JoshTheEngineer Python Code
    % http://www.joshtheengineer.com/2019/01/30/uiuc-airfoil-database-file-download/
    % Zugriff: 03.04.2020

    %% Path for saving the data 
    m_File_Path = fileparts(mfilename('fullpath'));    %path of this Matlab File
    mkdir([m_File_Path, '\..\Airfoils']);                    %Create new Folder at .Mfile Directory
    save_path = [m_File_Path, '\..\Airfoils\'];              %Path for saving the Airfoils

    %% Airfoil Database Website
    foil_base_url = "http://airfoiltools.com/search/airfoils?m=a";

    %% Read the code from the Website and create an htmlTree object from it
    code = webread(foil_base_url);
    tree = htmlTree(code);

    %% Find all "a" Elements and extract the href-Data to gain the Airfoil .dat file names
    selector        = "a";
    subtrees        = findElement(tree, selector);
    attribute       = "href";
    airfoilLinks   = getAttribute(subtrees, attribute); % not airfoil data from 1-5 
    airfoilLinks(~contains(airfoilLinks, "airfoil=")) = [];
  
    splitNames = split(airfoilLinks, "airfoil=");
    airfoil_Names = splitNames(:, 2);
    foil_base_url = "http://airfoiltools.com/airfoil/seligdatfile?airfoil=";
    
    %% Download the files
    airfoil_Number = length(airfoil_Names);
    for i = 1:airfoil_Number
        % Console Information
        fprintf('>>> Downloading-AFT:\t %i of %i Files\n', i, airfoil_Number);
        name        = airfoil_Names(i);       	% get name of airfoil
        url         = foil_base_url + name;     % generate Url of airfoil
        filename    = save_path + name + "_AFT.dat";      	% gernerate file path for saving
        
        
        code        = webread(url);
        tree        = htmlTree(code);
        text        = tree.string;
        text = extractBetween(text, "<BODY>", "</BODY>");
        
        fileID = fopen(filename,'w');
        fprintf(fileID, text);
        fclose(fileID);
        
        fprintf('    Downloaded-AFT:\t\t %s\n', name);
        %if not paused, to many connections to website and error will be thrown
        %tried smaller values too, but doesnt work,
        pause(1);
    end
end
