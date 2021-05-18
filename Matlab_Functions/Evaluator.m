classdef Evaluator
    
    methods (Static)
        
       	function Solution = adjust(Solution)
            Solution = rmmissing(Solution);
            %Solution = unique(Solution);
            Solution.Airfoil = string(Solution.Airfoil);
            Solution.Alpha = Solution.alpha;
            interestingsVars = {'Airfoil', 'Re', 'Alpha', 'CL', 'CD', ...
                                'CDp', 'CM', 'Top_Xtr', 'Bot_Xtr'};
            Solution = Solution(:, interestingsVars);
            Solution.CLCD = Solution.CL ./ Solution.CD;
        end
        
        function Solution = getFullResults(folder)
            dir_data = dir(folder);
            result_files = fullfile(folder, {dir_data.name}');
            result_files(~contains(result_files, ".pol")) = [];

            startRow = 13;
            formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';

            %% Close the text file.
            Solution = [];
            fclose('all');
            parfor iFile = 1:length(result_files)
                filePath = result_files{iFile};
                fileID = fopen(filePath,'r');
                dataArray = textscan(fileID, formatSpec, 'Delimiter', '', ...
                                    'WhiteSpace', '', 'TextType', 'string', ...
                                    'HeaderLines' ,startRow-1, 'ReturnOnError', ...
                                    false, 'EndOfLine', '\r\n');
                fclose(fileID);
                airfoilTable = table(dataArray{1:end-1}, 'VariableNames', {'alpha','CL','CD','CDp','CM','Top_Xtr','Bot_Xtr'});
                Re = split(filePath, '_');
                Re = str2num(Re{end-2});
                Re = 1000*round(Re./1000);
                airfoilTable.Re = ones(height(airfoilTable),1) * Re;
                airfoil = getAirfoil(filePath);
                airfoilTable.Airfoil = repelem(airfoil, height(airfoilTable))';
                Solution = [Solution; airfoilTable];
            end

        end
        
        function Result = getCLCDatGivenCL(Solution, CL, Re)
            if nargin ==2
               Re = Solution.Re;
            end
            
            combination_table = create_combinationTable(var)
            
            Re_unique   = unique(Re);
            airfoils    = unique(Solution.Airfoil);
            
            combination_table = create_combinationTable(var)
            
            for iRe = 1:length(Re_unique)
                Re_current = Re_unique(iRe);
                Solution_Re = Solution(Solution.Re == Re_current, :);
                
                for iAirfoil = 1:length(airfoils)
                    airfoil_current = airfoils(iAirfoil);
                    Solution_Re_airfoil =  Solution_Re(Solution_Re.Airfoil == airfoil_current, :);
                    if ~isempty(Solution_Re_airfoil)
                        CL_Max(iAirfoil) = max(Solution_Re_airfoil.CL);
                    end
                    
                    
                end
            end
            
            
        end
    end
    
end