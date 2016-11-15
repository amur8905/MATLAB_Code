function [aero] = unsteadyKin(aero)
% needed parameters: num time steps, dt, pitch frequency, heave
% frequency, definition of wing trajectory,
aero.unsteady.kFactor       = 0.5;
aero.unsteady.dt            = aero.unsteady.kFactor*geom.chordRoot/aero.Uinf;
aero.unsteady.nstep         = 15;
aero.unsteady.timeVector    = (0:aero.unsteady.nstep-1)*aero.unsteady.dt;
aero.unsteady.type          = 'accel';
aero.unsteady.pitchFreq     = 0.0;
aero.unsteady.heaveFreq     = 0.0;

switch aero.unsteady.type
    case 'accel'
        % 1/4 chord path
        aero.unsteady.traj       = [-aero.unsteady.timeVector*aero.Uinf;...
            zeros(1,aero.unsteady.nstep);zeros(1,aero.unsteady.nstep)];
        aero.unsteady.theta      = ones(1,aero.unsteady.nstep)*0*pi/180;

    case 'pitch'
        % 1/4 chord path
        aero.unsteady.trajectx   = -aero.unsteady.timeVector*aero.Uinf;
        aero.unsteady.trajecty   = zeros(numel(aero.unsteady.timeVector));
        aero.unsteady.trajectz   = zeros(numel(aero.unsteady.timeVector));
        aero.unsteady.theta      = 0*pi/180;    

    case 'heave'
        % 1/4 chord path
        aero.unsteady.trajectx   = -aero.unsteady.timeVector*aero.Uinf;
        aero.unsteady.trajecty   = zeros(numel(aero.unsteady.timeVector));
        aero.unsteady.trajectz   = zeros(numel(aero.unsteady.timeVector));
        aero.unsteady.theta      = 0*pi/180;    

    case 'pitchPlunge'
        % 1/4 chord path
        aero.unsteady.trajectx   = -aero.unsteady.timeVector*aero.Uinf;
        aero.unsteady.trajecty   = zeros(numel(aero.unsteady.timeVector));
        aero.unsteady.trajectz   = zeros(numel(aero.unsteady.timeVector));
        aero.unsteady.theta      = 0*pi/180;    

end
return