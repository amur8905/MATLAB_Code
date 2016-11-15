%% Input Structures

% geometry structure
geom.ip         = 4;            % number of chord panels
geom.jp         = 10;           % number of span panels
geom.stages     = 1;            % number of wing stages
geom.chordRoot  = 1;            % chord at root
geom.airfoil    = '0012';       % camber (either naca or profile)
geom.chordDist  = 'linear';     % chord point distribution
geom.span       = 20/2;            % wing semi span
geom.spanDist   = 'linear';     % span point distribution
geom.sweep      = 0;            % wing sweep
geom.taper      = 1;            % wing taper
geom.dihed      = 0;            % dihedral angle
geom.chordTip   = geom.taper*geom.chordRoot;            % chord at tip
geom.S          = geom.span*0.5*(geom.chordTip+geom.chordRoot);
geom.thickness  = 0;            % plate or full thickness (0,1)


% flight structure
aero.Uinf       = 25.0;          % x freestream m/s
aero.dt         = 0.5*geom.chordRoot/aero.Uinf;     % timestep
aero.nu         = 1.79e-5;
aero.rho        = 1.2254;
aero.alpha      = -5*pi/180*0;      % angle of attack
aero.type       = 'unsteady';     % steady or unsteady solver
switch aero.type
    case 'steady'
        aero.wakeLen = geom.chordRoot+100;
        aero.steady.wakeEndx = geom.chordRoot*aero.wakeLen;
        aero.steady.wakeEndz = 0;
        aero.steady.nstep = 1;
    case 'unsteady'
        % needed parameters: num time steps, dt, pitch frequency, heave
        % frequency, definition of wing trajectory,
        aero.unsteady.kFactor       = 1.0;
        aero.unsteady.dt            = aero.unsteady.kFactor*geom.chordRoot/aero.Uinf;
        aero.unsteady.nstep         = 300;
        aero.unsteady.maxWake       = 30;
        aero.unsteady.timeVector    = (0:aero.unsteady.nstep-1)*aero.unsteady.dt;
        aero.unsteady.type          = 'heave';
        aero.unsteady.pitchFreq     = 0.1*(2*aero.Uinf/geom.chordRoot); % reduced frequencies
        aero.unsteady.heaveFreq     = 0.1*(2*aero.Uinf/geom.chordRoot);
        
        switch aero.unsteady.type
            case 'accel'
                % 1/4 chord path
                aero.unsteady.traj       = [-aero.unsteady.timeVector*aero.Uinf;...
                    zeros(1,aero.unsteady.nstep);zeros(1,aero.unsteady.nstep)];
                aero.unsteady.theta      = zeros(1,aero.unsteady.nstep);
                
            case 'pitch'
                % 1/4 chord path
                aero.unsteady.traj       = [-aero.unsteady.timeVector*aero.Uinf;...
                    zeros(1,aero.unsteady.nstep);zeros(1,aero.unsteady.nstep)];
                aero.unsteady.theta      = 5*pi/180*sin(aero.unsteady.pitchFreq*aero.unsteady.timeVector);
                
            case 'heave'
                % 1/4 chord path
                aero.unsteady.traj       = [-aero.unsteady.timeVector*aero.Uinf;...
                    zeros(1,aero.unsteady.nstep);...
                    (0.1*geom.chordRoot)*sin(aero.unsteady.heaveFreq*aero.unsteady.timeVector)];
                aero.unsteady.theta      = zeros(1,aero.unsteady.nstep);
                                
            case 'pitchPlunge'
                % 1/4 chord path
                    aero.unsteady.traj       = [-aero.unsteady.timeVector*aero.Uinf;...
                    zeros(1,aero.unsteady.nstep);...
                    (0.1*geom.chordRoot)*sin(aero.unsteady.heaveFreq*aero.unsteady.timeVector)];
                aero.unsteady.theta      = 10*pi/180*sin(aero.unsteady.pitchFreq*aero.unsteady.timeVector);    

        end
end

% final structure