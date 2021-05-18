function evaluate

%% evaluate
% load('G:\AirfoilTool\Results\Solution_2021-04-19+21-45-23.mat')
% Solution1 = Solution;
% load('G:\AirfoilTool\Results\Solution_2021-04-20+06-14-11.mat')
% 
% Solution2 = Solution;
% Solution = [Solution1; Solution2];
% load('G:\AirfoilTool\Results\Solution_2021-04-22+10-40-48.mat')
% 
% 



%% Main Wing



    CLCD_035 = NaN(length(airfoils), 1);
    CLCD_04 = NaN(length(airfoils), 1);
    CLCD_05 = NaN(length(airfoils), 1);
    CLCD_06 = NaN(length(airfoils), 1);
    CL_Max_4  = NaN(length(airfoils), 1);
    CL_Max_2  = NaN(length(airfoils), 1);
    alpha_Max  = NaN(length(airfoils), 1);
    alpha_Min  = NaN(length(airfoils), 1);
    errorFoil = NaN(length(airfoils), 1);



    parfor iAirfoil = 1:length(airfoils)
        
        if ~isempty(AirfoilSolution1)
            CL_Max_2(iAirfoil) = max(AirfoilSolution1.CL);
        end
        if height(AirfoilSolution2) < 10
            continue
        end
        CL_Max_4(iAirfoil) = max(AirfoilSolution2.CL);
        alpha_Max(iAirfoil) = max(AirfoilSolution2.Alpha);
        alpha_Min(iAirfoil) = min(AirfoilSolution2.Alpha);
        %% Mittelung über alphas, falls mehrre Punkte für ein alpha
        [uniqueAlphas, idxA, idxB] = unique(AirfoilSolution2.Alpha);
        for iAlpha = 1:length(uniqueAlphas)
            AirfoilSolution2{idxA(iAlpha),2:end} = min(AirfoilSolution2{AirfoilSolution2.Alpha==uniqueAlphas(iAlpha), 2:end});
        end
        AirfoilSolution2 = AirfoilSolution2(idxA, :);
        AirfoilSolution2 = sortrows(AirfoilSolution2, 'Alpha');
    %     [~, maxIdx] = max(AirfoilSolution.CL);
    %     [~, minIdx] = min(AirfoilSolution.CL);
    %     AirfoilSolution = AirfoilSolution(minIdx:maxIdx, :);

        PosCLTab = AirfoilSolution2(AirfoilSolution2.CL >= 0, :);
        NegCLTab = AirfoilSolution2(AirfoilSolution2.CL < 0, :);

        Posfilter = PosCLTab.CL(1:end-1) >= PosCLTab.CL(2:end);
        posIdx = find(Posfilter, 1, 'first');
        PosCLTab(posIdx:end, :) = [];
        Negfilter = NegCLTab.CL(1:end-1) <= NegCLTab.CL(2:end);
        negIdx = find(Negfilter, 1, 'last');
        NegCLTab(1:negIdx, :) = [];

        AirfoilSolution2 = [NegCLTab; PosCLTab];
        CLCD_max = max(AirfoilSolution2.CLCD);
        %plot(AirfoilSolution.CL, AirfoilSolution.CLCD, '.')
        try
            CLCD_035(iAirfoil) = interp1(AirfoilSolution2.CL, AirfoilSolution2.CLCD, CL_035, 'linear','extrap');
            CLCD_04(iAirfoil) = interp1(AirfoilSolution2.CL, AirfoilSolution2.CLCD, CL_04, 'linear','extrap');
            CLCD_05(iAirfoil) = interp1(AirfoilSolution2.CL, AirfoilSolution2.CLCD, CL_05, 'linear','extrap');
            CLCD_06(iAirfoil) = interp1(AirfoilSolution2.CL, AirfoilSolution2.CLCD, CL_06, 'linear','extrap');

            if abs(CLCD_035(iAirfoil)) > CLCD_max
                CLCD_035(iAirfoil) = NaN;
            end
            if abs(CLCD_04(iAirfoil)) > CLCD_max
                CLCD_04(iAirfoil) = NaN;
            end
            if abs(CLCD_05(iAirfoil)) > CLCD_max
                CLCD_05(iAirfoil) = NaN;
            end
            if abs(CLCD_06(iAirfoil)) > CLCD_max
                CLCD_06(iAirfoil) = NaN;
            end

        catch
            errorFoil(iAirfoil) = iAirfoil;
        end
    end
    errorFoil = rmmissing(errorFoil);
    alpha_Bereich = alpha_Max-alpha_Min;
    decisionTab2 = table(airfoils, CLCD_035, CLCD_04, CLCD_05, CLCD_06, ...
                        alpha_Max, alpha_Min, alpha_Bereich, CL_Max_2, CL_Max_4);

    decisionTab2 = rmmissing(decisionTab2);


    decisionTab2.Points = decisionTab2.CLCD_04  ...
                           + decisionTab2.CLCD_05  ...
                           + decisionTab2.CLCD_06  ...
                           + decisionTab2.CLCD_035  ...
                           + (decisionTab2.CL_Max_2-1.4) .*10 ...
                           + (decisionTab2.CL_Max_4-1.4) .*10;

    decisionTab2(decisionTab2.CL_Max_2 <1.4, :) = [];
    decisionTab2(decisionTab2.CL_Max_4 <1.4,:) = [];
    writetable(decisionTab2, "Profilanalys_min.xlsx")
    save('Profilanalys_min.mat','decisionTab2')
    
 
