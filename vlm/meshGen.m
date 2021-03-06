function [out] = meshGen(in)

%% function MESHGEN() is used to calculate wing grid, panel mesh, properties
%       This function is used to create the wing mesh to be read into the
%       unsteady/steady vlm solver using the input variables specified in
%       the inputVar script.
%
%       Inputs:
%       - geom, aero        structures generated by the inputVars script
%      
%       Outputs:
%       - geom              geom structure returned with the wing geometry
%       and basic mesh under the subfield "mesh"
%
%   Author: J. A. Geoghegan
%   Created: 08/09/2016
%   Modifiations:
%       -
%% 

%% Preset the Output structure
out = in;

%% Build Wing Coordinates
% Define panels index
i = in.ip + 1; % chord points
j = in.jp + 1; % span points

% Define camber profiles
[~,ok] = str2num(in.airfoil); %#ok<*ST2NM>
if ok == 0
    data = airfoilReader(in.airfoil,i,in.chordDist,0);
    xc = data.xc;
    zc = data.yc;
elseif ok == 1
    data = naca(in.airfoil,i,in.chordDist);
    xc = data.xc;
    zc = data.yc;
    xfull = [flipud(data.x.upper(2:end));data.x.lower];
    zfull = [flipud(data.y.upper(2:end));data.y.lower];
end

% Define y-axis point distribution
switch in.spanDist
    case 'linear'
        % create basis spanwise vector
        yle     = linspace(0,in.span,j);
    case 'sine'
        theta = linspace(0,pi/2,j);
        yle     = in.span*sin(theta);
    case 'cosine'
        theta = linspace(0,pi,j);
        yle     = 1/2*(1-cos(theta))*in.span;
end

% Build wing frame
xle = yle*tand(in.sweep);
ct = in.chordRoot*in.taper;
xte = [in.chordRoot, xle(end)+ct];

sweepTE = atan((xte(end)-xte(1))/in.span);
xte = yle*tan(sweepTE) + in.chordRoot;
chord = xte-xle;

% Build full wing
Xt = xc*chord + repmat(xle,i,1);
Yt = repmat(yle,i,1);
Zt = zc*chord;

% Rotate Wing for Dihedral Effects / Wing Orientation
phi = in.dihed*pi/180;
X = Xt;
Y = [Yt(:,1), cos(phi)*Yt(:,2:end) - sin(phi)*Zt(:,2:end)];
Z = [Zt(:,1), sin(phi)*Yt(:,2:end) + cos(phi)*Zt(:,2:end)];

out.mesh.camberx = X;
out.mesh.cambery = Y;
out.mesh.camberz = Z;

% if in.thickness == 0
%     out.te.x = out.mesh.camberx(end,:);
%     out.te.z = out.mesh.camberz(end,:);
% end

if in.thickness == 1
    % Build full wing
    Xt = xfull*chord + repmat(xle,2*i-1,1);
    Yt = repmat(yle,2*i-1,1);
    Zt = zfull*chord;

    % Rotate Wing for Dihedral Effects / Wing Orientation
    phi = in.dihed*pi/180;
    X = Xt;
    Y = [Yt(:,1), cos(phi)*Yt(:,2:end) - sin(phi)*Zt(:,2:end)];
    Z = [Zt(:,1), sin(phi)*Yt(:,2:end) + cos(phi)*Zt(:,2:end)];

    out.mesh.fullx = X;
    out.mesh.fully = Y;
    out.mesh.fullz = Z;
    
    if out.mesh.fullx(1,:) == out.mesh.fullz(end,:)
        out.te.gap = 0;
        out.te.x   = out.mesh.fullx(1,:);
        out.te.z   = out.mesh.fullz(1,:);
    elseif out.mesh.fullx(1,:) ~= out.mesh.fullz(end,:)
        out.te.gap = abs((out.mesh.fullz(1,:) - out.mesh.fullz(end,:))/2);
        out.te.x    = (out.mesh.fullx(1,:)+out.mesh.fullx(end,:))/2;
        out.te.z    = out.mesh.fullz(end,:) + out.te.gap;
    end
end

%% Calculate the colocation and filament points

% Filament points depend on plate wing or full wing
if in.thickness == 1
    
    out.mesh.midx = (out.mesh.fullx(1:end-1,1:end-1)+out.mesh.fullx(2:end,1:end-1)+...
            out.mesh.fullx(1:end-1,2:end)+out.mesh.fullx(2:end,2:end))/4;
    out.mesh.midy = (out.mesh.fully(1:end-1,1:end-1)+out.mesh.fully(2:end,1:end-1)+...
            out.mesh.fully(1:end-1,2:end)+out.mesh.fully(2:end,2:end))/4;
    out.mesh.midz = (out.mesh.fullz(1:end-1,1:end-1)+out.mesh.fullz(2:end,1:end-1)...
            +out.mesh.fullz(1:end-1,2:end)+out.mesh.fullz(2:end,2:end))/4;
    
elseif in.thickness == 0
    
    out.mesh.midx = (out.mesh.camberx(1:end-1,1:end-1)+out.mesh.camberx(2:end,1:end-1)+...
            out.mesh.camberx(1:end-1,2:end)+out.mesh.camberx(2:end,2:end))/4;
    out.mesh.midy = (out.mesh.cambery(1:end-1,1:end-1)+out.mesh.cambery(2:end,1:end-1)+...
            out.mesh.cambery(1:end-1,2:end)+out.mesh.cambery(2:end,2:end))/4;
    out.mesh.midz = (out.mesh.camberz(1:end-1,1:end-1)+out.mesh.camberz(2:end,1:end-1)...
            +out.mesh.camberz(1:end-1,2:end)+out.mesh.camberz(2:end,2:end))/4;

end
return 
