%% Startup file for setting up matlab workspace

if(ispc) % if Windows

    % Current path
    cd ..
    pathstring = pwd;
    cd simulink_models;

    % Adding folders to matlab path
    addpath(genpath(strcat(pathstring,'\simulink_models')))
    addpath(genpath(strcat(pathstring,'\tue_simulink_ethercat')))
    addpath(genpath(strcat(pathstring,'\soem')))
    
else % else Linux (Make symlink to /home/username/startup.m)
    
    % Path to github source
    cd ~/ros/indigo/repos/https_/github.com/tue-robotics/
    pathstring = pwd;
    cd simulink_models.git/;

    % Adding folders to matlab path
    addpath(genpath(strcat(pathstring,'/simulink_models.git/')))
    addpath(genpath(strcat(pathstring,'/tue_simulink_ethercat.git')))
    addpath(genpath(strcat(pathstring,'/soem.git')))
end


% Load Constants
TUe.Reload()
