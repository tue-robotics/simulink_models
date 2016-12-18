%% Startup file for setting up matlab workspace

% Current path
cd ../..
pathstring = pwd;
cd simulink_models;

% Adding simulink models folder
addpath(genpath(strcat(pathstring,'\simulink_models')))

% Adding tue simulink ethercaqt folder
addpath(genpath(strcat(pathstring,'\tue_simulink_ethercat')))

% Load Constants
TUe.Reload()