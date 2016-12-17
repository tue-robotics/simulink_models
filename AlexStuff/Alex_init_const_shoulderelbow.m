clear all; close all; clc

% Fs = 1000;      %[Hz], sampling frequency
% Ts = 1/Fs;      %[s] , sampling time

%% Encoder counts & Gear ratios
% CPT = counts per motor turn
% planet = planetary gearbox ratio
% Gsmall = number of gears on small gear
% Glarge = number of gears on large gear
% GR = total gear ratio from motor to link

% Shoulder
% CPT_s1 = 500*4;
% planet_s1 = 204687/2057;
% Gsmall_s1 = 20;
% Glarge_s1 = 60;
% GR_s1 = planet_s1*Glarge_s1/Gsmall_s1

% CPT_s2 = 500*4;
% planet_s2 = 204687/2057;
% Gsmall_s2 = 20;
% Glarge_s2 = 60;
% GR_s2 = planet_s2*Glarge_s2/Gsmall_s2

% CPTs3 = 500*4;
% planets3 = 226233/3179;
% Gsmalls3 = 24;
% Glarges3 = 90;
% GR_s3 = planets3*Glarges3/Gsmalls3

% % Elbow
% CPTe1 = 500;
% planete1 = 3249/121;
% Gsmalle1 = 1;
% Glargee1 = 60;
% GRe1 = planete1*Glargee1/Gsmalle1
% Jm_e1 = 14.7e-7;

% CPTe2 = CPTe1;
% GRe2 = GRe1

%% PID gains
% Kc = P gain
% Kd = D gain
% Ki = I gain
% ilim = integrator limit

% % Shoulder
% Kc_s1 = 2000.0;
% Kd_s1 = 4.0;
% Ki_s1 = 10.0;
% ilim_s1 = 10;

% Kc_s2 = 2000.0;
% Kd_s2 = 4.0;
% Ki_s2 = 10.0;
% ilim_s2 = 10;

% Kc_s3 = 500;
% Kd_s3 = 2.0;
% Ki_s3 = 10.0;
% ilim_s3 = 10;

% % Elbow
% Kc_e1 = 80;
% Kd_e1 = 0.005;
% Ki_e1 = 0.01;
% ilim_e1 = 2;

% Kc_e2 = 800;
% Kd_e2 = 2.0/4;
% Ki_e2 = 10.0;
% ilim_e2 = 10;

%% Friction Observer
%L_e1 = 5;

%% Range of DOFs
% % Shoulder
% s1min = -129;
% s1max = 195;
% s1minabs = 1217;
% s1zeroabs = 1710;
% s1maxabs = 2374;
% abs2deg_s1 = (s1max-s1min)/(s1maxabs-s1minabs)

% s2min = -5.7;
% s2max = 178.3;

% s2minabs = 161
% s2maxabs = 1760-94
% abs2deg_s2 = (s2max-s2min)/(s2maxabs-s2minabs)

% s3min = 0;
% s3max = 182;
% s3minabs = 4084;
% s3maxabs = 441;
% abs2deg_s3 = (s3max-s3min)/(s3maxabs-s3minabs)

% % Elbow
% e1min = 0;
% e1max = 129;
% e1minabs = 135;        %wraps to 4095 at approx 3 motor degrees, so limit above 0
% e1maxabs = 2020;
% abs2deg_e1 = (e1max-e1min)/(e1maxabs-e1minabs)

% % e2min = -21.35;
% e2min = -12.35; %abs sensor reach.
% e2max = 278.5;
% e2minabs = 33;        %wraps to 4095 at approx 3 motor degrees, so limit above 0
% e2maxabs = 3741;
% abs2deg_e2 = (e2max-e2min)/(e2maxabs-e2minabs)

%% Gravity Compensation
deg_rad = pi/180;       % convert degrees to radians
mu = 2.804;                 % mass upper arm
ml = 1.649;                 % mass lower arm
Lu = 332.3e-3;          %[m], length upper arm
Ll = 324.6e-3;          %[m], length lower arm

% COGs in link frames
c1x = 0; c1y = 0; c1z = 0;
c2x = 1.79e-3; c2y = 0; c2z = 228.5e-3;
c3x = 0; c3y = 0; c3z = 0;
c4x = 1.91e-3; c4y = 0; c4z = 163e-3;
c5x = 0; c5y = 0; c5z = 0;
c6x = 0; c6y = 0; c6z = 0;
c7x = 0; c7y = 0; c7z = 0;

%Shoulder 1
Kv_s1 = 25.9e-3;        % torque constant
Nm2mA_s1 = 1000/(Kv_s1*GR_s1);  % conversion from Nm to mA

%Shoulder 2
Kv_s2 = 25.9e-3;
Nm2mA_s2 = 1000/(Kv_s2*GR_s2);

%Shoulder 3
Kv_s3 = 25.9e-3;
Nm2mA_s3 = 1000/(Kv_s3*GR_s3);

%Elbow 1
Kv_e1 = 20.8e-3;
Nm2mA_e1 = 1000/(Kv_e1*GRe1);

%% Trajectory Planning
Vmax = 20;               %[-] Maximum velocity, units depend on setpoints
Amax = 40;              %[-] Maximum acceleration, units depend on setpoints

%% Identification Trajectorytmp
load('Traj_Planar41.mat')
% Fs = 1000;
Fs
ff
Ts = 1/Fs;      %[s] , sampling time

N = 20;
qtot = [];
for i = 1:N
qtot = [qtot;q];
end
t = [1/Fs:1/Fs:size(qtot,1)/Fs]';
qinE1 = [t,qtot(:,1)];
qinS2 = [t,qtot(:,2)];
plot(q(:,1))
hold on
plot(q(:,2),'r')

initialtime = 5;
S2initial = qtot(initialtime*Fs,2)
E1initial = qtot(initialtime*Fs,1)
% 
% figure
% plot(qinS2(:,2))
% hold on
% plot(qinE1(:,2),'r')
