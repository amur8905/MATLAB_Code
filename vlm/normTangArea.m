function [out] = normTangArea(panel)
% NORMALVEC     calculates normal and tangential vectors
%   NORMALVEC takes a surface defined by a grid and calculates each panel
%   normal vector and chord-wise / span-wise tangential vectors. These
%   vectors are necessary to describe the flow conditions on the given
%   surface. The panel area is also given as a by-product of the
%   calculation of the normal vector.
%
%   [NV,S,taui,tauj] = normalVec(QF) where QF is the surface mesh, which
%   must have at least 2 chordwise dimensions and is given as QF(i,j,3)
%   such that the 3rd dimesion refers to the x, y & z coordinates. NV is
%   the panel normal using the same convention, S panel area, and taui/tauj
%   are the chord/span tangents respectively.

% Calculate dimensions of surface mesh
NV = zeros(3,panel.N*panel.M);
out = panel;
out.area = zeros(1,panel.NM);

% Calculating normal vector:
for i = 1:panel.NM % chord-wise panel counter
        % calculate panel diagonal vectors A,B
        A = [panel.rf3(:,i)-panel.rf1(:,i)];
        B = -[panel.rf4(:,i)-panel.rf2(:,i)];       
        % find diagonal vector cross product
        prod = cross(A,B);      
        % Vector Magnitude
        M = norm(prod);
        
        % Panel Normal
        NV(1,i) = prod(1)/M;
        NV(2,i) = prod(2)/M;
        NV(3,i) = prod(3)/M;
        
        % Panel Area - Herons Formula
        a = sqrt(sum((panel.rf2(:,i)-panel.rf1(:,i)).^2));
        b = sqrt(sum((panel.rf3(:,i)-panel.rf2(:,i)).^2));
        c = sqrt(sum((panel.rf1(:,i)-panel.rf3(:,i)).^2));
        d = sqrt(sum((panel.rf4(:,i)-panel.rf3(:,i)).^2));
        e = sqrt(sum((panel.rf1(:,i)-panel.rf4(:,i)).^2));
        
        s1 = (a+b+c)/2;
        s2 = (d+e+c)/2;
        
        A = sqrt(s1*(s1-a)*(s1-b)*(s1-c));
        out.area(i) = A + sqrt(s2*(s2-d)*(s2-e)*(s2-c));
end
out.normal = NV;


%% Calculate tangential vectors
temprcx = reshape(panel.rc(1,:),panel.M,panel.N)';
temprcy = reshape(panel.rc(2,:),panel.M,panel.N)';
temprcz = reshape(panel.rc(3,:),panel.M,panel.N)';

% create a ghost cell that extrapolates from the last two cells
ghostix = temprcx(end,:) + (temprcx(end,:)-temprcx(end-1,:));
temprcx = [temprcx;ghostix];
ghostiy = temprcy(end,:) + (temprcy(end,:)-temprcy(end-1,:));
temprcy = [temprcy;ghostiy];
ghostiz = temprcz(end,:) + (temprcz(end,:)-temprcz(end-1,:));
temprcz = [temprcz;ghostiz];
ghostjx = temprcx(:,end) + (temprcx(:,end)-temprcx(:,end-1));
temprcx = [temprcx,ghostjx];
ghostjy = temprcy(:,end) + (temprcy(:,end)-temprcy(:,end-1));
temprcy = [temprcy,ghostjy];
ghostjz = temprcz(:,end) + (temprcz(:,end)-temprcz(:,end-1));
temprcz = [temprcz,ghostjz];


tempix = temprcx(2:end,1:end-1)-temprcx(1:end-1,1:end-1);
tempiy = temprcy(2:end,1:end-1)-temprcy(1:end-1,1:end-1);
tempiz = temprcz(2:end,1:end-1)-temprcz(1:end-1,1:end-1);
dtempi = (tempix.^2+tempiy.^2+tempiz.^2).^(0.5);

tempjx = temprcx(1:end-1,2:end)-temprcx(1:end-1,1:end-1);
tempjy = temprcy(1:end-1,2:end)-temprcy(1:end-1,1:end-1);
tempjz = temprcz(1:end-1,2:end)-temprcz(1:end-1,1:end-1);
dtempj = (tempjx.^2+tempjy.^2+tempjz.^2).^(0.5);

out.taui(1,:) = reshape((tempix./dtempi)',1,panel.NM);
out.taui(2,:) = reshape((tempiy./dtempi)',1,panel.NM);
out.taui(3,:) = reshape((tempiz./dtempi)',1,panel.NM);

out.tauj(1,:) = reshape((tempjx./dtempj)',1,panel.NM);
out.tauj(2,:) = reshape((tempjy./dtempj)',1,panel.NM);
out.tauj(3,:) = reshape((tempjz./dtempj)',1,panel.NM);


return