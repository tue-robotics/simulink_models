clear all; close all; clc

Fs = 1000;
Ts = 1/Fs;


% %% Encoder counts & Gear ratios
% CPT_w1 = 512;
% planet_w1 = 15/4;
% GR_w1 = planet_w1

% CPT_w2 = 512;
% planet_w2 = 15/4;
% GR_w2 = planet_w2

%% PID gains
Kc_w1 = 0.0;
Kd_w1 = 0.0;
Ki_w1 = 0.0;
ilim_w1 = 1.0;

Kc_w2 = 0.0;
Kd_w2 = 0.0;
Ki_w2 = 0.0;
ilim_w2 = 1.0;

s1min = -129;
s1max = 195;
s1minabs = 1217;
s1maxabs = 2374;
abs2deg_s1 = (s1max-s1min)/(s1maxabs-s1minabs)

s2min = -5.7;
s2max = 178.3;
s2minabs = 395;
s2maxabs = 3420;
abs2deg_s2 = (s2max-s2min)/(s2maxabs-s2minabs)

Kv_w = 0.0244;
R_w = 9.02;

%% Controller
P = 15.0; I = 5.0;
C = P+tf([I],[1 0]);
%C = c2d(C,1/20e3);

%LP filter
Rf = 1e3;
Cf = 10e-9;
LP = tf(1,[Rf*Cf 1]);

%% Model Plant
R = R_w;
L = 0.406e-3;
Kt = 24.4e-3;
J = 4.27e-7;
b = 1e-4;

FP = logspace(-2,4,1000);
% Pl = tf([1],[L R]);
Pl = tf([J b],[L*J (L*b+R*J) (R*b+Kt^2)]);
Pl1 = freqresp(Pl*LP,FP,'Hz');
Pl1 = Pl1(:);

magPl = mag2db(abs(Pl1));
phasePl = angle(Pl1)*360/(2*pi);

CL = freqresp(Pl*LP*C,FP,'Hz');
CL = CL(:);
magCL = mag2db(abs(CL));
phaseCL = angle(CL)*360/(2*pi);

%Delay
a = tf(1,1,'InputDelay',1/20e3);
Pa = freqresp(a,FP,'Hz');
phasedelay = angle(Pa(:))*360/(2*pi);

figure
subplot(2,1,1)
semilogx(FP,magPl)
grid on
subplot(2,1,2)
semilogx(FP,phasePl+phasedelay)
grid on

figure
subplot(2,1,1)
semilogx(FP,magCL)
grid on
subplot(2,1,2)
semilogx(FP,phaseCL+phasedelay)
grid on




