%% Startup file for setting up matlab workspace

% Current path
cd ~/ros/indigo/repos/https_/github.com/tue-robotics/
pathstring = pwd;
cd simulink_models.git/;

% Adding simulink models folder
addpath(genpath(strcat(pathstring,'/simulink_models.git/')))

% Adding tue simulink ethercaqt folder
addpath(genpath(strcat(pathstring,'/tue_simulink_ethercat.git')))

% Load Constants
TUe.Reload()