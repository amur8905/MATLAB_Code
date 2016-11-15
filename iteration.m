
for scale = 0:0.1:1
    RunAVL(points,12);
    points = parseAVL('avl/mdoOut.dat',fc);
    %calculate forces onto structural model
    strucForces = zeros(D.n,3);
    strucForces(:,1) = H'*points.force(:,1);
    strucForces(:,2) = H'*points.force(:,2);
    strucForces(:,3) = H'*points.force(:,3);
    
    %load the structure
    D.Load(1:3,:) = scale*[strucForces(:,1) strucForces(:,2) strucForces(:,3)]';
    
    %solve strucutre
    [Q,V,R]=MSA(D);    
    
    %transfer displacements back to wing
    points.position(:,1) = H*(D.Coord(1,:)+V(1,:))';
    points.position(:,2) = H*(D.Coord(2,:)+V(2,:))';
    points.position(:,3) = H*(D.Coord(3,:)+V(3,:))';
    
    %plot aerodynamic loads
%     quiver3(points.position(:,1),points.position(:,2),points.position(:,3),...
%         points.force(:,1),points.force(:,2),points.force(:,3));
    %axis equal
%     view(45,45)
    %hold on
%     tri = delaunay(points.position(:,1),points.position(:,2));
%     h = trisurf(tri, points.position(:,1), points.position(:,2), points.position(:,3));
% pts = 3:4:length(D.Coord(3,1:end-4));
% plot(linspace(0,1,length(D.Coord(3,pts))),(D.Coord(3,pts)+V(3,pts)+D.Coord(3,pts-1)+V(3,pts-1))/2,'k--');
%plot(linspace(0,1,length(D.Coord(3,1:end-4))),D.Coord(3,1:end-4)+V(3,1:end-4),'k--');
%hold on

    
    %plot wing
    plot3(points.position(:,1),points.position(:,2),points.position(:,3),'r.');      
    view(45,45)
%     PlotStructure(D.Coord+V(1:3,:),D.Con);
    %hold off
    %recalculate aerodynamic loads
    
    pause(0);
end

for i = 1:3
    %calculate forces onto structural model
    strucForces = zeros(D.n,3);
    strucForces(:,1) = H'*points.force(:,1);
    strucForces(:,2) = H'*points.force(:,2);
    strucForces(:,3) = H'*points.force(:,3);
    
    %load the structure
    D.Load(1:3,:) = 1*[strucForces(:,1) strucForces(:,2) strucForces(:,3)]';
    
    %solve strucutre
    [Q,V,R]=MSA(D);    
    
    %transfer displacements back to wing
    points.position(:,1) = H*(D.Coord(1,:)+V(1,:))';
    points.position(:,2) = H*(D.Coord(2,:)+V(2,:))';
    points.position(:,3) = H*(D.Coord(3,:)+V(3,:))';
    
    %plot wing
    %plot3(points.position(:,1),points.position(:,2),points.position(:,3),'b.');
    %axis equal
    %hold on   
    %PlotStructure(D.Coord+V(1:3,:),D.Con);
    %hold off

%plot(linspace(0,1,length(D.Coord(3,1:end-4))),D.Coord(3,1:end-4)+V(3,1:end-4),'k-');
%hold on

    %recalculate aerodynamic loads
    RunAVL(points,12);
    points = parseAVL('avl/mdoOut.dat',fc);
    pause(0);
end 

    