%% Tail

alpha_Max_2     = NaN(length(airfoils), 1);
alpha_Min_2     = NaN(length(airfoils), 1);
CL_Max_2        = NaN(length(airfoils), 1);
CL_Min_2        = NaN(length(airfoils), 1);
CD_Min_2       	= NaN(length(airfoils), 1);
CL_at_CD_Min_2 	= NaN(length(airfoils), 1);

alpha_Max_4     = NaN(length(airfoils), 1);
alpha_Min_4     = NaN(length(airfoils), 1);
CL_Max_4        = NaN(length(airfoils), 1);
CL_Min_4        = NaN(length(airfoils), 1);
CD_Min_4       	= NaN(length(airfoils), 1);
CL_at_CD_Min_4 	= NaN(length(airfoils), 1);


unique_Re = unique(Solution.Re);

Re_tab_1 = Solution(Solution.Re == unique_Re(1), :);
Re_tab_2 = Solution(Solution.Re == unique_Re(2), :);

for iAirfoil = 1:length(airfoils)
    airfoil = airfoils(iAirfoil);
    AirfoilSolution1 = Re_tab_1(Re_tab_1.Airfoil == airfoil, :);
    AirfoilSolution2 = Re_tab_2(Re_tab_2.Airfoil == airfoil, :);
    if height(AirfoilSolution1) < 5 || height(AirfoilSolution2) < 5
        continue
    end
    %Cl max
    CL_Max_2(iAirfoil) = max(AirfoilSolution1.CL);
    CL_Max_4(iAirfoil) = max(AirfoilSolution2.CL);
    %Cl min
    CL_Min_2(iAirfoil) = min(AirfoilSolution1.CL);
    CL_Min_4(iAirfoil) = min(AirfoilSolution2.CL);
    %alpha max
    alpha_Max_2(iAirfoil) = max(AirfoilSolution1.Alpha);
    alpha_Max_4(iAirfoil) = max(AirfoilSolution2.Alpha);
    %alpha min
    alpha_Min_2(iAirfoil) = min(AirfoilSolution1.Alpha);
    alpha_Min_4(iAirfoil) = min(AirfoilSolution2.Alpha);
    % CD min
    CD_Min_2(iAirfoil) = min(AirfoilSolution1.CD);
    CD_Min_4(iAirfoil) = min(AirfoilSolution2.CD);
    % CLat CDMin
    CL_at_CD_Min_2(iAirfoil) 	= min(AirfoilSolution1.CL(AirfoilSolution1.CD == CD_Min_2(iAirfoil)));
    CL_at_CD_Min_4(iAirfoil) 	= min(AirfoilSolution2.CL(AirfoilSolution2.CD == CD_Min_4(iAirfoil)));
    
    
    
    
end

