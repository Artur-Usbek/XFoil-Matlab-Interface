function [process, outputReader]      = startXFoil(xfoil_command)
%% Create Process  
        process                                    = System.Diagnostics.Process(); % Create Process 
        process.StartInfo.FileName                 = 'cmd.exe'; % cmd.exe should be starte
        process.StartInfo.WindowStyle              = System.Diagnostics.ProcessWindowStyle.Hidden;
        process.StartInfo.CreateNoWindow           = true; % should no windows be opened?
        process.StartInfo.UseShellExecute          = false; % for output/input Redirection = false
        process.StartInfo.RedirectStandardInput    = true; % automatic Input
        %proc.StartInfo.RedirectStandardOutput   = true; % output should be save and not only printed in console
        %proc.StartInfo.RedirectStandardError    = true;
        process.EnableRaisingEvents                = true;
        
        %% Create Output Reader for saving output
        
        pause(1)
        %outputReader        =  System.IO.StreamWriter(errors_file_path);       %give path for writing Output
        %outputReader.AutoFlush = true;
        outputReader = struct();
        
        %% run xfoil with these commands  
        process.Start();   %start Process/cmd window
       % proc.BeginOutputReadLine(); 
        
        process.StandardInput.WriteLine(xfoil_command);                  %input command into cmd-Console->Starting xfoil
        process.StandardInput.Flush();
        process.StandardInput.Close();

end