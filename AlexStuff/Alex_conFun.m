function [c,ceq] = conFun(x,ff,Fs,N,qmax,qmin,qdotmax,qddotmax)
%% Set constants
%ff = Fundamental frequency
%Fs = Sample frequency
%Ni = Number of frequencies in Fourier series

wf = 2*pi*ff;           %Fundamental pulsation
M = Fs/ff;              %Number samples in one fundamental period

qdotmin = -qdotmax;
qddotmin = -qddotmax;

n = 2;
%% Initialize vectors/matrices
q = zeros(M,n);
qdot = zeros(M,n);
qddot = zeros(M,n);

q0 = zeros(1,n);
a = zeros(n*N(1)/2,n);
b = zeros(n*N(1)/2,n);

%% Retrieve Fourier parameters
for i = 1:n
    q0(:,i) = x(1+(2*N(i)+1)*(i-1));     %Configuration around which excitation occurs
    a(:,i) = x(2+(2*N(i)+1)*(i-1):N(i)+1+(2*N(i)+1)*(i-1)); %Amplitudes of sines in Fourier series
    b(:,i) = x(N(i)+2+(2*N(i)+1)*(i-1):2*N(i)+1+(2*N(i)+1)*(i-1));     %Amplitudes of cosines in Fourier series
end
%% Main loop
for k = 1:M             %loop over sample points
    t = k*1/Fs;         %set current time step
    for i = 1:n
        for l = 1:N(i)        %Loop over number of frequencies in Fourier Series
            q(k,i) = sin(wf*l*t)*a(l,i)/(wf*l)-cos(wf*l*t)*b(l,i)/(wf*l)+q(k,i); %calculate q
            qdot(k,i) = cos(wf*l*t)*a(l,i)+sin(wf*l*t)*b(l,i)+qdot(k,i);         %calculate qdot
            qddot(k,i) = -sin(wf*l*t)*a(l,i)*wf*l+cos(wf*l*t)*b(l,i)*wf*l+qddot(k,i); %calculate qddot
        end
        q(k,i) = q(k,i)+q0(i);     %Add offset
        c(1+(k-1)*12+(i-1)*6:(k-1)*12+i*6,1) = [q(k,i)-qmax(i);
            -q(k,i)+qmin(i);
            qdot(k,i)-qdotmax(i);
            -qdot(k,i)+qdotmin(i);
            qddot(k,i)-qddotmax(i);
            -qddot(k,i)+qddotmin(i)];
    end
end
ceq = [];
end