function [T,Jv,Jw,Jvc,Jwc,z,gq,M,C,P] = detT(DH,o_cm,m,gvec,I)
%% Description
% This function calculates for each joint:
% - Transformation matrices = T
% - Axis of rotation wrt the inertial frame = z
% -
%
%
% Inputs
% - DH
% - o_cm{i}, position of center of mass of link i, expressed in frame i
% - m(i), mass of link i


%%
a = DH(:,1);
alf = DH(:,2);
d = DH(:,3);
th = DH(:,4);

n = size(DH,1); %Number of joints
q = th;
%% Initialize variables
T = cell(n,1);
z = cell(n,1);
Jvc = cell(n,1); %Linear velocity Jacobian of center of mass of link i wrt base frame
Jwc = cell(n,1); %Angular velocity Jacobian of center of mass of link i wrt base frame
Jv = cell(n,1);  %Linear velocity Jacobian of frame i wrt base frame
Jw = cell(n,1);  %Angular velocity Jacobian of frame i wrt base frame
o_nc = cell(n,1);
gq = sym(zeros(n,1));
Ptemp = 0;
M = 0;
C = sym(zeros(2,2,2));

for ii = 1:n %0:n-1
    if(ii == 1)
        T{ii} = [cos(th(ii)) -sin(th(ii))*cos(alf(ii)) sin(th(ii))*sin(alf(ii)) a(ii)*cos(th(ii));
            sin(th(ii)) cos(th(ii))*cos(alf(ii)) -cos(th(ii))*sin(alf(ii)) a(ii)*sin(th(ii));
            0 sin(alf(ii)) cos(alf(ii)) d(ii);
            0 0 0 1];
        z{ii} = [0;0;1];
    else
        T{ii} = T{ii-1}*[cos(th(ii)) -sin(th(ii))*cos(alf(ii)) sin(th(ii))*sin(alf(ii)) a(ii)*cos(th(ii));
            sin(th(ii)) cos(th(ii))*cos(alf(ii)) -cos(th(ii))*sin(alf(ii)) a(ii)*sin(th(ii));
            0 sin(alf(ii)) cos(alf(ii)) d(ii);
            0 0 0 1];
        z{ii} = T{ii-1}(1:3,3);
    end
end

for jj = 1:n
    o_nc{jj} = T{jj}(1:3,4) + T{jj}(1:3,1:3)*o_cm{jj};                      %COG of link i expressed in inertial frame
    Jv{jj} = sym(zeros(3,n));
    Jw{jj} = sym(zeros(3,n));
    Jvc{jj} = sym(zeros(3,n));
    Jwc{jj} = sym(zeros(3,n));
    for kk = 1:jj
        if(kk == 1)
            Jvc{jj}(1:3,kk) = cross(z{kk},(o_nc{jj}-[0;0;0]));
            Jv{jj}(1:3,kk) = cross(z{kk},(T{jj}(1:3,4)-[0;0;0]));
        else
            Jvc{jj}(1:3,kk) = cross(z{kk},(o_nc{jj}-T{kk-1}(1:3,4)));
            Jv{jj}(1:3,kk) = cross(z{kk},(T{jj}(1:3,4)-T{kk-1}(1:3,4)));
        end
        Jwc{jj}(1:3,kk) = z{kk};
        Jw{jj}(1:3,kk) = z{kk};
    end
    Ptemp = Ptemp+m(jj)*o_nc{jj};
    M = M + m(jj)*Jvc{jj}.'*Jvc{jj}+Jwc{jj}.'*T{jj}(1:3,1:3)*I{jj}*T{jj}(1:3,1:3).'*Jwc{jj};
end
P = simplify(gvec.'*Ptemp);
M = simplify(M);
for kk = 1:n
    gq(kk) = diff(P,q(kk)); 
end
gq = simplify(gq);

for i = 1:n
    for j = 1:n
        for k = 1:n
           C(i,j,k) = (diff(M(k,j),q(i))+diff(M(k,i),q(j))-diff(M(i,j),q(k)))/2;
        end
    end
end