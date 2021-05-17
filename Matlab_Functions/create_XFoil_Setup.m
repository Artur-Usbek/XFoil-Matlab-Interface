function variable = create_XFoil_Setup(variable)
    %% plotting
    variable.Visible            = false;

    %% Filtering
    %variable.CornerAngle        = 10;
    variable.Filter             = 1; %Apply Hanning filter to entire Qspec 
    variable.FilteringSteps     = 3;

    %% Paneling
    variable.Panels             = 200;  % No. of Panels
    

    %% Flow Condition
%     variable.Re             = (10:5:20)' .* 100000 ;        % Reynoldsnumber range
    variable.Re             = [3, 4, 6, 8, 10, 13, 16, 20, 30, 50, 100, 300]*10^4;        % Reynoldsnumber range
    variable.Mach           = (0.00)';                      % Machnumber range
    
    % Calculation Sequence of AoA
    % 0: Calculation withone AoA only| using variable.Alpha
    %       Recommended for testing airfoils, or very quick selection
    % 1: Enabling Calculation of Sequence| Using min max step
    %       Recommended for Calculation of High Angle of Attack
    %       Since Boundary Layer of Previous Point will be used 
    variable.AlphaSeq       = (1)';                   
    variable.Alpha          = (0)';          % AoA for only one Calculation
    variable.Alpha_min      = (0)';         % minimum Alpha   
    variable.Alpha_max      = [-30, 30]';         % maximum Alpha
    variable.Alpha_step     = (0.5)';          % Alpha steps

    %% Boundary layer parameters
        % Should Boundary layer parameters be changed: default=0
        % 0: default values | 1: change boundary layer parameter
        variable.Vpar           = (0)';

        % normalized Trip Position top side: default=1
        variable.XTR_top        =  (1)';

        % normalized Trip Position bottom side: default=1
        variable.XTR_bottom     =  (1)';

        % critical amplification exponent Ncrit: default=9
        %  situation             Ncrit
        % -----------------        -----
        % sailplane                12-14
        % motorglider              11-13
        % clean wind tunnel        10-12
        % average wind tunnel        9     
        % dirty wind tunnel         4-8
        variable.Ncrit = (9)';                      

        % Newton solution acceleration parameter: default=0.01
        variable.Vacc = (0.01)';
    
        % Boundary Initialization: default=0
        % 0: BLs will be initialized on next point
        % 1: BLs are assumed to be initialized
        variable.BL_Init = (0)';

        % change lag equation constants |default: Klag = 5.6| Uxwt = 1
        variable.Klag  =  (5.6)';
        variable.Uxwt  =   (1.00)';
        
        % change G-beta constants |default: A=6.7000; B = 0.7500       
        variable.G_b_A = (6.7)';
        variable.G_b_B = (0.75)';
        
 
        % initial transition-Ctau constants |default: CtiniK=1.8; CtiniX=3.3
        variable.CtiniK = (1.8)';
        variable.CtiniX = (3.3)';

    %% Calculation Parameters
        % Number of maximum Iterations: default=10
        variable.Iteration_limit   = (200)';              %

        % Calculation Mode: default=0
        % 0: inviscid | 1: viscid 
        variable.Viscous_mode      = (1)';  
        
        
        % Calculation Type: default = 1
        % Note tested! Benutzung auf eigene Gefahr!!!!!!!
        %
        % Type   parameters held constant       varying      fixed
        %  ----   ------------------------       -------   -----------
        %    1    M          , Re            ..   lift     chord, vel.
        %    2    M sqrt(CL) , Re sqrt(CL)   ..   vel.     chord, lift
        %    3    M          , Re CL         ..   chord    lift , vel.
        variable.Calculation_Type  = (1)';
end

