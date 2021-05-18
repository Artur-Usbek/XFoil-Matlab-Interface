function closeXFoil(process, error, xfoil_error_file, maximum_runtime)
        % Output Process & Closing Objects
    
       % outputReader.Write(proc.StandardOutput.ReadToEnd);
        %outputReader.Close;
        process.Close;    

        % Kill Xfoil
        XFoilInterface.kill(maximum_runtime);
        
        if error == 0
            delete(xfoil_error_file);
        end
        
        pause(1);

end