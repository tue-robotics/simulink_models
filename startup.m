%% Startup file for setting up matlab workspace

if(ispc) % if Windows

    % Current path
    cd ..
    pathstring = pwd;
    cd simulink_models;

    % Adding simulink models folder
    addpath(genpath(strcat(pathstring,'\simulink_models')))

    % Adding tue simulink ethercat folder
    addpath(genpath(strcat(pathstring,'\tue_simulink_ethercat')))
    
else % else Linux (Make symlink to /home/username/startup.m)
    
    % Path to github source
    cd ~/ros/indigo/repos/https_/github.com/tue-robotics/
    pathstring = pwd;
    cd simulink_models.git/;

    % Adding simulink models folder
    addpath(genpath(strcat(pathstring,'/simulink_models.git/')))

    % Adding tue simulink ethercat folder
    addpath(genpath(strcat(pathstring,'/tue_simulink_ethercat.git')))
    
end


% Load Constants
TUe.Reload()
