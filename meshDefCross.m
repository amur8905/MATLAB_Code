
clear all
load 'meshCross.mat'

body = [];
bdry = [];
for i = 1:length(e(1,:))
    for j = 1:2
        x = p(1,e(j,i));
        y = p(2,e(j,i));
        if x^2 + y^2 < 0.8
            body = [body e(j,i)];
        else
            bdry = [bdry e(j,i)];
        end
    end
end
body = sort(unique(body));
bdry = sort(unique(bdry));
aero = 1:length(p(1,:));
aero(bdry) = [];

% trimesh(t(1:3,:)',p(1,:),p(2,:),'Color','k');

hold on

horz = [-0.4:0.1:0.4];
vert = -0.7:0.1:0.7;

horz = [horz; 0*horz];
vert = [0*vert; vert+0.01];

struc = [p(:,bdry) horz vert];
fluid = p(:,aero);

% plot(horz(1,:), horz(2,:),'b.')
% plot(vert(1,:), vert(2,:),'r.')
% plot(p(1,aero), p(2,aero),'b.')
% plot(struc(1,:), struc(2,:),'b.')
% plot(fluid(1,:), fluid(2,:),'r.')

dTheta = 10;
rot = [cosd(-dTheta) -sind(-dTheta); sind(-dTheta) cosd(-dTheta)];

H = RBF_Preprocessor2D(struc',fluid',2,'Euclid',100);
H2 = RBF_Preprocessor2D([horz vert]',p(:,body)',1,'Euclid',100);

% horz = rot*horz;
horz(2,:) = horz(2,:) - 0.1;
struc = [p(:,bdry) horz vert];
fluid = p(:,aero);

p(1,aero) = H*struc(1,:)';
p(2,aero) = H*struc(2,:)';

% p(1,body) = H2*[horz(1,:) vert(1,:)]';
% p(2,body) = H2*[horz(2,:) vert(2,:)]';


plot(horz(1,:), horz(2,:),'b.')
plot(vert(1,:), vert(2,:),'r.')
% plot(p(1,body),p(2,body),'k.');

trimesh(t(1:3,:)',p(1,:),p(2,:),'Color','k');