alpha_Bereich_2 = alpha_Max_2 - alpha_Min_2;
alpha_Bereich_4 = alpha_Max_4 - alpha_Min_4;
CL_Bereich_2 = CL_Max_2 - CL_Min_2;
CL_Bereich_4 = CL_Max_4 - CL_Min_4;
decisionTab2 = table(airfoils, CD_Min_2, CD_Min_4, alpha_Min_2, alpha_Min_4, ...
                    alpha_Max_2, alpha_Max_4, alpha_Bereich_2, alpha_Bereich_4, ...
                    CL_Min_2, CL_Min_4, CL_Max_2, CL_Max_4, ...
                    CL_Bereich_2, CL_Bereich_4, CL_at_CD_Min_2, CL_at_CD_Min_4);

decisionTab2 = rmmissing(decisionTab2);

decisionTab2.Points = -1000*decisionTab2.CD_Min_2 ...
                        - 1000*decisionTab2.CD_Min_4 ...
                        + 2 * decisionTab2.CL_Bereich_2 ...
                        + 2 * decisionTab2.CL_Bereich_4;

decisionTab2(decisionTab2.CD_Min_2 > 0.01, :) = [];
decisionTab2(decisionTab2.CD_Min_4 > 0.01,:) = [];
decisionTab2(abs(decisionTab2.CL_at_CD_Min_2) > 0.1,:) = [];
decisionTab2(abs(decisionTab2.CL_at_CD_Min_4) > 0.1,:) = [];
decisionTab2(decisionTab2.alpha_Bereich_2 < 20, :) = [];
decisionTab2(decisionTab2.alpha_Bereich_4 < 20,:) = [];
writetable(decisionTab2, "Profilanalys_Tail.xlsx")
save('Profilanalys_Tail.mat','decisionTab2')
    

%% Tail Low Re
alpha_Max_1     = NaN(length(airfoils), 1);
alpha_Min_1     = NaN(length(airfoils), 1);
CL_Max_1        = NaN(length(airfoils), 1);
CL_Min_1        = NaN(length(airfoils), 1);
CD_Min_1       	= NaN(length(airfoils), 1);
CL_at_CD_Min_1 	= NaN(length(airfoils), 1);

alpha_Max_2     = NaN(length(airfoils), 1);
alpha_Min_2     = NaN(length(airfoils), 1);
CL_Max_2        = NaN(length(airfoils), 1);
CL_Min_2        = NaN(length(airfoils), 1);
CD_Min_2       	= NaN(length(airfoils), 1);
CL_at_CD_Min_2 	= NaN(length(airfoils), 1);

alpha_Max_4     = NaN(length(airfoils), 1);
alpha_Min_4     = NaN(length(airfoils), 1);
CL_Max_4        = NaN(length(airfoils), 1);
CL_Min_4        = NaN(length(airfoils), 1);
CD_Min_4       	= NaN(length(airfoils), 1);
CL_at_CD_Min_4 	= NaN(length(airfoils), 1);


unique_Re = unique(Solution.Re);

Re_tab_1 = Solution(Solution.Re == unique_Re(1), :);
Re_tab_2 = Solution(Solution.Re == unique_Re(2), :);
Re_tab_4 = Solution(Solution.Re == unique_Re(3), :);

