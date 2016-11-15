close all
fc.V = 15;
fc.rho = 1.225;
fc.p = 101325;

%read AVL data
points = parseAVL('mdoBase.dat',fc);

%build a wing
%sD = [16.45/4 0 0 10 1; 7.03+10.33/4 9.85 0 20 0.9; 24.95+3.54/4 35 0 0 0.5];
%D = GenBeamWing(sD,0.01);
sD = [16.45/4 0 0 10; 7.03+10.33/4 9.85 0 20; 24.95+3.54/4 35 0 0];
%sD = [0.5/4 0 0 60; 0.5/4 2 0 0];
D = GenStickWing(sD,0.1,16.45/4);
D.Coord(3,:) = D.Coord(3,:) + 0.000*rand(size(D.Coord(3,:)));
D.Coord(1,:) = D.Coord(1,:) + 0.000*rand(size(D.Coord(1,:)));


%generate coupling matrix
cr = 0.05;
H = RBF_Preprocessor(D.Coord',points.position,1,'Gaussian',35*cr);

%calculate forces onto structural model
strucForces = zeros(D.n,3);
strucForces(:,1) = H'*points.force(:,1);
strucForces(:,2) = H'*points.force(:,2);
strucForces(:,3) = H'*points.force(:,3);

%check that total forces are maintained
disp(sprintf('Total forces from VLM: %f %f %f\n',sum(points.force(:,1)),sum(points.force(:,2)),sum(points.force(:,3))));
disp(sprintf('Total forces to structure: %f %f %f\n',sum(strucForces(:,1)),sum(strucForces(:,2)),sum(strucForces(:,3))));

%plot aerodynamic loads
% quiver3(points.position(:,1),points.position(:,2),points.position(:,3),...
%     points.force(:,1),points.force(:,2),points.force(:,3));
% axis equal
% hold on

%plot3(D.Coord(1,:),D.Coord(2,:),D.Coord(3,:),'k-');
% plot3(points(:,1),points(:,2),points(:,6),'b.');

%load the structure
D.Load(1:3,:) = 1*[strucForces(:,1) strucForces(:,2) strucForces(:,3)]';

%plot structural loads
% quiver3(D.Coord(1,:),D.Coord(2,:),D.Coord(3,:),...
%     D.Load(1,:),D.Load(2,:),D.Load(3,:));

%solve strucutre
[Q,V,R]=MSA(D);
D.Coord(1:3,:) = D.Coord(1:3,:) + V(1:3,:);


%D.Coord(1:3,:) = D.Coord(1:3,:) + 1e2*V(1:3,:);
%plot3(D.Coord(1,:),D.Coord(2,:),D.Coord(3,:),'r-');
PlotStructure(D.Coord, D.Con);
plot3(points.position(:,1),points.position(:,2),points.position(:,3),'g.');
axis equal
view(45,45)
hold on

%transfer displacements back to wing
points.position(:,1) = H*D.Coord(1,:)';
points.position(:,2) = H*D.Coord(2,:)';
points.position(:,3) = H*D.Coord(3,:)';

plot3(points.position(:,1),points.position(:,2),points.position(:,3),'b.');
axis equal
hold on

PlotStructure(D.Coord,D.Con)


% D.Coord(1:3,:) = D.Coord(1:3,:) + V(1:3,:);
% hold on
% plot3(D.Coord(1,:),D.Coord(2,:),D.Coord(3,:),'r.');