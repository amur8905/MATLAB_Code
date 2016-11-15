%% runscript
clear all
run inputVars

% parametric variabladdpath(strcat(pwd,'..\code'))es
alphaSweep = 5*pi/180;%linspace(-5,5,10)*pi/180;
taperSweep = 1.0;%[1.0,0.6,0.4,0.0];
sweepSweep = [-45,0,45];
spanSweep  = 4/2;%[4,8,12,20,100]/2;

varOne = taperSweep;
varTwo = alphaSweep;
for i = 1:numel(varOne)
    for j = 1:numel(varTwo)
        fprintf('Solving %d of set %d\n',j,i)
        % reset input variable based on sweep parametric
        geom.span = spanSweep(1);
        geom.taper = taperSweep(i);
        geom.S = geom.span*0.5*geom.chordRoot*(geom.taper+1);
        geom.sweep = atan((geom.chordRoot*(1-geom.taper))/geom.span)*180/pi;
        aero.alpha = alphaSweep(j);

        % Run Program
        [geom] = meshGen(geom);
        [panel] = solverSetup(geom,aero);
        [panel] = gammaSolver(panel,aero);
        [forces] = forceCalc(panel,aero);
        [forces] = coefCalc(geom,aero,panel,forces);

        % Store Key Outputs
        Cl(i,j,:) = forces.Cl;
        Cd(i,j,:) = forces.Cd;
        CL(i,j) = forces.CL;
        CD(i,j) = forces.CD;
    end
end