function alpha_all = return_calculated_alphas(Setup_line)
% polar_Path: str            is the Path to the *.txt file
% foil_Coord: table          returns table with Solution
%% Extracting Coordinated from Airfoil File
   alpha_all = [];
   % AlphaMode
    if Setup_line.AlphaSeq==1
        if Setup_line.Alpha_min < 0 % splitting calculation
            alpha_all(end+1) = 0;

            alpha = 0;
            while alpha > Setup_line.Alpha_min %from 0 to alphamin
                alpha            = alpha - Setup_line.Alpha_step;
                alpha_all(end+1) = alpha;
            end
            alpha = 0;
            while alpha < Setup_line.Alpha_max %from 0 to alphamas
                alpha           = alpha + Setup_line.Alpha_step;
                alpha_all(end+1) = alpha;
            end

        else %no split
            alpha = Setup_line.Alpha_min;
            alpha_all(end+1) = alpha;

            while alpha < Setup_line.Alpha_max %from 0 to alphamas
                alpha           = alpha + Setup_line.Alpha_step;
                alpha_all(end+1) = alpha;
            end
        end

    else %no range
        alpha_all = [Setup_line.Alpha];
    end 
    
end