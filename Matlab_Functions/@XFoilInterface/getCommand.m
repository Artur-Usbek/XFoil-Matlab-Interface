function xfoil_command = getCommand(xfoil_input_file, xfoil_error_file)
    xfoil_exe = "xfoil.exe";   %Create path to exe file
    cmd(1) = "cd ..";
    cmd(2) = "cd ..";
    cmd(3) = sprintf("%s < %s > %s & exit", xfoil_exe, xfoil_input_file, xfoil_error_file);
    xfoil_command = join(cmd, " & "); % create command line
end