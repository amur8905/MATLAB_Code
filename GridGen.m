%%
clear all 
close all
%specify corners of domain, cw from top left
c1 = [-10;5];
c2 = [10;5];
c3 = [10,-5];
c4 = [-10,-5];
c1i = c1*0.2;
c2i = c2*0.2;
c3i = c3*0.2;
c4i = c4*0.2;
dx = 0.25;
dy = 0.25;

%generate points
[x1,y1] = meshgrid(c1(1):dx:c2(1),c1(2):-dy:c1i(2));
[x2,y2] = meshgrid(c2i(1):dx:c2(1),c2(2):-dy:c3(2));
[x3,y3] = meshgrid(c4(1):dx:c3(1),c4i(2):-dy:c4(2));
[x4,y4] = meshgrid(c1(1):dx:c1i(1),c1(2):-dy:c4(2));
s1 = size(x1);
s2 = size(x2);
s3 = size(x3);
s4 = size(x4);

x = [x1(:);x2(:);x3(:);x4(:)];
y = [y1(:);y2(:);y3(:);y4(:)];
[XY ixy iXY] = unique([x y],'rows');
x = XY(:,1);
y = XY(:,2);

% plot(x,y,'k.');
% axis equal

FluidPts = [];
StrucPts = [];
SurfPts = [];
for i = 1:length(x)
    if x(i) == c1(1) || x(i) == c2(1) || y(i) == c2(2) || y(i) == c3(2)
        StrucPts = [StrucPts i];
    elseif (y(i) <= c1i(2) && y(i) >= c4i(2)) && ...            
            (x(i) <= c2i(1) && x(i) >= c1i(1))            
        StrucPts = [StrucPts i];
        SurfPts = [SurfPts i ];
    else
        FluidPts = [FluidPts i];
    end
end

% sort surface points cw from top c1i
up = [];
dn = [];
lf = [];
rt = [];
for i = SurfPts
    if y(i) == c1i(2)
        up = [up;i];
    elseif y(i) == c4i(2)
        dn = [dn;i];
    elseif x(i) == c1i(1)
        lf = [lf;i];
    else
        rt = [rt;i];
    end
end
s = length(rt);
SurfPts = [rt((s+1)/2:end);flipud(up); flipud(lf); dn;rt(1:(s-1)/2)];

H = RBF_Preprocessor2D([x(StrucPts) y(StrucPts)],[x(FluidPts) y(FluidPts)],0,'Euclid',200);

perim = length(SurfPts)*dx;
t = linspace(0,1,length(SurfPts)+1);
t = t(1:end-1);


%nephroid
% t = -t*360 + 150;
% a = 0.5;
% x(SurfPts) = a*(3*cosd(t) - cosd(3*t));
% y(SurfPts) = a*(3*sind(t) - sind(3*t));

%tetracuspid
% t = -t*360 + 150;
% a = 2.5;
% x(SurfPts) = a*cosd(t).^3;
% y(SurfPts) = a*sind(t).^3;

%cassini oval
% t = -t*360 + 150;
% a = 1;
% b = 1.2*a;
% m = sqrt(b^4 - a^4 + a^4*cosd(2*t).^2) + a^2*cosd(2*t);
% x(SurfPts) = sqrt(m).*cosd(t);
% y(SurfPts) = sqrt(m).*sind(t);
% plot(x(SurfPts),y(SurfPts),'r+');

%airfoil
t = -(t*360 - 180);
a = 0.5;
x(SurfPts) = a*t.^2/3600 - 2;
y(SurfPts) = a*sind(t);
% plot(x(SurfPts),y(SurfPts),'r+');

%circle
% tstart = 135;
% t = -t*360 + tstart;
% x(SurfPts) = cosd(t);
% y(SurfPts) = sind(t);

x(FluidPts) = H*x(StrucPts);
y(FluidPts) = H*y(StrucPts);

XY = [x y];
xy = XY(iXY,:);
x1 = reshape(xy(1:length(x1(:)),1),s1);
y1 = reshape(xy(1:length(y1(:)),2),s1);
xy(1:length(x1(:)),:) = [];
x2 = reshape(xy(1:length(x2(:)),1),s2);
y2 = reshape(xy(1:length(y2(:)),2),s2);
xy(1:length(x2(:)),:) = [];
x3 = reshape(xy(1:length(x3(:)),1),s3);
y3 = reshape(xy(1:length(y3(:)),2),s3);
xy(1:length(x3(:)),:) = [];
x4 = reshape(xy(1:length(x4(:)),1),s4);
y4 = reshape(xy(1:length(y4(:)),2),s4);

