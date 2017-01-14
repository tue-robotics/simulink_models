function Constants = SetupConstants()
% Definition of constants for your setup.
%
% This function should not be used directly, use TUe.Constants.[variable]
% instead.
%
%
% Clear (reload) cached constants:
%   TUe.Reload()
%

%% General Settings
Constants.general.Fs = 1000;
Constants.general.Ts = 1/Constants.general.Fs;

%% Encoder Settings
Constants.mdl.CPT_m1 = 500*4;
Constants.mdl.CPT_m2 = 500*4;
Constants.mdl.CPT_m3 = 500*4;
Constants.mdl.CPT_m4 = 500;
Constants.mdl.CPT_m5 = 500;
Constants.mdl.CPT_m6 = 512;
Constants.mdl.CPT_m7 = 512;

Constants.mdl.TUeES030.EncoderCounterSize = 2^32; % Navragen of dit echt een 32bit counter is 

%% Gearbox Ratio's    maxon * custom gearbox ratio
Constants.mdl.GR_m1 = (204687/2057)*(60/20);
Constants.mdl.GR_m2 = (204687/2057)*(60/20);
Constants.mdl.GR_m3 = (226233/3179)*(90/24);
Constants.mdl.GR_m4 = (3249/121)*(60/1);
Constants.mdl.GR_m5 = (3249/121)*(60/1);
Constants.mdl.GR_m6 = (15/4);
Constants.mdl.GR_m7 = (15/4);

%% Maxon Motor Current Limits
Constants.mdl.MotorCurrentLimit_m1 = 1.0; % [A]
Constants.mdl.MotorCurrentLimit_m2 = 1.0; % [A]
Constants.mdl.MotorCurrentLimit_m3 = 1.0; % [A]
Constants.mdl.MotorCurrentLimit_m4 = 1.0; % [A]
Constants.mdl.MotorCurrentLimit_m5 = 1.0; % [A]
Constants.mdl.MotorCurrentLimit_m6 = 1.0; % [A]
Constants.mdl.MotorCurrentLimit_m7 = 1.0; % [A]

%% Controller Parameters
Constants.mdl.control.Kc 		= [2000, 	2000, 	500, 	80, 	800,	0.0,	0.0];
Constants.mdl.control.Kd 		= [4, 		4, 		2, 		0.005, 	0.5,	0.0,	0.0];
Constants.mdl.control.Ki 		= [10, 		10, 	10, 	0.01, 	10,		0.0,	0.0];
Constants.mdl.control.iLim      = [10, 		10, 	10, 	2, 		10,		1.0, 	0.0];

%% Matrices for switching between Motor and Jointspace
Constants.mdl.Motor2JointSpace  = [	0.5,    0.5,    0,      0,      0,      0,      0;
                                   -0.5,    0.5,    0,      0,      0,      0,      0;
                                    0,      0,      1,      0,      0,      0,      0;
                                    0,      0,      0,      0.5,    0.5,    0,      0;
                                    0,      0,      0,      0.5,   -0.5,    0,      0;
                                    0,      0,      0,      0,      0,      1,      0;
                                    0,      0,      0,      0,      0,      0,      1];
                                
Constants.mdl.Joint2MotorSpace  = inv(Constants.mdl.Motor2JointSpace);

%% Stateflow constants
Constants.mdl.controlErrorBound = [0.01, 	0.01, 	0.01, 	0.01, 	0.01,	0.01,	0.01]; 
Constants.mdl.controlEffortBound = [10.0, 	10.0, 	10.0, 	10.0, 	10.0,	10.0,	10.0]; 


% JointLimitMin 	= [-129,   -5.7, 	0, 		0, 		-12.35,	-129,	-5.7];
% JointLimitMax 	= [ 195,	178.3, 	182, 	129, 	278.5,  195,	178.3];
% absLimMin		= [ 1217,	161,	4084,	135,	33,		1217,	395];
% absLimMax		= [ 2374,	1666,	441,	2020,	3741,	2374,	3420];		
% abs2deg = (JointLimitMax - JointLimitMin)/(absLimMax-absLimMax);