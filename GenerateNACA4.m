%calculates the data of a NACA 4 series aerofoil
%IN
%N4: the 4 digit NACA specifications
%c: chord length
%res: number of data points along top and bottom of aerofoil
%fName: file name of data file to write

%OUT
%afData: the data for the aerofoil, consists a vector of coordinates

function afData = GenerateNACA4(N4, c, res, fName)

%all values are expressed as a fraction of the chord
m = floor(N4/1000)/100; %max camber (first digit)
p = floor(N4/100)/100; %location of max camber (second digit)
t = mod(N4,100)/100; %max thickness (last two digits)

%yt = 0;
%yc = 0;
dycdx = 0;
afData = zeros(2*res,2);
iDataIndex = 1;
data = [];

for x = 1-(2*cos(pi*linspace(0,1,res))/2 + 1)/2
    %max thickness at 40%
    if x/c <= 0.4
        yt = 5*t*c*(0.2969*sqrt(x/c) - 0.246867*(x/c) + 0.175384*(x/c)^2 - 0.266917*(x/c)^3);
    else
        yt = 5*t*c*(0.002 + 0.315*(1-x/c) - 0.2333333*(1-x/c)^2 - 0.032407*(1-x/c)^3);
    end
    
    %max thickness at 30%
    %yt = 5*t*c*(0.2969*sqrt(x/c) - 0.1260*(x/c) - 0.3516*(x/c)^2 + 0.2843*(x/c)^3 - 0.1015*(x/c)^4);
    if x <= p*c
        yc = m*(x/p^2)*(2*p - x/c);
        dycdx = 2*m/p^2*(p - x/c);
    elseif x > p*c
        yc = m*((c-x)/(1-p)^2)*(1 + x/c - 2*p);
        dycdx = 2*m/(1-p)^2*(p-x/c);
    end
    theta = atan(dycdx);
    xu = x - yt*sin(theta);
    xl = x + yt*sin(theta);
    yu = yc + yt*cos(theta);
    yl = yc - yt*cos(theta);
    
    afData(iDataIndex,:) = [xu,yu];
    afData(iDataIndex+res,:) = [xl,yl];
    iDataIndex = iDataIndex + 1;
    
    data = [data; x yu yl];
    
%      hold on 
%      plot(x,yc,'r.');
%      plot(xu,yu,'b.');
%      plot(xl,yl,'b.');
%      axis equal;  
end

%print data to file
fid = fopen(fName,'w');

%top surface
for i = res:-1:1
    x = data(i,1);
    y = data(i,2);
    fprintf(fid,'%f,%f\n',x,y);
end

%bottom surface
for i = 2:res
    x = data(i,1);
    y = data(i,3);
    fprintf(fid,'%f,%f\n',x,y);
end
fclose(fid);

end

