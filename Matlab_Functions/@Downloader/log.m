function log(source, foil, number, percentage, status)
    columns = [source, 	, num2str(number,"%i")...
                num2str(percentage,"%.1f") + "%", status];
    columns = pad(columns, 8);
    columns(2) = pad(columns(2), 12);
   	columns = columns.join(" | ");
    fprintf("|| %s ||\n", columns);
end