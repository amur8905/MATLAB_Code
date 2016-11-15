function [data] = airfoilReader(filename, ib, dist,plotOn)
% AIRFOILREADER     reads airfoil coordinate files
%   AIRFOILREADER is a function used to interpret and interpolate airfoil
%   data points and returns the necessary camber points given a dimension.
% 
%   [data] = airfoilReader(filename,ib,dist,plotOn), where the filename is
%   the .dat filename string containing the data coordinates. NOTE: the
%   .dat file must be checked to ensure the data is in the right format.
%
%   The required format is;
%       #Name
%       x/c     y/c
%       TE upper surface
%           ...
%       LE upper surface
%       LE lower surface
%           ...
%       TE lower surface
% 
%   ib refers to the number of panels required for the solver, dist should
%   be a string input, either 'cosine' or 'linear' are accepted inputs,
%   plotOn is a 1/0 variable which will plot the loaded data coordinates
%   with the interpolated camberline over the top. The output data is a
%   structure which contains the camberline data points under the fields xc
%   and yc.

% Read file data
root = [cd,'/airfoils/'];
fid         = fopen([root,filename,'.dat'],'r');
datacell    = textscan(fid, '%f%f', 'HeaderLines', 1);
fclose(fid);
% set buffer coordinates as loaded data
buffer.x      = datacell{1}; buffer.y = datacell{2};

% Edit Data;
% Remove irrelevant entry (often found from UIUC, AirfoilTools)
if buffer.x(1) > 1
    buffer.x(1) = []; buffer.y(1) = [];
end
% Flip Data to standard form
if buffer.x(1) == 0
    var1 = find(buffer.x == 1.0);
    buffer.x = [flipud(buffer.x(1:var1(1)));buffer.x(var1(1)+1:end)];
    buffer.y = [flipud(buffer.y(1:var1(1)));buffer.y(var1(1)+1:end)];
    var2 = find(buffer.x == 0.0);
    buffer.x(var2(2)) = [];
    buffer.y(var2(2)) = [];
end

% Determine x-distribution
switch dist
    case 'linear'
        xc      = linspace(0,1,ib)';
        a       = 1/floor(ib/2);
        x       = [1:-a:0, a:a:1]';      
    case 'cosine'
        theta1  = linspace(0,pi,ib)';
        xc      = 1/2 * (1 - cos(theta1));
        if rem(ib,2) == 0       % checks if even number of panels. This is not allowed for 3D wrapping
            ib = ib + 1;
        end
        theta2  = linspace(0,2*pi,ib)';
        x       = 1/2 *( cos(theta2) + 1);
end

data.xupper = x(1:ceil(ib/2)); data.xlower = x(ceil(ib/2):end);

% y-point interpolation
% note all upper and lower coordinate systems will read from trailing edge
% to leading edge.
ind = find(buffer.x == 0);
buffer.xupper = buffer.x(1:ind); buffer.yupper = buffer.y(1:ind);
buffer.xlower = buffer.x(ind:end); buffer.ylower = buffer.y(ind:end);

data.yupper = interp1(buffer.xupper,buffer.yupper,data.xupper);
data.ylower = interp1(buffer.xlower,buffer.ylower,data.xlower);

%buffer.xc   = flipud(buffer.xupper);

% reshape buffer y values such that camber line definition can be
% satisfied, this is necessary when there exists a larger number of points
% on either the upper or lower surface.
num         = size(buffer.xupper,1);
tempx       = linspace(0,1,num);
buffer.xc   = tempx;
tempyu      = interp1(buffer.xupper,buffer.yupper,tempx);
tempyl      = interp1(buffer.xlower,buffer.ylower,tempx);

buffer.yc   = (tempyu-abs(tempyl))/2;

data.xc     = xc;
data.yc     = interp1(buffer.xc,buffer.yc,data.xc);

% Plot results
if plotOn == 1;
    plot(buffer.x,buffer.y,'-k')
    hold on; grid on;
    %plot([data.xupper;data.xlower],[data.yupper;data.ylower],'ob')
    plot(buffer.xc,buffer.yc,'-.k')
    plot(data.xc,data.yc,'ob')
    axis equal;
    xlabel 'Chord (x)'; ylabel 'Thickness (y)'; title(filename(1:end-4))
    legend ('Orig. Coordinates', 'Orig. Camber', 'Interp. Camber')
end
return
