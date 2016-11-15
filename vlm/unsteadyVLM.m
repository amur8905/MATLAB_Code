function [geom,aero,panel,forces,CL,Cl] = unsteadyVLM(inputVars,H,D,aeroPts)

%% UNSTEADY VORTEX LATTICE METHOD
% This function includes all the capabilities to model a simple wing with
% camber undergoing unsteady motion primarily in the x-z plane, these
% include;
%         - suddent acceleration
%         - pitching motion
%         - heaving motion
%         - combined pitching/heaving motion
%
% The input for this program is essentially the .mat file which you create
% by running the inputVars script from the command line. Simply type:
% >> run inputVars.m
% >> save('filename')
% >> [out] = unsteadyVLM('filename.m')
% 
% Only CL and Cl will be stored over the total time of the solution,
% however adding further outputs to the out. structure is easy and recommended if you need to. 


% If you need to put forces in matrix form, use:
% >> reshape(forces.dLift,panel.M,panel.N)'
%   Author: J. A. Geoghegan
%   Created: 07/10/2016
%   Modifiations:
%       -
%% 



load(inputVars)
%aero.alpha = 0.0;
geom = meshGen(geom);
panel = solverSetup(geom,aero);
%aero.unsteady.theta = 5*pi/180*sin(linspace(0,2*pi,aero.unsteady.nstep));
refpntOld = panel.refpnt;
rcOld = aeroPts(:,(panel.M+1)*(panel.N+1)+1:end);
rcVel = rcOld*0;
fprintf('Solving...\n')
for i = 1:aero.unsteady.nstep
    fprintf('iteration: %d of %d\n',i,aero.unsteady.nstep)
    aero.unsteady.currentTime = i;
    if i == 1
        [panel] = gammaSolver(panel,aero);
        [forces,panel] = forceCalc(panel,aero);
        [forces] = coefCalc(geom,aero,panel,forces);
        
    else
        % write aft wake panel line
        panel.wrf4(:,1:panel.wM) = panel.rf4(:,end-panel.M+1:end);
        panel.wrf3(:,1:panel.wM) = panel.rf3(:,end-panel.M+1:end);
        % calculate changes in angles
        deltaTh = aero.unsteady.theta(i)-aero.unsteady.theta(i-1);
        deltaX = aero.unsteady.traj(:,i)-aero.unsteady.traj(:,i-1);
        % move panel
        panel = kinematics(panel,aero,deltaX,deltaTh,0);
        panel.refpnt = panel.refpnt + deltaX;
        panel = kinematics(panel,aero,panel.refpnt,deltaTh,1);
        panel = normTangArea(panel);
        % update velocities due to rotation [ADAM ADD DEFLECTION VELOCITY HERE]
        switch aero.unsteady.type
            case 'heave'
                panel.localVel(1,:) = zeros(1,panel.NM);
                panel.localVel(2,:) = zeros(1,panel.NM);
                panel.localVel(3,:) = (aero.unsteady.traj(3,i)-aero.unsteady.traj(3,i-1))/aero.unsteady.dt;
                panel.Uf        = panel.Uf + panel.localVel(1,:);
                panel.Vf        = panel.Vf + panel.localVel(2,:);
                panel.Wf        = panel.Wf + panel.localVel(3,:) + rcVel(3,:);
            case 'pitch'
                panel.Uf        = panel.Uf - panel.localVel(1,:);
                panel.Vf        = panel.Vf - panel.localVel(2,:);
                panel.Wf        = panel.Wf - panel.localVel(3,:) + rcVel(3,:);            
        end
        % write fore wake panels
        panel.wrf1(:,1:panel.wM) = panel.rf4(:,end-panel.M+1:end);
        panel.wrf2(:,1:panel.wM) = panel.rf3(:,end-panel.M+1:end);
        aero.unsteady.currentTime = i;
        % --------------
        % MAIN CODE HERE
        [panel] = gammaSolver(panel,aero);
        [forces,panel] = forceCalc(panel,aero);
        [forces] = coefCalc(geom,aero,panel,forces);
        
        N = panel.N;
        M = panel.M;
        
        %transfer forces to structure
        Fx_a = forces.dLift.*panel.normal(1,:);
        Fy_a = forces.dLift.*panel.normal(2,:);
        Fz_a = forces.dLift.*panel.normal(3,:);
        Fx_s = H'*[zeros((N+1)*(M+1),1);Fx_a'];
        Fy_s = H'*[zeros((N+1)*(M+1),1);Fy_a'];
        Fz_s = H'*[zeros((N+1)*(M+1),1);Fz_a'];
        D.Coord(1,:) = D.Coord(1,:) + (panel.refpnt(1) - refpntOld(1));
        D.Coord(2,:) = D.Coord(2,:) + (panel.refpnt(2) - refpntOld(2));
        D.Coord(3,:) = D.Coord(3,:) + (panel.refpnt(3) - refpntOld(3));
        refpntOld = panel.refpnt;
        %quiver3(D.Coord(1,:),D.Coord(2,:),D.Coord(3,:),Fx_s',Fy_s',Fz_s');
        
        %deform structure
        D.Load(1:3,:) = 1*[Fx_s Fy_s Fz_s]';
        [Q,V,R]=MSA(D);
        %D.Coord(1:3,:) = D.Coord(1:3,:) + 200*V(1:3,:);
        V(1:3,:) = 3*V(1:3,:);
        
        %deflect aerodynamic surface
        aeroPts(1,:) = H*(D.Coord(1,:)+V(1,:))';
        aeroPts(2,:) = H*(D.Coord(2,:)+V(2,:))';
        aeroPts(3,:) = H*(D.Coord(3,:)+V(3,:))'; 
        apX = reshape(aeroPts(1,1:(N+1)*(M+1)),M+1,N+1)';
        apY = reshape(aeroPts(2,1:(N+1)*(M+1)),M+1,N+1)';
        apZ = reshape(aeroPts(3,1:(N+1)*(M+1)),M+1,N+1)';
        rf1X = reshape(apX(1:end-1,1:end-1)',1,N*M);
        rf1Y = reshape(apY(1:end-1,1:end-1)',1,N*M);
        rf1Z = reshape(apZ(1:end-1,1:end-1)',1,N*M);
        panel.rf1 = [rf1X;rf1Y;rf1Z];        
        rf2X = reshape(apX(1:end-1,2:end)',1,N*M);
        rf2Y = reshape(apY(1:end-1,2:end)',1,N*M);
        rf2Z = reshape(apZ(1:end-1,2:end)',1,N*M);
        panel.rf2 = [rf2X;rf2Y;rf2Z];        
        rf3X = reshape(apX(2:end,2:end)',1,N*M);
        rf3Y = reshape(apY(2:end,2:end)',1,N*M);
        rf3Z = reshape(apZ(2:end,2:end)',1,N*M);
        panel.rf3 = [rf3X;rf3Y;rf3Z];        
        rf4X = reshape(apX(2:end,1:end-1)',1,N*M);
        rf4Y = reshape(apY(2:end,1:end-1)',1,N*M);
        rf4Z = reshape(apZ(2:end,1:end-1)',1,N*M);
        panel.rf4 = [rf4X;rf4Y;rf4Z];
        
        %calc deflection velocities
        panel.rc = aeroPts(:,(N+1)*(M+1)+1:end);  
        rcVel = (panel.rc-rcOld)/aero.unsteady.dt;
        rcOld = panel.rc;
        
        %check for unsteady
        if abs(max(panel.rc(3,:))) > geom.span
            disp('Tip deflection greater than span, simulation aborted.\n');
            break
        end
                  
        
        % --------------
        
        % move wake panels down the row
        if i < aero.unsteady.nstep
            panel.wrf1 = circshift(panel.wrf1,panel.wM,2);
            panel.wrf2 = circshift(panel.wrf2,panel.wM,2);
            panel.wrf3 = circshift(panel.wrf3,panel.wM,2);
            panel.wrf4 = circshift(panel.wrf4,panel.wM,2);
        end
    end
    CL(i) = forces.CL;
    Cl(i,:)     = forces.Cl;
%     plotMesh;    
%     pause(0);
end

% saveCheck = input('Save Case? [y]','s');
% if strcmp(saveCheck,'y') == 1
save('currentSolution.mat','aero','geom','panel')
% end

% out.geom = geom;
% out.aero = aero;
% out.panel = panel;
% out.forces = forces;
% out.CL = CL;
% out.Cl = Cl;
return
%% Quick Plotting
%run plotMesh