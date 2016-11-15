function D = GenBeamWing(stationDef, t)
%station def is n*4 where [x,y,z,num of elems to next station,side]
sD = stationDef;
numSquares = sum(sD(:,4))+1;
span = abs(sD(1,2)-sD(end,2));
% m  1*1  total number of members
m = 18*(numSquares-1)+6;

% n  1*1  total number of nodes
n = 4*numSquares;

% Coord  n*3  coordinate of nodes
%   columns 1:3 X,Y,Z of coordinates
Coord = zeros(n,3);
x = sD(1,1);
y = sD(1,2);
z = sD(1,3);
d = sD(1,5)/2;
Coord(1,1) = x + d;
Coord(1,2) = y;
Coord(1,3) = z + d;
Coord(2,1) = x - d;
Coord(2,2) = y;
Coord(2,3) = z + d;
Coord(3,1) = x - d;
Coord(3,2) = y;
Coord(3,3) = z - d;
Coord(4,1) = x + d;
Coord(4,2) = y;
Coord(4,3) = z - d;
ctr = 5;
for s = 1:length(sD(:,1)-1)
    for i = 1:sD(s,4)
        f1 = (sD(s,4)-i)/sD(s,4);
        f2 = i/sD(s,4);
        x = f1*sD(s,1) + f2*sD(s+1,1);
        y = f1*sD(s,2) + f2*sD(s+1,2);
        z = f1*sD(s,3) + f2*sD(s+1,3);        
        d = (f1*sD(s,5) + f2*sD(s+1,5))/2;
        Coord(ctr,1) = x + d;
        Coord(ctr,2) = y;
        Coord(ctr,3) = z + d;
        Coord(ctr+1,1) = x - d;
        Coord(ctr+1,2) = y;
        Coord(ctr+1,3) = z + d;
        Coord(ctr+2,1) = x - d;
        Coord(ctr+2,2) = y;
        Coord(ctr+2,3) = z - d;
        Coord(ctr+3,1) = x + d;
        Coord(ctr+3,2) = y;
        Coord(ctr+3,3) = z - d;        
        ctr = ctr + 4;
    end
    
end

% Con  m*4  connectivity & release
%   column 1 beginning node
%   column 2 end node
%   column 3 indicates if a member is released(=0) or not(=1) at its beginning
%   column 4 indicates if a member is released(=0) or not(=1) at its end
%   ***Note: for trusses Con(:,3:4)=0***
Con = zeros(m,4);
for i = 1:numSquares-1
    %box ends
    Con(18*i-17,1) = 4*i-3;
    Con(18*i-17,2) = 4*i-2;
    Con(18*i-16,1) = 4*i-2;
    Con(18*i-16,2) = 4*i-1;
    Con(18*i-15,1) = 4*i-1;
    Con(18*i-15,2) = 4*i;
    Con(18*i-14,1) = 4*i;
    Con(18*i-14,2) = 4*i-3;
    
    %box cross members
    Con(18*i-13,1) = 4*i-3;
    Con(18*i-13,2) = 4*i-1;
    Con(18*i-12,1) = 4*i-2;
    Con(18*i-12,2) = 4*i;
    
    %lengths
    Con(18*i-11,1) = 4*i-3;
    Con(18*i-11,2) = 4*(i+1)-3;
    Con(18*i-10,1) = 4*i-2;
    Con(18*i-10,2) = 4*(i+1)-2;
    Con(18*i-9,1) = 4*i-1;
    Con(18*i-9,2) = 4*(i+1)-1;
    Con(18*i-8,1) = 4*i;
    Con(18*i-8,2) = 4*(i+1);
    
    %length cross members
    Con(18*i-7,1) = 4*i-3;
    Con(18*i-7,2) = 4*(i+1)-2;
    Con(18*i-6,1) = 4*i-2;
    Con(18*i-6,2) = 4*(i+1)-3;
    Con(18*i-5,1) = 4*i-2;
    Con(18*i-5,2) = 4*(i+1)-1;
    Con(18*i-4,1) = 4*i-1;
    Con(18*i-4,2) = 4*(i+1)-2;    
    Con(18*i-3,1) = 4*i-1;
    Con(18*i-3,2) = 4*(i+1);
    Con(18*i-2,1) = 4*i;
    Con(18*i-2,2) = 4*(i+1)-1;
    Con(18*i-1,1) = 4*i;
    Con(18*i-1,2) = 4*(i+1)-3;
    Con(18*i,1) = 4*i-3;
    Con(18*i,2) = 4*(i+1);
end
Con((numSquares-1)*18 + 1,1) = 4*numSquares-3;
Con((numSquares-1)*18 + 1,2) = 4*numSquares-2;
Con((numSquares-1)*18 + 2,1) = 4*numSquares-2;
Con((numSquares-1)*18 + 2,2) = 4*numSquares-1;
Con((numSquares-1)*18 + 3,1) = 4*numSquares-1;
Con((numSquares-1)*18 + 3,2) = 4*numSquares;
Con((numSquares-1)*18 + 4,1) = 4*numSquares;
Con((numSquares-1)*18 + 4,2) = 4*numSquares-3;
Con((numSquares-1)*18 + 5,1) = 4*numSquares-3;
Con((numSquares-1)*18 + 5,2) = 4*numSquares-1;
Con((numSquares-1)*18 + 6,1) = 4*numSquares-2;
Con((numSquares-1)*18 + 6,2) = 4*numSquares;


% Re  n*6  degrees of freedom for each node (free=0 & fixed=1)
%   columns 1:3 flag indicating displacement in global X,Y,Z directions
%   columns 4:6 flag indicating rotation about global X,Y,Z axes
%   ***Note: for 2-D structures Re(:,3:5)=1***
Re = zeros(n,6);
Re(1:4,1:6) = 1;

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
A = ones(1,m)*t^2;

% Iz  1*m  moment of inertia about its local z-z axis
Iz = ones(1,m)*1/12*(t^2 + (span/(numSquares-1))^2);

% Iy  1*m  moment of inertia about its local y-y axis
Iy = ones(1,m)*1/12*(t^2 + t^2);

% J  1*m  torsional constant
J = ones(1,m)*2.25*(t/2)^4;

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