for iAirfoil = 1:length(airfoils)
    airfoil = airfoils(iAirfoil);
    AirfoilSolution1 = Re_tab_1(Re_tab_1.Airfoil == airfoil, :);
    AirfoilSolution2 = Re_tab_2(Re_tab_2.Airfoil == airfoil, :);
    AirfoilSolution4 = Re_tab_4(Re_tab_4.Airfoil == airfoil, :);
    if height(AirfoilSolution1) < 5 || ...
            height(AirfoilSolution2) < 5 || ...
            height(AirfoilSolution4) < 5
        continue
    end
    %Cl max
    CL_Max_1(iAirfoil) = max(AirfoilSolution1.CL);
    CL_Max_2(iAirfoil) = max(AirfoilSolution2.CL);
    CL_Max_4(iAirfoil) = max(AirfoilSolution4.CL);
    %Cl min
    CL_Min_1(iAirfoil) = min(AirfoilSolution1.CL);
    CL_Min_2(iAirfoil) = min(AirfoilSolution2.CL);
    CL_Min_4(iAirfoil) = min(AirfoilSolution4.CL);
    %alpha max
    alpha_Max_1(iAirfoil) = max(AirfoilSolution1.Alpha);
    alpha_Max_2(iAirfoil) = max(AirfoilSolution2.Alpha);
    alpha_Max_4(iAirfoil) = max(AirfoilSolution4.Alpha);
    %alpha min
    alpha_Min_1(iAirfoil) = min(AirfoilSolution1.Alpha);
    alpha_Min_2(iAirfoil) = min(AirfoilSolution2.Alpha);
    alpha_Min_4(iAirfoil) = min(AirfoilSolution4.Alpha);
    % CD min
    CD_Min_1(iAirfoil) = min(AirfoilSolution1.CD);
    CD_Min_2(iAirfoil) = min(AirfoilSolution2.CD);
    CD_Min_4(iAirfoil) = min(AirfoilSolution4.CD);
    % CLat CDMin 
    CL_at_CD_Min_1(iAirfoil) 	= min(AirfoilSolution1.CL(AirfoilSolution1.CD == CD_Min_1(iAirfoil)));   
    CL_at_CD_Min_2(iAirfoil) 	= min(AirfoilSolution2.CL(AirfoilSolution2.CD == CD_Min_2(iAirfoil)));
    CL_at_CD_Min_4(iAirfoil) 	= min(AirfoilSolution4.CL(AirfoilSolution4.CD == CD_Min_4(iAirfoil)));
    
    
    
    
end

alpha_Bereich_1 = alpha_Max_1 - alpha_Min_1;
alpha_Bereich_2 = alpha_Max_2 - alpha_Min_2;
alpha_Bereich_4 = alpha_Max_4 - alpha_Min_4;
CL_Bereich_1 = CL_Max_1 - CL_Min_1;
CL_Bereich_2 = CL_Max_2 - CL_Min_2;
CL_Bereich_4 = CL_Max_4 - CL_Min_4;
decisionTab2 = table(airfoils,  CD_Min_1, CD_Min_2, CD_Min_4, ...
                                alpha_Min_1, alpha_Min_2, alpha_Min_4, ...
                                alpha_Max_1, alpha_Max_2, alpha_Max_4, ...
                                alpha_Bereich_1, alpha_Bereich_2, alpha_Bereich_4, ...
                                CL_Min_1, CL_Min_2, CL_Min_4, ...
                                CL_Max_1, CL_Max_2, CL_Max_4, ...
                                CL_Bereich_1, CL_Bereich_2, CL_Bereich_4, ...
                                CL_at_CD_Min_1, CL_at_CD_Min_2, CL_at_CD_Min_4);

decisionTab2 = rmmissing(decisionTab2);

decisionTab2.Points =   -10000*decisionTab2.CD_Min_1 ...
                        %-1000*decisionTab2.CD_Min_2 ...
                        %-1000*decisionTab2.CD_Min_4 ...
                        + 50 * decisionTab2.CL_Bereich_1; 
                        %+ 2 * decisionTab2.CL_Bereich_2 ...
                        %+ 2 * decisionTab2.CL_Bereich_4;
decisionTab2.Points =   -10000*decisionTab2.CD_Min_1 + 50 * decisionTab2.CL_Bereich_1;

decisionTab2(decisionTab2.CD_Min_1 > 0.01, :) = [];
decisionTab2(decisionTab2.CD_Min_2 > 0.01, :) = [];
decisionTab2(decisionTab2.CD_Min_4 > 0.01,:) = [];
decisionTab2(abs(decisionTab2.CL_at_CD_Min_1) > 0.2,:) = [];
decisionTab2(abs(decisionTab2.CL_at_CD_Min_2) > 0.2,:) = [];
decisionTab2(abs(decisionTab2.CL_at_CD_Min_4) > 0.2,:) = [];
decisionTab2(decisionTab2.alpha_Bereich_1 < 10, :) = [];
decisionTab2(decisionTab2.alpha_Bereich_2 < 10, :) = [];
decisionTab2(decisionTab2.alpha_Bereich_4 < 10,:) = [];
writetable(decisionTab2, "Profilanalys_Tail.xlsx")
save('Profilanalys_Tail.mat','decisionTab2')



end