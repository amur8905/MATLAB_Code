
load 'meshDeformEllipse.mat'
%trimesh(t(1:3,:)',p(1,:),p(2,:),'Color','b');
body = [];
bdry = [];
for i = 1:length(e(1,:))
    for j = 1:2
        x = p(1,e(j,i));
        y = p(2,e(j,i));
        if x^2 + y^2 < 1
            body = [body e(j,i)];
        else
            bdry = [bdry e(j,i)];
        end
    end
end
body = sort(unique(body));
bdry = sort(unique(bdry));
aero = 1:length(p(1,:));
aero([body bdry]) = [];

% figure 
% hold on

dTheta = 1;
thetaMax = 30;
thetaMin = 0;
theta = thetaMin:dTheta:thetaMax;
rot = [cosd(-dTheta) -sind(-dTheta); sind(-dTheta) cosd(-dTheta)];


% figure
% hold on
% trimesh(t(1:3,:)',p(1,:),p(2,:),'Color','k');
% plot(p(1,body),p(2,body),'r.');
% plot(p(1,bdry),p(2,bdry),'g.');
% plot(p(1,aero),p(2,aero),'b.');

Xs = [p(1:2,body) p(1:2,bdry)]';
Xa = p(1:2,aero)';
qmin0 = min(pdetriq(p,t));
qmean0 = mean(pdetriq(p,t));

H = RBF_Preprocessor2D(Xs,Xa,0,'C2',500);
means = [];
mins = [];
for th = theta
    p(1:2,body) = rot*p(1:2,body);
    p(1:2,aero) = (H*[p(1:2,body) p(1:2,bdry)]')';
    q = pdetriq(p,t);
    mins = [mins min(q)];
    means = [means mean(q)];
%     Xs = [p(1:2,body) p(1:2,bdry)]';
%     Xa = p(1:2,aero)';
%     H = RBF_Preprocessor2D(Xs,Xa,0,'C2',200);
end
% plot(theta,100*(1 - (qmin0 - mins)/qmin0),'-','LineWidth',2);
% plot(theta,100*(1 - (qmean0 - means)/qmean0),'--','LineWidth',2);

% H = RBF_Preprocessor2D(Xs,Xa,0,'InverseMulti',1);
% means = [];
% mins = [];
% for th = theta
%     p(1:2,body) = rot*p(1:2,body);
%     p(1:2,aero) = (H*[p(1:2,body) p(1:2,bdry)]')';
%     q = pdetriq(p,t);
%     mins = [mins min(q)];
%     means = [means mean(q)];
% %     Xs = [p(1:2,body) p(1:2,bdry)]';
% %     Xa = p(1:2,aero)';
% %     H = RBF_Preprocessor2D(Xs,Xa,0,'C2',200);
% end
% % plot(theta,100*(1 - (qmin0 - mins)/qmin0),'-','LineWidth',2);
% plot(theta,100*(1 - (qmean0 - means)/qmean0),'--','LineWidth',2);

% H = RBF_Preprocessor2D(Xs,Xa,0,'TPS',10);
% means = [];
% mins = [];
% for th = theta
%     p(1:2,body) = rot*p(1:2,body);
%     p(1:2,aero) = (H*[p(1:2,body) p(1:2,bdry)]')';
%     q = pdetriq(p,t);
%     mins = [mins min(q)];
%     means = [means mean(q)];
% %     Xs = [p(1:2,body) p(1:2,bdry)]';
% %     Xa = p(1:2,aero)';
% %     H = RBF_Preprocessor2D(Xs,Xa,0,'C2',200);
% end
% % plot(theta,100*(1 - (qmin0 - mins)/qmin0),'-','LineWidth',2);
% plot(theta,100*(1 - (qmean0 - means)/qmean0),'--','LineWidth',2);

% H = RBF_Preprocessor2D(Xs,Xa,0,'Gaussian',0.75);
% means = [];
% mins = [];
% for th = theta
%     p(1:2,body) = rot*p(1:2,body);
%     p(1:2,aero) = (H*[p(1:2,body) p(1:2,bdry)]')';
%     q = pdetriq(p,t);
%     mins = [mins min(q)];
%     means = [means mean(q)];
% %     Xs = [p(1:2,body) p(1:2,bdry)]';
% %     Xa = p(1:2,aero)';
% %     H = RBF_Preprocessor2D(Xs,Xa,0,'C2',200);
% end
% % plot(theta,100*(1 - (qmin0 - mins)/qmin0),'-','LineWidth',2);
% plot(theta,100*(1 - (qmean0 - means)/qmean0),'--','LineWidth',2);


% H = RBF_Preprocessor2D(Xs,Xa,0,'Euclid',10);
% means = [];
% mins = [];
% for th = theta
%     p(1:2,body) = rot*p(1:2,body);
%     p(1:2,aero) = (H*[p(1:2,body) p(1:2,bdry)]')';
%     q = pdetriq(p,t);
%     mins = [mins min(q)];
%     means = [means mean(q)];
% %     Xs = [p(1:2,body) p(1:2,bdry)]';
% %     Xa = p(1:2,aero)';
% %     H = RBF_Preprocessor2D(Xs,Xa,0,'C2',200);
% end
% % plot(theta,100*(1 - (qmin0 - mins)/qmin0),'-','LineWidth',2);
% plot(theta,100*(1 - (qmean0 - means)/qmean0),'--','LineWidth',2);


% xlabel('Pitch angle (deg)');
% ylabel('Mesh quality (% of original)');
% % h = legend('C0','C2','C4','C6','Euclid Hat');
% h = legend('Multiquadric','Inverse Multi','Thin Plate Spline','Gaussian');
% % set(h,'Interpreter','latex','fontsize',12)
% xlim([thetaMin,thetaMax]);

% dX = 0.01;
% X = 0:dX:1.5;
% 
% for x = X
%     p(1,body) = p(1,body) + dX;
%     p(1:2,aero) = (H*[p(1:2,body) p(1:2,bdry)]')';
%     q = pdetriq(p,t);
%     mins = [mins min(q)];
%     means = [means mean(q)];
% end
% 
% figure 
% hold on
% plot(X/4*100,100*(1 - (qmin0 - mins)/qmin0),'k-','LineWidth',2);
% plot(X/4*100,100*(1 - (qmean0 - means)/qmean0),'k--','LineWidth',2);
% xlabel('Shift in x (% of domain length)');
% ylabel('Mesh quality (% of original)');
% h = legend('$$q$$','$$\overline{q}$$');
% set(h,'Interpreter','latex','fontsize',12)
% %xlim([thetaMin,thetaMax]);

figure
hold on
trimesh(t(1:3,:)',p(1,:),p(2,:),'Color','k');
% min(pdetriq(p,t))