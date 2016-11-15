function [forces,panel] = forceCalc(panel,aero)
%% Zero- Thickness Wing
switch aero.type
    
    case 'steady'
        forces.gamai    = panel.gamma-[zeros(1,panel.M),panel.gamma(1:end-panel.M)];
        dy              = (panel.rf2(2,:)-panel.rf1(2,:));
        forces.dLift    = aero.rho*aero.Uinf*forces.gamai.*dy;  % panel lift (Kutta-Jo)
        forces.dPres    = forces.dLift./panel.area;  % panel pressure
        forces.dDrag    = -aero.rho*panel.wind'.*forces.gamai.*dy;
    
    case 'unsteady'
        
        % Calculate the chordwise and spanwise lengths per panel
        dy  = sqrt((((panel.rf2(2,:)-panel.rf1(2,:))+(panel.rf3(2,:)-panel.rf4(2,:)))/2).^2 ...
                    +(((panel.rf2(3,:)-panel.rf1(3,:))+(panel.rf3(3,:)-panel.rf4(3,:)))/2).^2);
        dx  = sqrt((((panel.rf4(1,:)-panel.rf1(1,:))+(panel.rf3(1,:)-panel.rf2(1,:)))/2).^2 ...
                    +(((panel.rf4(3,:)-panel.rf1(3,:))+(panel.rf3(3,:)-panel.rf2(3,:)))/2).^2);
        % create temporary gama mesh to determine the chordwise and spanwise change in circulation        
        tempGamma       = reshape(panel.gamma,panel.M,panel.N)';
        tempGamai       = [tempGamma(1,:);(tempGamma(2:end,:)-tempGamma(1:end-1,:))];
        forces.gamai    = reshape(tempGamai',1,panel.NM);
        tempGamaj       = [tempGamma(:,1),(tempGamma(:,2:end)-tempGamma(:,1:end-1))];
        forces.gamaj    = reshape(tempGamaj',1,panel.NM);
        
        % find the net velocity in the chord and span-wise directions
        netPanelVeloc   = [panel.Uf;panel.Vf;panel.Wf] + panel.wup;
        chordWiseFlow   = sum(netPanelVeloc.*panel.taui,1);
        spanWiseFlow    = sum(netPanelVeloc.*panel.tauj,1);
        
        % calculate the circulation derivatives.
        forces.dGammadx        = forces.gamai./dx;
        forces.dGammady        = forces.gamaj./dy;
        forces.dGammadt        = (panel.gamma-panel.gammaM1)./aero.unsteady.dt;
        panel.gammaM1  = panel.gamma;
        forces.dPres1   = chordWiseFlow.*forces.dGammadx;
        forces.dPres2   = spanWiseFlow.*forces.dGammady;
        forces.dPres3   = forces.dGammadt;
        forces.dPres    = aero.rho*(chordWiseFlow.*forces.dGammadx + spanWiseFlow.*forces.dGammady + forces.dGammadt);
        forces.dLift    = forces.dPres.*panel.area.*panel.normal(3,:);
        forces.dDrag    = forces.dPres.*panel.area.*panel.normal(1,:);
        
        
end
            
return