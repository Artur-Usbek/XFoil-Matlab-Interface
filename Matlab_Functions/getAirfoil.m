function airfoil = getAirfoil(filePath)

%% Setup the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 7);

% Specify range and delimiter
opts.DataLines = [4, 4];
opts.Delimiter = " ";

% Specify column names and types
opts.VariableNames = ["Var1", "Var2", "Var3", "CDp", "Var5", "Var6", "Var7"];
opts.SelectedVariableNames = "CDp";
opts.VariableTypes = ["string", "string", "string", "string", "string", "string", "string"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";
opts.ConsecutiveDelimitersRule = "join";
opts.LeadingDelimitersRule = "ignore";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "CDp", "Var5", "Var6", "Var7"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var2", "Var3", "CDp", "Var5", "Var6", "Var7"], "EmptyFieldRule", "auto");

% Import the data
airfoil = readmatrix(filePath, opts);

end