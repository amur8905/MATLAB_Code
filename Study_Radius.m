close all
clear all
fc.V = 15;
fc.rho = 1.225;
fc.p = 101325;
%read AVL data


%build a wing
sD = [16.45/4 0 0 10 1; 7.03+10.33/4 9.85 0 20 0.9; 24.95+3.54/4 35 0 0 0.5];
D = GenBeamWing(sD,0.022);
%sD = [16.45/4 0 0 10; 7.03+10.33/4 9.85 0 20; 24.95+3.54/4 35 0 0];
%D = GenStickWing(sD,0.08,16.45/4);

figure
hold on
%set(0,'defaultLineLineWidth', 2)
%pts = 3:4:length(D.Coord(3,1:end-4));

for cr = 0.01:0.01:3
pts = parseAVL('mdoBase.dat',fc);
ptsOld = pts;
% plot3(pts.position(:,1),pts.position(:,2),pts.position(:,3),'r.');      
%     view(45,45)
%cr = 22.7;
H = RBF_Preprocessor(D.Coord',pts.position,0,'Gaussian',cr*8.8);
pts.position(:,1) = H*(D.Coord(1,:))';
pts.position(:,2) = H*(D.Coord(2,:))';
pts.position(:,3) = H*(D.Coord(3,:))';
diff = pts.position - (ptsOld.position);
diff = sqrt(diff(:,1).^2 + diff(:,2).^2 + diff(:,3).^2);
d = max(diff)/35;
plot(cr,d,'k*');
% plot3(pts.position(:,1),pts.position(:,2),pts.position(:,3),'r.');      
%     view(45,45)
%     axis equal
%     PlotStructure(D.Coord,D.Con);
end
%iteration
% figure
%plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'C2',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'C4',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'C6',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'Euclid',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'Multiquadric',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'InverseMulti',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'TPS',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% points = parseAVL('mdoBase.dat',fc);
% H = RBF_Preprocessor(D.Coord',points.position,1,'Gaussian',1);
% iteration
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);
% 
% xlabel('Normalised spanwise position');
%   ylabel('Deflection in z (m)');
%   set(0,'defaultLineLineWidth', 1)
%   
%   legend('r = 100', 'r = 150', 'r = 200', 'r = 250', 'r = 300');