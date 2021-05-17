function error = checkOutput(proc, outputReader, error_file)

    error               = 1;
    tLimit              = 360;
    tStart              = tic;
    
    
    %proc.WaitForExit(tLimit)
    %output  = System.Text.StringBuilder();
    %outputWaitHandle = System.Threading.AutoResetEvent(false)
    
    
    errorTxt_oldLength = length(fileread(error_file));
    while ~proc.HasExited ...
            && toc(tStart) < tLimit
        pause(5);
        errorTxt_NewLength = length(fileread(error_file));
        try
            exitCode    =   proc.ExitCode();
            if exitCode == 0
                error  =   0;
            end
            break
        end
        if errorTxt_NewLength == errorTxt_oldLength
            break
        end
        errorTxt_oldLength = errorTxt_NewLength;
    end
    [~, ~] = system(sprintf('taskkill /PID %i /F', proc.Id));
%     if  ~proc.HasExited
%        proc.Kill(); 
%     end
    
%     while ~proc.HasExited %...
%            && toc(tStart) < tLimit%  ...
%            && ~proc.StandardOutput.EndOfStream    
%         Has the calculation finished normally?
%         display("-1");
%         if proc.StandardOutput.Peek == -1
%             break
%         end
%         display("0");
%         line = proc.StandardOutput.ReadLine();
%         display("1");
%         display("2");
%         toc(tStart)
%         display("3");
%         if ~isempty(output)
%         if ~line.IsNullOrEmpty(line.char)
%             display("4");
%             if contains(output, "VISCAL")
%             if contains(line.char, "VISCAL")
%                 display("5");
%              	error = 2;
%                 display("6");
%                 break
%             end
%             
%             display("8");
%             outputReader.WriteLine(line.string); 
%             outputReader.Write(output); 
%             
%             display("9");
%             outputReader.Flush();
%             
%             display("10");
%         end
%         
%         display("11");
%         try
%             display("12");
%             exitCode    =   proc.ExitCode();
%             display("13");
%             if exitCode == 0
%                 display("14");
%                 error  =   0;
%                 display("15");
%             end
%             display("16");
%             break
%             display("17");
%         end
%         
%         display("18");
%     end    
%  
    
    
%     proc.WaitForExit(tLimit);
%     if  ~proc.HasExited
%        proc.Kill(); 
%     end
%     [~, ~] = system(sprintf('taskkill /PID %i', proc.Id));
%   	outputReader.Write(proc.StandardOutput.ReadToEnd()); 
%     try
%         exitCode    =   proc.ExitCode();
%         if exitCode == 0
%             display("14");
%             error  =   0;
%             display("15");
%         end
%     end
    
    

end   
        
    
    
    %%
%     
%     %% look for errors and warnings:
%     %% Warnings
%     warnings = split(results, "WARNING: ");
%     if length(warnings)>1 %warnings are in the script
%        for i=2:length(warnings) %for every Warning in the Script
%             warning = split(warnings{i},[char(10), char(10)]); %char 10 = Newline charachte
%             warning = warning{1}
%        end
%     end
%     
%     %% Errors
%     Errors = split(results, "Error: ");
%     if length(warnings)>1 %warnings are in the script
%        for i=2:length(warnings) %for every Warning in the Script
%             warning = split(warnings{i},[char(10), char(10)]); %char 10 = Newline character
%             warning = warning{1}
%        end
%     end
%     
%     %% Delete Input File
%     delete(input_foil_Path)


