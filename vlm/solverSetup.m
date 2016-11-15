function [panel] = solverSetup(geom,aero)
%% Geometric Panel discretisation for wing camber plane
panel.N = geom.ip;
panel.M = geom.jp;
panel.NM = panel.N*panel.M;
panel.rf1 = [reshape(geom.mesh.camberx(1:end-1,1:end-1)',1,panel.NM);...
    reshape(geom.mesh.cambery(1:end-1,1:end-1)',1,panel.NM);...
    reshape(geom.mesh.camberz(1:end-1,1:end-1)',1,panel.NM)];

panel.rf2 = [reshape(geom.mesh.camberx(1:end-1,2:end)',1,panel.NM);...
    reshape(geom.mesh.cambery(1:end-1,2:end)',1,panel.NM);...
    reshape(geom.mesh.camberz(1:end-1,2:end)',1,panel.NM)];
panel.rf3 = [reshape(geom.mesh.camberx(2:end,2:end)',1,panel.NM);...
    reshape(geom.mesh.cambery(2:end,2:end)',1,panel.NM);...
    reshape(geom.mesh.camberz(2:end,2:end)',1,panel.NM)];
panel.rf4 = [reshape(geom.mesh.camberx(2:end,1:end-1)',1,panel.NM);...
    reshape(geom.mesh.cambery(2:end,1:end-1)',1,panel.NM);...
    reshape(geom.mesh.camberz(2:end,1:end-1)',1,panel.NM)];
panel.rc = [reshape(geom.mesh.midx',1,panel.NM);...
        reshape(geom.mesh.midy',1,panel.NM);...
        reshape(geom.mesh.midz',1,panel.NM)];
panel.refpnt = [geom.chordRoot/4;0;0];

[panel] = kinematics(panel,aero,panel.refpnt,aero.alpha,1);

% Define velocities
panel.Uf = aero.Uinf*ones(1,panel.NM);
panel.Vf = zeros(1,panel.NM);
panel.Wf = zeros(1,panel.NM);

% Wake Panels - separate function for this since steady/unsteady
% (unsteady may need to be called more than once)
switch aero.type
    case 'steady'
        panel.wN = 1;
        panel.wM = panel.M;
        panel.wNM = panel.wN*panel.wM;
        panel.wrf1 = [panel.rf4(1,end-panel.M+1:end); ...
            panel.rf4(2,end-panel.M+1:end);panel.rf4(3,end-panel.M+1:end)];
        panel.wrf2 = [panel.rf3(1,end-panel.M+1:end);...
            panel.rf3(2,end-panel.M+1:end);panel.rf3(3,end-panel.M+1:end)];

        panel.wrf3 = [ones(1,panel.M)*aero.steady.wakeEndx;...
            panel.rf3(2,end-panel.M+1:end);ones(1,panel.M)*aero.steady.wakeEndz];
        panel.wrf3(1:2:end,:) = panel.wrf3(1:2:end,:)+panel.rf3(1:2:end,end-panel.M+1:end);

        panel.wrf4 = [ones(1,panel.M)*aero.steady.wakeEndx;...
            panel.rf4(2,end-panel.M+1:end);ones(1,panel.M)*aero.steady.wakeEndz];
        panel.wrf4(1:2:end,:) = panel.wrf4(1:2:end,:)+panel.rf4(1:2:end,end-panel.M+1:end);

        % preallocate Gamma vectors
        panel.gamma = ones(panel.NM,1);
        panel.wakegamma = ones(panel.wNM,1);
        
    case 'unsteady'
        panel.wN = aero.unsteady.nstep-1;
        panel.wM = panel.M;
        panel.wNM = panel.wN*panel.wM;
        % pre-define zeros for the wake vector.
        panel.wrf1 = zeros(3,panel.wNM);
        panel.wrf2 = zeros(3,panel.wNM);
        panel.wrf3 = zeros(3,panel.wNM);
        panel.wrf4 = zeros(3,panel.wNM);
        
        % preallocate Gamma vectors
        panel.gamma = ones(panel.NM,1)';
        panel.gammaM1 = zeros(panel.NM,1)'; % previous time-step gamma
        panel.wakegamma = zeros(panel.wNM,1);
end


[panel] = normTangArea(panel);
return