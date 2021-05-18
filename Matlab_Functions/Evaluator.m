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


            %% Close the text file.
            Solution = [];
            fclose('all');
            parfor iFile = 1:length(result_files)
                filePath = result_files{iFile};
                Results = ResultsImporter.import(filePath);
                airfoilTable = Results.Polar;
                airfoilTable.Re = ones(height(airfoilTable), 1) * Results.Re;
                airfoilTable.Airfoil = repelem(Results.Airfoil, height(airfoilTable))';
                Solution = [Solution; airfoilTable];
            end

        end
        
        function Result = getCLCDatGivenCL(Solution, CL, Re)
            if nargin ==2
               Re = Solution.Re;
            end
            
            combinations.Re = unique(Re);
            combinations.Airfoil = unique(Solution.Airfoil);
            combinations.Airfoil = arrayfun(@(foil) {char(foil)}, combinations.Airfoil);
            combination_table = create_combinationTable(combinations);
            
            
            CL_max      = NaN(height(combination_table), 1);
            CL_min      = NaN(height(combination_table), 1);
            alpha_max   = NaN(height(combination_table), 1);
            alpha_min   = NaN(height(combination_table), 1);
            CLCD_max    = NaN(height(combination_table), 1);
            CLCD        = NaN(height(combination_table), length(CL));
            
            
            parfor iRow = 1:round(height(combination_table)/100)
                % filter
                Re_current = combination_table.Re(iRow);
                airfoil_current = combination_table.Airfoil(iRow);
                Solution_current =  Solution(Solution.Airfoil == airfoil_current, :);
                Solution_current = Solution_current(Solution_current.Re == Re_current, :);
                
                if isempty(Solution_current) || height(Solution_current) < 10
                    continue
                end
                
                %assignment
                CL_max(iRow)    = max(Solution_current.CL); 
                CL_min(iRow)    = min(Solution_current.CL); 
                alpha_max(iRow) = max(Solution_current.Alpha);
                alpha_min(iRow) = min(Solution_current.Alpha);
                
            	% Calculate mean over multiple alphas
                [uniqueAlphas, idxA, idxB] = unique(Solution_current.Alpha);
                for iAlpha = 1:length(uniqueAlphas)
                    Solution_current{idxA(iAlpha),2:end} = min(Solution_current{Solution_current.Alpha==uniqueAlphas(iAlpha), 2:end});
                end
                
                %
                Solution_current = Solution_current(idxA, :);
                Solution_current = sortrows(Solution_current, 'Alpha');

                PosCLTab = Solution_current(Solution_current.CL >= 0, :);
                NegCLTab = Solution_current(Solution_current.CL < 0, :);

                Posfilter = PosCLTab.CL(1:end-1) >= PosCLTab.CL(2:end);
                posIdx = find(Posfilter, 1, 'first');
                PosCLTab(posIdx:end, :) = [];
                Negfilter = NegCLTab.CL(1:end-1) <= NegCLTab.CL(2:end);
                negIdx = find(Negfilter, 1, 'last');
                NegCLTab(1:negIdx, :) = [];

                Solution_current = [NegCLTab; PosCLTab];
                
                CLCD_max(iRow) = max(Solution_current.CLCD);    
                
                % interpolate CLCD over given CL
                CLCD_save = NaN(length(CL), 1);
                for iCL = 1:length(CL)
                    try
                        CLCD_save(iCL) = interp1(Solution_current.CL, Solution_current.CLCD, CL(iCL), 'linear','extrap');

                        if abs(CLCD_save(iCL)) > CLCD_max(iRow)
                            CLCD_save(iCL) = NaN;
                        end

                    catch
                        
                    end
                    
                end
                CLCD(iRow, :) = CLCD_save;
                
            end
            
            
            CLCDNames = arrayfun(@(val) sprintf("CLCD@%1.2f", val), CL);
            varNames = ["CL_max", "CL_min", "alpha_max", "alpha_min", "CLCD_max", CLCDNames, "Re"];
            vars = [CL_max, CL_min, alpha_max, alpha_min, CLCD_max, CLCD, combination_table.Re];
            Result = array2table(vars, 'VariableNames', varNames);
            Result.Airfoil = string(combination_table.Airfoil);
            Result.alpha_range = Result.alpha_max - Result.alpha_min;
            Result.CL_range = Result.CL_max - Result.CL_min;
            
            
        end
    end
    
end