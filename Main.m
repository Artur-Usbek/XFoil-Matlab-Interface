%% Start
clc; 
clear all; 
close all;
addpath(genpath("./Matlab_Functions"))

%% Options
downloaded  = true;
corrected   = true;
calculated  = true;

%% Download Airfoils in parallel
if ~downloaded
    Downloader.FullDownload();
end

%% Correct
% fill/sort and arrange Coordinates in Selig Format
if ~corrected
    correct();
end

%% Clean Up
fclose('all');
XFoilInterface.kill();

%% calculate
% check create_XFoil_Setup for the Calculation Points
inter = XFoilInterface();
if ~calculated
    inter.calculate();
end

%% Load Results
folder      = "./Results";   
Solution    = Evaluator.getFullResults(folder);
Solution    = Evaluator.adjust(Solution);

save("Full_Solution.mat", 'Solution');

Result = Evaluator.getCLCDatGivenCL(Solution, [0.35, 0.5, 0.6]);



