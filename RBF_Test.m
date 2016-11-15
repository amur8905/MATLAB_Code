%generate some aerodynamic nodes
angle = linspace(0,2*pi,50)';
Xa = [];
for i = -5:0.5:5
    Xa = [Xa; cos(angle) sin(angle) i*ones(length(angle),1)];
end
Xa = unique(Xa,'rows');
plot3(Xa(:,1), Xa(:,2),Xa(:,3),'b.');
hold on
axis equal

%generate some structural nodes
horz = linspace(-0.3,0.3,5)';
vert = linspace(-0.15,0.15,3)';
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
Xs = [];
for i = -5:5
    Xs = [Xs; x y i*ones(length(x),1)];
end
Xs = unique(Xs,'rows');
plot3(Xs(:,1), Xs(:,2),Xs(:,3),'k.');

cr = 0.227;
H = RBF_Preprocessor(Xs,Xa,2,'Gaussian',2*cr);
Xs_n = Xs;
for i = 1:length(Xs(:,1))
    Xs_n(i,:) = [Xs(i,1) Xs(i,2)+0.01*(-5-Xs(i,3))^2 Xs(i,3)];
    theta = Xs_n(i,3)*pi/50;
    Xs_n(i,:) = [cos(theta),sin(theta),0;-sin(theta),cos(theta),0;0,0,1]*Xs_n(i,:)' + 1;
    Xs_n(i,:) = [1,0,0;0,cos(theta),sin(theta);0,-sin(theta),cos(theta)]*Xs_n(i,:)' + 1;
end
Xa_n = H*Xs_n;
plot3(Xa_n(:,1), Xa_n(:,2), Xa_n(:,3),'r.');
plot3(Xs_n(:,1), Xs_n(:,2), Xs_n(:,3),'k.');
axis vis3d
hold off


