close all
fc.V = 15;
fc.rho = 1.225;
fc.p = 101325;
%read AVL data


%build a wing
%sD = [16.45/4 0 0 10 1; 7.03+10.33/4 9.85 0 20 0.9; 24.95+3.54/4 35 0 0 0.5];
%D = GenBeamWing(sD,0.022);
sD = [16.45/4 0 0 10; 7.03+10.33/4 9.85 0 20; 24.95+3.54/4 35 0 0];
D = GenStickWing(sD,0.08,16.45/4);

figure
hold on
axis equal
set(0,'defaultLineLineWidth', 2)
pts = 3:4:length(D.Coord(3,1:end-4));

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'C0',200);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'C2',200);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'C4',20);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'C6',10);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'Euclid',5);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'Multiquadric',1);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'InverseMulti',1);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'TPS',10);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

points = parseAVL('mdoBase.dat',fc);
H = RBF_Preprocessor(D.Coord',points.position,1,'Gaussian',2);
iteration
plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2);

xlabel('Normalised spanwise position');
  ylabel('Deflection in z (m)');
  set(0,'defaultLineLineWidth', 1)
  
  legend('Wendland C0', 'Wendland C2', 'Wendland C4', 'Wendland C6',...
      'Euclid Hat', 'Multiquadric', 'Inverse Multiquadric', 'Thin Plane Spline', 'Gaussian')