% fc = flight condition, contains:
% rho - air density
% V   - air speed
% p   - air pressure
function [out]=parseAVL(filename,fc)

fid = fopen(filename);
elements = [];
while ~feof(fid)
    line = fgetl(fid);
    %disp(line);
    if isempty(line)
        continue;
    elseif strfind(line,'Strip Dihed') % get strip dihedral
        stpDi = strsplit(line,'Strip Dihed. =');
        stpDi = textscan(stpDi{2},'%f');
        stpDi = cell2mat(stpDi);
    elseif strfind(line,'cl') % get strip lift coefficient 
        stpCl = strsplit(line,'cl  =');
        stpCl = textscan(stpCl{2},'%f');
        stpCl = cell2mat(stpCl);        
    elseif strfind(line,'Strip Width') % get strip width
        stpW = strsplit(line,'Strip Width  =');
        stpW = textscan(stpW{2},'%f');
        stpW = cell2mat(stpW);
    end
    data = textscan(line, '%f %f %f %f %f %f %f');
    if ~isempty(data{1})
        elements = [elements; data stpDi stpCl stpW];
    end    
end
data = cell2mat(elements(:,2:end));
n = length(data);
pos = data(:,1:3);
dx = data(:,4);
dy = data(:,9);
area = dx.*dy;
normal = zeros(length(data(:,1)),3);
for i = 1:length(normal(:,1))
    th = -data(i,7); %dihedral
    R = [1,0,0;0,cosd(th),sind(th);0,-sind(th),cosd(th)];
    normal(i,:) = (R*[0 0 1]')';
    th = atand(data(i,5)); %slope
    R = [cosd(th),0,-sind(th);0,1,0;sind(th),0,cosd(th)];
    normal(i,:) = (R*normal(i,:)')';
end
%normal = [zeros(n,1) zeros(n,1), ones(n,1)];
%normal = [-data(:,5), -tan(data(:,7)),ones(n,1)]./repmat((sqrt(data(:,5).^2 + tan(data(:,7)).^2 + 1)),1,3);
dCp = data(:,6);
force = repmat((0.5*fc.rho*fc.V^2*dCp + fc.rho).*area,1,3).*normal;
out = struct('position',pos,'area',area,'normal',normal,'force',force,'dx',dx,'dy',dy);
%out(:,6) = out(:,6)*0.5*fc.rho*fc.V^2 + fc.p;
fclose(fid);