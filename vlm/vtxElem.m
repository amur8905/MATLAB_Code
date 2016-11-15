function [up,upi] = vtxElem(p1,p2,p3,p4,rp,gamma,visc,t,ti)

%% function VTXELEM() is used to calculate the velocity due to a vortex ring
%       This function calculates the induced velocity due to a vortex ring
%       made up of vortex line elements, the vortex line elements are
%       calculated using the Lamb vortex model which uses a Gaussian
%       profile to emulate the vortex core. The vortex core is calculated
%       within the code based on the kinematic viscosity and time.
%
%       Inputs:
%       rp(3)   = [xp, yp, zp]      reference point
%       pi(3)   = [x1, y1, z1]      clockwise points defining vortex ring, i = 1:4
%       gamma                       circulation constant
%       visc                        kinematic viscosity
%       t                           current time step
%       ti                          initial time of shedding
%
%       Outputs:
%       up(3)   = [u,v,w]           total local induced velocities
%       upi(3)  = [u,v,w]_i         parallel vortex line velocities (note
%                                       only used for drag calculations)
%
%   Author: J. A. Geoghegan
%   Created: 08/09/2016
%   Modifiations:
%       -
%% 
if nargin < 7
    visc = 100;
    t = 0;
    ti = 0;
    rc = 1e-6;
else
    alfaL = 1.25643;
    a1    = 5e-5;
    delta = 1 + a1*gamma/visc;
    rc = sqrt(4*alfaL*visc*delta*(t-ti));
end
up = zeros(3,1);
up1 = zeros(3,1);
up2 = zeros(3,1);
up3 = zeros(3,1);
up4 = zeros(3,1);

% velocity equation: 
% V(x,y,z) = gamma/4*pi * ((|r1| + |r2|)*(|r1|*|r2| -
% r1.r2)/(|r1|*|r2|*(|r1xr2|^2 + |r2-r1|^2*rc^2)))*(r1xr2)

% Produce vectors from points
r1 = rp-p1; r2 = rp-p2; r3 = rp-p3; r4 = rp-p4; 
r12 = p2-p1; r23 = p3-p2; r34 = p4-p3; r41 = p1-p4;

% calculate distances for each vector
absr1   = sqrt(r1(1)^2+r1(2)^2+r1(3)^2); % s.a. |r1|
absr2   = sqrt(r2(1)^2+r2(2)^2+r2(3)^2); % s.a  |r2|
absr3   = sqrt(r3(1)^2+r3(2)^2+r3(3)^2); % s.a. |r3|
absr4   = sqrt(r4(1)^2+r4(2)^2+r4(3)^2); % s.a  |r4|

% lengths of each line element
absr1r2 = sqrt(r12(1)^2+r12(2)^2+r12(3)^2); %  s.a. |r2-r1|
absr2r3 = sqrt(r23(1)^2+r23(2)^2+r23(3)^2); %  s.a. |r3-r2|
absr3r4 = sqrt(r34(1)^2+r34(2)^2+r34(3)^2); %  s.a. |r4-r3|
absr4r1 = sqrt(r41(1)^2+r41(2)^2+r41(3)^2); %  s.a. |r1-r4|

% cross product of each line points
crossr1r2 = [(r1(2)*r2(3)-r1(3)*r2(2)); (r1(3)*r2(1)-r1(1)*r2(3));...
            (r1(1)*r2(2)-r1(2)*r2(1))]; % s.a. r1xr2
crossr2r3 = [(r2(2)*r3(3)-r2(3)*r3(2)); (r2(3)*r3(1)-r2(1)*r3(3));...
            (r2(1)*r3(2)-r2(2)*r3(1))]; % s.a. r2xr3
crossr3r4 = [(r3(2)*r4(3)-r3(3)*r4(2)); (r3(3)*r4(1)-r3(1)*r4(3));...
            (r3(1)*r4(2)-r3(2)*r4(1))]; % s.a. r3xr4
crossr4r1 = [(r4(2)*r1(3)-r4(3)*r1(2)); (r4(3)*r1(1)-r4(1)*r1(3));...
            (r4(1)*r1(2)-r4(2)*r1(1))]; % s.a. r4xr1

% length of the line cross product
abscrossr1r2 = sqrt(crossr1r2(1)^2+crossr1r2(2)^2+crossr1r2(3)^2); % s.a. |r1xr2|
abscrossr2r3 = sqrt(crossr2r3(1)^2+crossr2r3(2)^2+crossr2r3(3)^2); % s.a. |r2xr3|
abscrossr3r4 = sqrt(crossr3r4(1)^2+crossr3r4(2)^2+crossr3r4(3)^2); % s.a. |r3xr4|
abscrossr4r1 = sqrt(crossr4r1(1)^2+crossr4r1(2)^2+crossr4r1(3)^2); % s.a. |r4xr1|

% dot product of each line element
dotr1r2 = r1(1)*r2(1) + r1(2)*r2(2) + r1(3)*r2(3); % s.a. r1.r2
dotr2r3 = r2(1)*r3(1) + r2(2)*r3(2) + r2(3)*r3(3); % s.a. r2.r3
dotr3r4 = r3(1)*r4(1) + r3(2)*r4(2) + r3(3)*r4(3); % s.a. r3.r4
dotr4r1 = r4(1)*r1(1) + r4(2)*r1(2) + r4(3)*r1(3); % s.a. r4.r1

% line kernal
K12     = ((absr1 + absr2)*(absr1*absr2 - dotr1r2))/...
            ( absr1*absr2*(abscrossr1r2^2 + (absr1r2^2)*rc^2) );
K23     = ((absr2 + absr3)*(absr2*absr3 - dotr2r3))/...
            ( absr2*absr3*(abscrossr2r3^2 + (absr2r3^2)*rc^2) );
K34     = ((absr3 + absr4)*(absr3*absr4 - dotr3r4))/...
            ( absr3*absr4*(abscrossr3r4^2 + (absr3r4^2)*rc^2) );
K41     = ((absr4 + absr1)*(absr4*absr1 - dotr4r1))/...
            ( absr4*absr1*(abscrossr4r1^2 + (absr4r1^2)*rc^2) );
        


up1     = gamma/4/pi*K12*crossr1r2;
up2     = gamma/4/pi*K23*crossr2r3;
up3     = gamma/4/pi*K34*crossr3r4;
up4     = gamma/4/pi*K41*crossr4r1;

if absr1r2 == 0
    up1 = 0;
elseif absr2r3 == 0
    up2 = 0;
elseif absr3r4 == 0
    up3 = 0;
elseif absr4r1 == 0
    up4 = 0;
end
up      = up1+up2+up3+up4;
upi     = up2+up4;

return