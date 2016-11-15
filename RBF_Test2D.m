clear all
close all

%generate some aerodynamic nodes
angle = linspace(0,2*pi,50)';
Xa = [];
Xa = [cos(angle) sin(angle)];
Xa = unique(Xa,'rows');
%plot(Xa(:,1), Xa(:,2),'b.');
hold on
axis equal

%generate some structural nodes
horz = linspace(-0.3,0.3,10)';
vert = linspace(-0.15,0.15,5)';
upx = horz;
upy = horz*0 + 0.15; 
downx = horz;
downy = horz*0 - 0.15;
leftx = vert*0 - 0.3;
lefty = vert;
rightx = vert*0 + 0.3;
righty = vert;
x = [upx;downx;leftx;rightx];
y = [upy;downy;lefty;righty];
Xs = [x y];

Xs = unique(Xs,'rows');
plot(Xs(:,1), Xs(:,2),'k.');

cr = 22.7;
H = RBF_Preprocessor2D(Xs,Xa,1,'Euclid',0.5);

Xf = Xa*0.2;
%Xf(:,1) = sin(angle).*Xf(:,1);

Xfs = H'*Xf;
%plot(Xa(:,1), Xa(:,2),'r.');
plot(Xs(:,1), Xs(:,2),'k.');
%quiver(Xa(:,1), Xa(:,2), Xf(:,1),Xf(:,2));
quiver(Xs(:,1), Xs(:,2), Xfs(:,1),Xfs(:,2),'r');
hold off


