clear

%% generate the aircraft geometry

%target width of internal quads
sizeX = 50;

%fuselage
quads = GenQuadMesh([0,17;0,25],[8,43;76,76],sizeX,3);
quads = [quads GenQuadMesh([0,25;0,30],[76,76;132,132],sizeX,3)];
quads = [quads GenQuadMesh([0,30;0,30],[132,132;302,302],sizeX,3)];
quads = [quads GenQuadMesh([0,30;0,30],[302,302;484,484],sizeX,3)];
quads = [quads GenQuadMesh([0,30;0,30],[484,484;562,562],sizeX,3)];
quads = [quads GenQuadMesh([0,30;0,30],[562,562;670,670],sizeX,3)];
quads = [quads GenQuadMesh([30,60;30,53],[484,484;562,562],sizeX,3)];
quads = [quads GenQuadMesh([30,53;30,53],[562,562;670,670],sizeX,3)];

%wing
quads = [quads GenQuadMesh([30,60;30,60],[302,308;484,484],sizeX,3)];
quads = [quads GenQuadMesh([60,640;60,640],[308,410;484,455],sizeX,3)];

%tail
quads = [quads GenQuadMesh([53,200;53,200],[562,622;670,662],sizeX,3)];

%mirror the geometry
for iQuads = quads
    newQuad = iQuads;
    newQuad.cnrX = fliplr(-newQuad.cnrX);
    newQuad.cnrY = fliplr(newQuad.cnrY);
    quads = [quads newQuad];
end

%% calculate the list distribution
w = zeros(length(quads),length(quads));
for m = 1:length(quads)
    for n = 1:length(quads)
        w(m,n) = CalcElement(quads(m),quads(n));        
    end
end

alpha = zeros(size(quads))';
alpha = (pi/180)*(alpha + 5);
U = -100;

X = linsolve(w,U*alpha); 

for quadItr = 1:length(quads)
    quads(quadItr).lift = X(quadItr);
end


%% plot the 2D data
figure
hold on
axis equal
surface = [];
planemesh = [];
for iQuads = quads
    mesh(iQuads.cnrY, iQuads.cnrX, zeros(size(iQuads.cnrX)));
    tqc = getTQC(iQuads);
    qcr = getQCR(iQuads);
    qcl = getQCL(iQuads);
    %plot(tqc(2),tqc(1),'b.');
    %plot(qcr(2),qcr(1),'r.');
    %plot(qcl(2),qcl(1),'r.');   
    %normalise the lifts and prepare for interpolation
    plot3(tqc(2),tqc(1),iQuads.lift,'b.');
    surface = [surface; [tqc(2),tqc(1),-iQuads.lift/max(X)]];
end


%% plot an interpolated mesh showing lift over the aircraft

% %set up the interpolation
% xq = 0:10:680;
% yq = -660:10:660;
% [X,Y] = meshgrid(xq,yq);
% surface = [surface; [0 -660 0]; [0 660 0]];
% vq = gridfit(surface(:,1), surface(:,2), surface(:,3), xq, yq);
% 
% %don't plot points outside the geometry (needs optimising)
% for xi = 1:length(xq)
%     for yi = 1:length(yq)
%         in = false;
%         for iq = quads
%             x = [iq.cnrY(:,1);flipud(iq.cnrY(:,2))];
%             y = [iq.cnrX(:,1);flipud(iq.cnrX(:,2))];
%             [isIn,isOn] = inpolygon(xq(xi),yq(yi),x,y);
%             if isIn || isOn
%                 in = true;
%                 break;
%             end            
%         end
%         if ~in
%             X(yi,xi) = NaN;
%             Y(yi,xi) = NaN;
%         end
%     end
% end
% 
% %plot the mesh with some scaling for readibility
% mesh(X,Y,5*vq);
    