figure('Position', [100, 100, 600, 300])
% plot(x,y,'k.');
hold on
axis equal
mesh(x1,y1,zeros(s1),'EdgeColor','k');
mesh(x2,y2,zeros(s2),'EdgeColor','k');
mesh(x3,y3,zeros(s3),'EdgeColor','k');
mesh(x4,y4,zeros(s4),'EdgeColor','k');
% plot(x(FluidPts),y(FluidPts),'r.');
% plot(x(StrucPts),y(StrucPts),'g.');
% plot(x(SurfPts),y(SurfPts),'b.');

%%
clear all
close all

%specify corners of domain, cc from top left
c1 = [-10;5];
c2 = [10;5];
c3 = [10,0];
c4 = [-10,0];

%generate points
X = linspace(c1(1),c2(1),50);
Y = linspace(c3(2),c1(2),25);
% Y = (fliplr([logspace(0,1,20)-1]/9))*c1(2);
[x,y] = meshgrid(X,Y);
s = size(x);
sFull = size([x;x]);

x = x(:);
y = y(:);

FoilPts = [];

for i = 1:length(x)
    if x(i) >= 0.3*c1(1) && x(i) <= 0.3*c2(1) && y(i) == c3(2)
        FoilPts = [FoilPts i];
    end
end

FluidPts = [];
StrucPts = [];
for i = 1:length(x)
    if x(i) == c1(1) || x(i) == c2(1) || y(i) == c2(2) || y(i) == c3(2)
        StrucPts = [StrucPts i];
    else 
        FluidPts = [FluidPts i];
    end
end



H = RBF_Preprocessor2D([x(StrucPts) y(StrucPts)],[x(FluidPts) y(FluidPts)],0,'C2',200);

c = x(FoilPts(end)) - x(FoilPts(1));
t = 0.12;
for i = FoilPts
%     y(i) = -0.1*x(i).^2;
    xo = x(i) - x(FoilPts(1));
    y(i) = 200*t/c*(0.2969*sqrt(xo/c) - 0.1260*(xo/c) - 0.3516*(xo/c)^2 +...
            0.2843*(xo/c)^3 - 0.1015*(xo/c)^4);
end

y(FoilPts) = y(FoilPts) - y(FoilPts(1));
y(FoilPts(end)) = 0;

x(FluidPts) = H*x(StrucPts);
y(FluidPts) = H*y(StrucPts);

xFull = [x;x];
yFull = [y;-y];
fpFull = [FoilPts FoilPts + length(x)];
spFull = [];
flFull = [];

for i = 1:length(xFull)
    if xFull(i) == c1(1) || xFull(i) == c2(1) || yFull(i) == c2(2) || yFull(i) == -c2(2)
        spFull = [spFull i];    
    elseif length(find(fpFull == i)) == 0
        flFull = [flFull i];
    end            
end
% spFull = [spFull fpFull];

spFull = unique([xFull(spFull) yFull(spFull)],'rows');
flFull = unique([xFull(flFull) yFull(flFull)],'rows');
fpFull = unique([xFull(fpFull) yFull(fpFull)],'rows');

H = RBF_Preprocessor2D([spFull;fpFull],flFull,2,'C2',200);

theta = linspace(0,2*pi,length(fpFull));
fpFull(:,2) = fpFull(:,2) + 0.5*sin(theta)';

flFull = H*[spFull;fpFull];

figure('Position', [100, 100, 1000, 500])
% figure('Position', [100, 100, 600, 300])
hold on

xy = [spFull; flFull; fpFull];
xy = unique(xy,'rows');
xy = sortrows(xy);

%mesh(reshape(flFull,[48 22]),reshape(y,s),zeros(s),'EdgeColor','k');
% mesh(reshape(x,s),-reshape(y,s),zeros(s),'EdgeColor','k');
% plot(xFull,yFull,'k.');
% plot(x(StrucPts),y(StrucPts),'bo');
% plot(xFull(fpFull),yFull(fpFull),'ro');
plot(spFull(:,1),spFull(:,2),'ro');
plot(fpFull(:,1),fpFull(:,2),'ro');
plot(flFull(:,1),flFull(:,2),'k.');

ylim([-6 6])
xlim([-11 11])

