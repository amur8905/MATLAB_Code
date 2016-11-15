function [panel] = kinematics(panel,aero,refpnt,angle,mode)

% From wing motion, move grid points forward, up or down and determine the
% new local velocities

switch mode
    case 0
        % Translate forward
        trans = eye(4); trans(1:3,end) = refpnt;
        rf1         = trans*[panel.rf1;ones(1,panel.NM)];
        rf2         = trans*[panel.rf2;ones(1,panel.NM)];
        rf3         = trans*[panel.rf3;ones(1,panel.NM)];
        rf4         = trans*[panel.rf4;ones(1,panel.NM)];
        rc          = trans*[panel.rc;ones(1,panel.NM)];

        panel.rf1   = rf1(1:3,:);
        panel.rf2   = rf2(1:3,:);
        panel.rf3   = rf3(1:3,:);
        panel.rf4   = rf4(1:3,:);
        panel.rc    = rc(1:3,:);
        
    case 1
        % Translate - Rotate - Translate
        trans = eye(4); trans(1:3,end) = -refpnt;
        rot = eye(4); rot(1,:) = [cos(angle),0,sin(angle),0];
        rot(3,:) = [-sin(angle),0,cos(angle),0];
        atrans = trans; atrans(1:3,end) = -atrans(1:3,end);

        rf1         = atrans*rot*trans*[panel.rf1;ones(1,panel.NM)];
        rf2         = atrans*rot*trans*[panel.rf2;ones(1,panel.NM)];
        rf3         = atrans*rot*trans*[panel.rf3;ones(1,panel.NM)];
        rf4         = atrans*rot*trans*[panel.rf4;ones(1,panel.NM)];
        rc          = atrans*rot*trans*[panel.rc;ones(1,panel.NM)];

        % Calculate Velocity due to wing rotation rate
        panel.localDisp   = rc(1:3,:)-panel.rc;
        panel.localVel  = panel.localDisp./aero.unsteady.dt;
        
        panel.rf1   = rf1(1:3,:);
        panel.rf2   = rf2(1:3,:);
        panel.rf3   = rf3(1:3,:);
        panel.rf4   = rf4(1:3,:);
        panel.rc    = rc(1:3,:);
        
        
end


return