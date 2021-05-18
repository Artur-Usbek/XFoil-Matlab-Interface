function airfoil_Names = getAirfoilNames(source)
    
    switch source
        
        case 'Delft'
            %Read the code from the Website and create an htmlTree object from it
                code = webread(Downloader.DELFT_WEBSITE);
                tree = htmlTree(code);

            %Find all "a" Elements and extract the href-Data to gain the Airfoil .dat file names
                selector        = "a";
                subtrees        = findElement(tree, selector);
                attribute       = "href";
                airfoil_Names   = getAttribute(subtrees(5:end), attribute); % not airfoil data from 1-4
                splitNames      = split(airfoil_Names, "?");
                airfoil_Names   = splitNames(:, 2);
                
        case 'Selig'    
            %Read the code from the Website and create an htmlTree object from it
                code = webread(Downloader.SELIG_WEBSITE);
                tree = htmlTree(code);

            %Find all "a" Elements and extract the href-Data to gain the Airfoil .dat file names
                selector        = "a";
                subtrees        = findElement(tree, selector);
                attribute       = "href";
                airfoil_Names   = getAttribute(subtrees, attribute); %not airfoil data from 1-5 
                airfoil_Names(~contains(airfoil_Names, ".dat")) = [];
                [~, airfoil_Names, ~] = arrayfun(@fileparts, airfoil_Names);
                
        case 'AFT'
            %Read the code from the Website and create an htmlTree object from it
                code = webread(Downloader.AFT_WEBSITE);
                tree = htmlTree(code);

            %Find all "a" Elements and extract the href-Data to gain the Airfoil .dat file names
                selector        = "a";
                subtrees        = findElement(tree, selector);
                attribute       = "href";
                airfoilLinks    = getAttribute(subtrees, attribute); % not airfoil data from 1-5 
                airfoilLinks(~contains(airfoilLinks, "airfoil=")) = [];
                splitNames      = split(airfoilLinks, "airfoil=");
                airfoil_Names   = splitNames(:, 2);
                
                
        otherwise
            warning("Unknown source: %s", source);
    
    end


end