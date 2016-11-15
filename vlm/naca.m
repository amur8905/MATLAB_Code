function [out] = naca(number,n,dist)

% NACA profile generator, adapted from the NACA program
% mean line and thickness;
if size(number,2) == 4
    series = 4;
elseif size(number,2) == 5
    series = 5;
end

switch series
% x_u = x - y_t*sin t; x_l = x + y_t*cos t
% y_u = y_c - y_t*cos t; y_l = y_c - y_t*sin t

% NACA 4 series
    case 4
        % extract information
        m = 0.01*str2double(number(1));
        p = 0.1*str2double(number(2));
        t = 0.01*str2double(number(3:4));
        
        % number of points;
        switch dist
            case 'linear'
                xa = linspace(0,1,n)';
            case 'cosine'
                xa = 0.5*(1-cos(linspace(0,pi,n)'));
            case 'halfcos'
                xa = 1 - cos(linspace(0,pi/2,n)');
        end
        
        % airfoil thickness
        yt = t/0.20 * (0.2969*sqrt(xa) - 0.126*xa - 0.3516*xa.^2 +...
            0.2843*xa.^3 - 0.1015*xa.^4);
        
        % airfoil camber and derivatives
        marker = find(xa < p,1, 'last');
        if isempty(marker) 
            yc = zeros(n,1);
            dyc = zeros(n,1);
        else
            yc = (m/p^2)*(2*p*xa(1:marker) - xa(1:marker).^2);
            yc = [yc; (m/(1-p)^2)*(1-2*p + 2*p*xa(marker+1:end) - xa(marker+1:end).^2)];
        
            dyc = (2*m/p^2)*(p - xa(1:marker));
            dyc = [dyc; (2*m/(1-p)^2)*(p - xa(marker+1:end))];
        end
        
        theta = atan(dyc);
        theta(1:find(xa<=0.05,1,'last')) = theta(find(xa<=0.05,1,'last'));
        
        % airfoil profile 
        out.x.upper = xa - yt.*sin(theta);
        out.y.upper = yc + yt.*cos(theta);
        out.x.lower = xa + yt.*sin(theta);
        out.y.lower = yc - yt.*cos(theta);
        % rescale x
        
        out.xc = xa;
        out.yc = yc;
        
        % extra data
        out.rle = 1.1019*t^2;
        out.dte = 2*atan(1.16925*t);
        out.airfoilID = ['NACA ',number];
        
% NACA 5 series
    case 5
        % extract information
        L = 0.1*str2double(number(1)); % camber Cl = 3/2*L
        P = 0.1*str2double(number(2)); % xf = P/2
        Q = str2double(number(3)); % standard/reflexed [0/1]
        t = 0.01*str2double(number(4:5)); % thickness
        % number of points;
        switch dist
            case 'linear'
                xa = linspace(0,1,n)';
            case 'cosine'
                xa = 0.5*(1-cos(linspace(0,pi,n)'));
            case 'halfcos'
                xa = 1 - cos(linspace(0,pi/2,n)');
        end
        
        % airfoil thickness
        yt = t/0.20 * (0.2969*sqrt(xa) - 0.126*xa - 0.3516*xa.^2 +...
            0.2843*xa.^3 - 0.1015*xa.^4);
        
        % calculate coefficients;
        mRange = linspace(0,1,1000);
        xfr = mRange.*(1-sqrt(mRange./3));
        m = interp1(xfr,mRange,P/2,'pchip');
        QQ = (3*m - 7*m^2 + 8*m^3 - 4*m^4)/(sqrt(m*(1-m))) - ...
            3/2 *(1-2*m)*(pi/2 - asin(1-2*m));
        K1 = 6*(3/2*L)/QQ;
        
        switch Q
            case 0
            % airfoil camber and derivatives
                marker = find(xa < m,1, 'last');
                yc = K1/6 * (xa(1:marker).^3 - 3*m*xa(1:marker).^2 + m^2*(3-m)*(xa(1:marker)));
                yc = [yc; K1/6 * m^3 *(1- xa(marker+1:end))];

                dyc = K1/6 * (3*(xa(1:marker).^2) - 6*m*xa(1:marker) + m^2*(3-m));
                dyc = [dyc; -K1/6 * m^3 * ones(n-marker,1)];
            case 1
        end
        
        
        
        theta = atan(dyc);
        theta(1:find(xa<=0.05,1,'last')) = theta(find(xa<=0.05,1,'last'));
        
        % airfoil profile 
        out.x.upper = xa - yt.*sin(theta);
        out.y.upper = yc + yt.*cos(theta);
        out.x.lower = xa + yt.*sin(theta);
        out.y.lower = yc - yt.*cos(theta);
        % rescale x
        
        out.xc = xa;
        out.yc = yc;
        
        % extra data
        %out.rle = 1.1019*t^2;
        %out.dte = 2*atan(1.16925*t);
        out.airfoilID = ['NACA ',number];
        
% yt  = same as above

% yc    = 1/6 * k * (x^3 - 3mx^2 + m^2(3-m)x)
%       = 1/6 * k * m^3 (1-x)

% Modified series






end