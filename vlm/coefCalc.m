function [forces] = coefCalc(geom,aero,panel,forces)

% Add switch cases here for steady/unsteady and plate/thick wing
forces.L        = sum(forces.dLift);
forces.D        = sum(forces.dDrag);
forces.q        = 0.5*aero.rho*aero.Uinf^2*geom.S;
forces.CL       = forces.L/forces.q;
forces.CD       = forces.D/forces.q;

dStripArea      = sum(reshape(panel.area',panel.M,panel.N)',1);
forces.dq       = 0.5*aero.rho*aero.Uinf^2*dStripArea;
forces.Cl       = sum(reshape(forces.dLift',panel.M,panel.N)',1)./forces.dq;
forces.Cd       = sum(reshape(forces.dDrag',panel.M,panel.N)',1)./forces.dq;

return