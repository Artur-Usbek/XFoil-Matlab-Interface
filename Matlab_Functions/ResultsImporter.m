classdef ResultsImporter
    
    methods (Static)
        
        function Results = import(filePath)
            Results = struct();
            fileID = fopen(filePath,'r');
            
            startRow = 13;
            formatSpec = '%f%f%f%f%f%f%f%[^\n\r]';
            dataArray = textscan(fileID, formatSpec, 'Delimiter', '', ...
                                'WhiteSpace', '', 'TextType', 'string', ...
                                'HeaderLines' ,startRow-1, 'ReturnOnError', ...
                                false, 'EndOfLine', '\r\n');
            fclose(fileID);
            Results.Polar = table(dataArray{1:end-1}, 'VariableNames', {'alpha','CL','CD','CDp','CM','Top_Xtr','Bot_Xtr'});
            
            
            Results.Airfoil = getAirfoil(filePath);
            % Re
            Re = split(filePath, '_');
            Re = str2num(Re{end-2});
            Re = 1000*round(Re./1000);
            
            Results.Re = Re;
            
        end
        
        
        
        
    end
    
    
end