classdef Quad3D
    %data and methods for an aerodynamic quadrilateral
    
    properties
        cnrX; %x coordinates of corners
        cnrY; %y coordinates of corners
        cnrZ; %z coordinates of corners
        normal; %normal vector
        lift;
    end
    
    methods
        
        %find the 'average' normal
        function norm = getNormal(obj)
            X = obj.cnrX;
            Y = obj.cnrY;
            Z = obj.cnrZ;
            V1 = [X(1,1),Y(1,1),Z(1,1)] - [X(2,2),Y(2,2),Z(2,2)];
            V2 = [X(1,2),Y(1,2),Z(1,2)] - [X(2,1),Y(2,1),Z(2,1)];
            obj.normal = cross(V1,V2)/norm(cross(V1,V2); %counterclockwise positive orientation
            return obj.normal;
        
        %center 3/4 chord
        function tqc = getTQC(obj)
            X = obj.cnrX;
            Y = obj.cnrY;
            dxdyL = (X(2,1) - X(1,1))/(Y(2,1) - Y(1,1));
            dxdyR = (X(2,2) - X(1,2))/(Y(2,2) - Y(1,2));
            tqcYL = Y(1,1) - (Y(1,1) - Y(2,1))*3/4;
            tqcXL = X(1,1) + dxdyL*(tqcYL - Y(1,1));
            tqcYR = Y(1,2) - (Y(1,2) - Y(2,2))*3/4;
            tqcXR = X(1,2) + dxdyR*(tqcYL - Y(1,2));
            tqcX = (tqcXL + tqcXR)/2;
            tqcY = (tqcYL + tqcYR)/2;
            tqc = [tqcX,tqcY];
        end
        
        %left 1/4 chord
        function qcl = getQCL(obj)
            X = obj.cnrX;
            Y = obj.cnrY;
            dxdy = (X(2,1) - X(1,1))/(Y(2,1) - Y(1,1));
            qclY = Y(1,1) - (Y(1,1) - Y(2,1))/4;
            qclX = X(1,1) + dxdy*(qclY - Y(1,1));
            qcl = [qclX,qclY];
        end
        
        %right 1/4 chord
        function qcr = getQCR(obj)
            X = obj.cnrX;
            Y = obj.cnrY;
            dxdy = (X(2,2) - X(1,2))/(Y(2,2) - Y(1,2));
            qcrY = Y(1,2) - (Y(1,2) - Y(2,2))/4;
            qcrX = X(1,2) + dxdy*(qcrY - Y(1,2));
            qcr = [qcrX,qcrY];
        end
    end
    
end

