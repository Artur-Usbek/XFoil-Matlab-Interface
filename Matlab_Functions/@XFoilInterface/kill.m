function kill(maximum_runtime)
    %Function for killing XFOIL-Processes

    if nargin == 0
        maximum_runtime = 0;
    end

    %get all xfoil processes
    name        = 'xfoil'; 
    processes   = System.Diagnostics.Process.GetProcessesByName(name); 

    %Iterate over all xfoil processes, calculate runtime, kill if runtime bigger than maximum runtime
    for jProcess = 1:processes.Length
       Process  = processes(jProcess);
       pid      = Process.Id;                       
       runtime  = (Process.StartTime.Now - Process.StartTime);
       runtime  = runtime.TotalSeconds;
       if runtime > maximum_runtime
            [~, ~] = system(sprintf('taskkill /PID %i /F', pid));
            fprintf("Killed XFOIL: %.0f\n", pid);
       end
    end
    
end