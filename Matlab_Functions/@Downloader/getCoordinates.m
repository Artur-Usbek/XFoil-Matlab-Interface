function Coordinates = getCoordinates(url, source)
    
switch source
    
        case 'Delft'
            code        = webread(url);
            tree        = htmlTree(code);
            element     = findElement(tree, "Body");
            PREelement  = findElement(element, "PRE");
            Coordinates = PREelement.extractHTMLText;
            Coordinates = textscan( Coordinates, '%s', 'Delimiter', '\n');
            Coordinates = string(Coordinates{:});
            Coordinates = strjoin(Coordinates, "\n");
            
        case 'Selig'
            code        = webread(url);
            code        = char(code)';
            code        = textscan( code, '%s', 'Delimiter', '\n' );
            Coordinates = string(code{1}(2:end));
            Coordinates = strjoin(Coordinates, "\n");
            
        case 'AFT' 
            code        = webread(url);
            tree        = htmlTree(code);
            text        = tree.string;
            text        = extractBetween(text, "<BODY>", "</BODY>");
            text        = textscan( text, '%s', 'Delimiter', '\n');
            Coordinates = string(text{1}(2:end));
            Coordinates = strjoin(Coordinates, "\n");
        otherwise
        
end

end