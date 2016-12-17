function [f,q,qdot,qddot,A] = armPlanar(x,ff,Fs,N)
%% Set constants
%ff = Fundamental frequency
%Fs = Sample frequency
%Ni = Number of frequencies in Fourier series

wf = 2*pi*ff;           %Fundamental pulsation
M = Fs/ff;              %Number samples in one fundamental period
g = 9.81;               %gravity constant

ind_var = 5;            %Number of paramters to be estimated

n = 2;                  %Number of joints

%% Initialize vectors/matrices
q = zeros(M,n);
qdot = zeros(M,n);
qddot = zeros(M,n);
A = zeros(M*n,ind_var);

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
    end
    A(k+(n-1)*(k-1):k*n,:) = [qddot(k,1), cos(q(k,2))*(2*qddot(k,1)+qddot(k,2))-sin(q(k,2))*(qdot(k,1)^2+2*qdot(k,1)*qdot(k,2)), qddot(k,2), g*cos(q(k,1)), g*cos(q(k,1)+q(k,2));
        0, cos(q(k,2))*qddot(k,1)+sin(q(k,2))*qdot(k,1)^2, qddot(k,1)+qddot(k,2), 0, g*cos(q(k,1)+q(k,2))]; %Add regressor matrix into matrix
end
for ii = 1:ind_var      %Loop over columns in A
    A(:,ii) = A(:,ii)./norm(A(:,ii),2);    %Normalize columns in A
end
f = cond(A,2);            %Calculate condition number of A
end