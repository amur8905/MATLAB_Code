clear geom aero panel forces 
run inputVars
%aero.alpha = 0.0;
geom = meshGen(geom);
panel = solverSetup(geom,aero);
%aero.unsteady.theta = 5*pi/180*sin(linspace(0,2*pi,aero.unsteady.nstep));

fprintf('Solving...\n')
for i = 1:aero.unsteady.nstep
    fprintf('iteration: %d of %d\n',i,aero.unsteady.nstep)
    aero.unsteady.currentTime = i;
    if i == 1
        [panel] = gammaSolver(panel,aero);
        dGammadT(i,:) = (panel.gamma-panel.gammaM1)./aero.unsteady.dt;
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
                panel.localVel(3,:) = aero.unsteady.traj(3,i)-aero.unsteady.traj(3,i-1);
                panel.Uf        = panel.Uf + panel.localVel(1,:);
                panel.Vf        = panel.Vf + panel.localVel(2,:);
                panel.Wf        = panel.Wf + panel.localVel(3,:);
            case 'pitch'
                panel.Uf        = panel.Uf - panel.localVel(1,:);
                panel.Vf        = panel.Vf - panel.localVel(2,:);
                panel.Wf        = panel.Wf - panel.localVel(3,:);
        end
        % write fore wake panels
        panel.wrf1(:,1:panel.wM) = panel.rf4(:,end-panel.M+1:end);
        panel.wrf2(:,1:panel.wM) = panel.rf3(:,end-panel.M+1:end);
        aero.unsteady.currentTime = i;
        % --------------
        % MAIN CODE HERE
        
        
        
        [panel] = gammaSolver(panel,aero);
        dGammadT(i,:) = (panel.gamma-panel.gammaM1)./aero.unsteady.dt;
        [forces,panel] = forceCalc(panel,aero);
        [forces] = coefCalc(geom,aero,panel,forces);
        % --------------
        
        % move wake panels down the row
        if i < aero.unsteady.nstep
            panel.wrf1 = circshift(panel.wrf1,panel.wM,2);
            panel.wrf2 = circshift(panel.wrf2,panel.wM,2);
            panel.wrf3 = circshift(panel.wrf3,panel.wM,2);
            panel.wrf4 = circshift(panel.wrf4,panel.wM,2);
        end
    end
    dPres1(i,:) = forces.dPres1;
    dPres2(i,:) = forces.dPres2;
    dPres3(i,:) = forces.dPres3;
    CL(i) = forces.CL;
    Cl(i,:)     = forces.Cl;
    
end




%% Quick Plotting
run plotMesh