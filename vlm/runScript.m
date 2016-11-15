clear all

% figure
set(0,'defaultLineLineWidth', 2)
% hold on

inputVars;
geom = meshGen(geom);
save('vlm/data/currentRun.mat','aero','geom');
panel = solverSetup(geom,aero);
sD = [geom.chordRoot/4 0 0 20; geom.chordRoot/4 geom.span 0 0];
D = GenStickWing(sD,0.02,geom.chordRoot/4);

% sD = [geom.chordRoot/4 0 0 10 0.1; geom.chordRoot/4 geom.span 0 0 0.1];
% D = GenBeamWing(sD,0.1);

N = panel.N;
M = panel.M;
aeroPts = [panel.rf1'; panel.rf2'; panel.rf3'; panel.rf4'];
aeroPts = unique(aeroPts,'rows');
aeroPts = sortrows(aeroPts,[1 2]);
aeroPts = [aeroPts; panel.rc']';

cr = 1.1;

% figure 
% hold on
% axis equal
% PlotStructure(D.Coord,D.Con);
% plot3(panel.rc(1,:),panel.rc(2,:),panel.rc(3,:),'g.');
H = RBF_Preprocessor(D.Coord',aeroPts',1,'TPS',geom.span*cr);
[geom,aero,panel,forces,CL,Cl] = unsteadyVLM('vlm/data/currentRun.mat',H,D,aeroPts);
% plotMesh;

wrf1z = reshape(panel.wrf1(3,:),panel.M,aero.unsteady.nstep-1)';
wrf1x = reshape(panel.wrf1(1,:),panel.M,aero.unsteady.nstep-1)';
wrf2z = reshape(panel.wrf2(3,:),panel.M,aero.unsteady.nstep-1)';
plot(-wrf1x(:,1)*aero.unsteady.dt,wrf2z(:,end));
% plot(-wrf1x(:,1)*aero.unsteady.dt,wrf2z(:,5));
% plot(-wrf1x(:,1)*aero.unsteady.dt,wrf1z(:,1));


set(0,'defaultLineLineWidth', 1)
xlabel('time (s)');
ylabel('z (m)')