function quads = GenQuadMesh(cX,cY,sizeX,resY)
%% initial data prep 

%determine if the top edge or bottom edge is smaller
minXWidth = min(cX(1,2)-cX(1,1),cX(2,2)-cX(2,1));
minYIndex = 1;
if cX(2,2)-cX(2,1) == minXWidth
    minYIndex = 2;
end    

%change from counting quads to counting lines
resX = 2;
for iPix = cX(minYIndex,1)+1:cX(minYIndex,2)-1
    if mod(iPix,sizeX) == 0
        resX = resX + 1;
    end
end
resY = resY+1;

%% determine coordinates of all interior geometry

X = zeros(resY,resX);
Y = zeros(resY,resX);

%left edge
X(:,1) = linspace(cX(1,1),cX(2,1),resY);
Y(:,1) = linspace(cY(1,1),cY(2,1),resY);

%right edge
X(:,resX) = linspace(cX(1,2),cX(2,2),resY);
Y(:,resX) = linspace(cY(1,2),cY(2,2),resY);

%calculate to start from top or bottom left corner
xStart = X(1,1);
if xStart < X(resY,1)
    xStart = X(resY,1);
end

%calculate interior points
for iY = 1:resY   
    rise = Y(iY,resX)-Y(iY,1);
    run = X(iY,resX)-X(iY,1);
    slope = rise/run;
    for iX = 2:resX-1
        X(iY,iX) = sizeX*(floor(xStart/sizeX)) + sizeX*(iX-1);
        Y(iY,iX) = Y(iY,1) + slope*(X(iY,iX)-X(iY,1));
    end
end

%% create and return array of quads

%initialise
quads = Quad.empty(0,0);

%create individual quads and return
for iY = 1:resY-1
    for iX = 1:resX-1
        q = Quad;
        q.cnrX = [X(iY,iX), X(iY,iX+1);X(iY+1,iX), X(iY+1,iX+1)];
        q.cnrY = [Y(iY,iX), Y(iY,iX+1);Y(iY+1,iX), Y(iY+1,iX+1)]; 
        quads = [quads q];
    end
end

end

