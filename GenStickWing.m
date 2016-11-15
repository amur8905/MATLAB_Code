function D = GenStickWing(stationDef, side, stabOffset)
%station def is n*4 where [x,y,z,num of elems to next station]
sD = stationDef;
span = abs(sD(1,2)-sD(end,2));
% m  1*1  total number of members
m = sum(sD(:,4));

% n  1*1  total number of nodes
n = sum(sD(:,4))+1;

% Coord  n*3  coordinate of nodes
%   columns 1:3 X,Y,Z of coordinates
Coord = zeros(n,3);
Coord(1,1) = sD(1,1);
Coord(1,2) = sD(1,2);
Coord(1,3) = sD(1,3);
ctr = 2;
for s = 1:length(sD(:,1)-1)
    for i = 1:sD(s,4)
        f1 = (sD(s,4)-i)/sD(s,4);
        f2 = i/sD(s,4);
        Coord(ctr,1) = f1*sD(s,1) + f2*sD(s+1,1);
        Coord(ctr,2) = f1*sD(s,2) + f2*sD(s+1,2);
        Coord(ctr,3) = f1*sD(s,3) + f2*sD(s+1,3);        
        ctr = ctr + 1;
    end
end
Coord = [Coord; sD(1,1)+3*stabOffset sD(1,2) sD(1,3)];
Coord = [Coord; sD(1,1)-stabOffset sD(1,2) sD(1,3)];
Coord = [Coord; sD(1,1) sD(1,2) sD(1,3)+stabOffset/2];
Coord = [Coord; sD(1,1) sD(1,2) sD(1,3)-stabOffset/2];

% Con  m*4  connectivity & release
%   column 1 beginning node
%   column 2 end node
%   column 3 indicates if a member is released(=0) or not(=1) at its beginning
%   column 4 indicates if a member is released(=0) or not(=1) at its end
%   ***Note: for trusses Con(:,3:4)=0***
Con = zeros(m,4);
for i = 1:m
    Con(i,1) = i;
    Con(i,2) = i+1;
    Con(i,3) = 1;
    Con(i,4) = 1;
end
m = m+4;
n = n+4;
Con = [Con; 1 n 1 1; 1 n-1 1 1; 1 n-2 1 1; 1 n-3 1 1];

% Re  n*6  degrees of freedom for each node (free=0 & fixed=1)
%   columns 1:3 flag indicating displacement in global X,Y,Z directions
%   columns 4:6 flag indicating rotation about global X,Y,Z axes
%   ***Note: for 2-D structures Re(:,3:5)=1***
Re = zeros(n,6);
Re(1,1:6) = 1;
for i = 2:n-4
    Re(i,1:3) = 0;
    Re(i,4:6) = 0;
end
Re(n,1:6) = 1;
Re(n-1,1:6) = 1;
Re(n-2,1:6) = 1;
Re(n-3,1:6) = 1;


% Load  n*6  concentrated loads on nodes
%   columns 1:3  forces in global X,Y,Z direction
%   columns 4:6  moments about global X,Y,Z axes
Load  = zeros(n,6);

% w  m*3  uniform loads in local coordinate system
%   columns 1:3 x,y,z component of w
w = zeros(m,3);

% E  1*m  material elastic modulus
E = ones(1,m)*69e9; 

% G  1*m  shear elastic modulus
G = ones(1,m)*26e9;

% A  1*m  cross sectional area
A = ones(1,m)*side^2;

% Iz  1*m  moment of inertia about its local z-z axis
Iz = ones(1,m)*1/12*(side^2 + (span/m)^2);

% Iy  1*m  moment of inertia about its local y-y axis
Iy = ones(1,m)*1/12*(side^2 + side^2);

% J  1*m  torsional constant
J = ones(1,m)*2.25*(side/2)^4;

% St  n*6  settlement of supports & displacements of free nodes
%   columns 1:3 flag indicating displacement in global X,Y,Z directions
%   columns 4:6 flag indicating rotation about global X,Y,Z axes
St = zeros(n,6);

% be  1*m  web rotation angle
%   ***Note: the angle assumes a counterclockwise convention about the local x-axis (in radians)***
be = zeros(1,m);

% assemble structure
D = struct('m',m,'n',n,'Coord',Coord','Con',Con','Re',Re','Load',Load',...
            'w',w','E',E','G',G','A',A','Iz',Iz','Iy',Iy','J',J','St',St','be',be');