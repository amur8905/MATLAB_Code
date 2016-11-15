function [panel] = gammaSolver(panel,aero)
% There are two cases here the global one defines the steady or
% unsteady

% Steady/Unsteady Switch Structure: 
switch aero.type

case 'steady'
%% --- Steady Formulation ---

    %% Zero-Thickness Wing
    % Calculate RHS, and set matrix sizes
    rhs         = -sum([panel.Uf;panel.Vf;panel.Wf].*panel.normal);
    up          = zeros(3,panel.NM,panel.NM);
    upi         = zeros(3,panel.NM,panel.NM);
    aic         = zeros(panel.NM,panel.NM);
    bic         = zeros(panel.NM,panel.NM);
    leftMirror  = [1;-1;1];
    for i = 1:panel.NM
        for j = 1:panel.NM
            % Calculate wing and wing image influence
            [up1,upi1]  = vtxElem(panel.rf1(:,j),panel.rf2(:,j),...
                panel.rf3(:,j),panel.rf4(:,j),panel.rc(:,i),panel.gamma(j));
            [up2,upi2]  = vtxElem(panel.rf1(:,j),panel.rf2(:,j),...
                panel.rf3(:,j),panel.rf4(:,j),leftMirror.*panel.rc(:,i),panel.gamma(j));
            % Mirror output of the left image
            up2         = leftMirror.*up2; 
            upi2        = leftMirror.*upi2;
            % Sum up wing and wing image components
            up(:,i,j)   = up1 + up2;
            upi(:,i,j)  = upi1 + upi2;
            % When the scan is at the trailing edge row include wake influence
            if j >(panel.N-1)*panel.M
                k           = j - (panel.N-1)*panel.M;
                [up3,upi3]  = vtxElem(panel.wrf1(:,k),panel.wrf2(:,k),...
                    panel.wrf3(:,k),panel.wrf4(:,k),panel.rc(:,i),panel.wakegamma(k));
                [up4,upi4]  = vtxElem(panel.wrf1(:,k),panel.wrf2(:,k),...
                    panel.wrf3(:,k),panel.wrf4(:,k),leftMirror.*panel.rc(:,i),panel.wakegamma(k));
                % Mirror output of the left image of the wake
                up4          = leftMirror.*up4;
                upi4         = leftMirror.*upi4;
                % Sup up wake and wake image to sum total
                up(:,i,j)    = up(:,i,j) + up3 + up4;
                upi(:,i,j)   = upi(:,i,j) + upi3 + upi4;
            end
            % Calculate aerodynamic influence matrix and downwash matrix
            aic(i,j)    = sum(up(:,i,j).*panel.normal(:,i));
            bic(i,j)    = sum(upi(:,i,j).*panel.normal(:,i));
        end
    end

    % Calculate the required circulation for impermeability
    gama        = aic\rhs';
    panel.wind  = bic*gama;
    panel.gamma  = gama';
    panel.wakegamma = panel.gamma(end-panel.M+1:end);
    panel.rhs   = rhs;
    panel.up    = up;
    panel.upi   = upi;
    panel.aic   = aic;
    panel.bic   = bic;

case 'unsteady'
    
    %% MODIFY FOR UNSTEADY
    % Calculate RHS, and set matrix sizes
    rhs         = -sum([panel.Uf;panel.Vf;panel.Wf].*panel.normal);
    panel.gamma = ones(panel.NM,1);     % reset wing circulation
    up          = zeros(3,panel.NM,panel.NM);
    upi         = zeros(3,panel.NM,panel.NM);
    wup         = zeros(3,panel.NM);
    aic         = zeros(panel.NM,panel.NM);
    bic         = zeros(panel.NM,panel.NM);
    wic         = zeros(1,panel.NM);
    leftMirror  = [1;-1;1];
    for i = 1:panel.NM
        for j = 1:panel.NM
            % Calculate wing and wing image influence
            [up1,upi1]  = vtxElem(panel.rf1(:,j),panel.rf2(:,j),...
                panel.rf3(:,j),panel.rf4(:,j),panel.rc(:,i),panel.gamma(j));
            [up2,upi2]  = vtxElem(panel.rf1(:,j),panel.rf2(:,j),...
                panel.rf3(:,j),panel.rf4(:,j),leftMirror.*panel.rc(:,i),panel.gamma(j));
            % Mirror output of the left image
            up2         = leftMirror.*up2; 
            upi2        = leftMirror.*upi2;
            % Sum up wing and wing image components
            up(:,i,j)   = up1 + up2;
            upi(:,i,j)  = upi1 + upi2;

            % Calculate aerodynamic influence matrix and downwash matrix
            aic(i,j)    = sum(up(:,i,j).*panel.normal(:,i));
            bic(i,j)    = sum(upi(:,i,j).*panel.normal(:,i));
        end
        
        for k = 1:(aero.unsteady.currentTime-1)*panel.wM
            if sqrt(sum(panel.rf4(:,i)-panel.wrf1(:,k))) < 5.0
                % When the scan is at the trailing edge row include wake influence
                [up3]  = vtxElem(panel.wrf1(:,k),panel.wrf2(:,k),...
                    panel.wrf3(:,k),panel.wrf4(:,k),panel.rc(:,i),panel.wakegamma(k));
                [up4]  = vtxElem(panel.wrf1(:,k),panel.wrf2(:,k),...
                    panel.wrf3(:,k),panel.wrf4(:,k),leftMirror.*panel.rc(:,i),panel.wakegamma(k));
                % Mirror output of the left image of the wake
                up4          = leftMirror.*up4;
                % Sup up wake and wake image to sum total
                wup(:,i)    = wup(:,i) + up3 + up4;
            end
        end

        % calculate the net wake induced velocity on panel
        wic(i) = -(wup(1,i)*panel.normal(1,i)+wup(2,i)*panel.normal(2,i)...
            +wup(3,i)*panel.normal(3,i));
    end

    % Calculate the required circulation for impermeability
    gama        = aic\(rhs'+wic');
    panel.wind  = bic*gama;
    panel.gamma  = gama';
    panel.wakegamma = circshift(panel.wakegamma,panel.wM,1);
    panel.wakegamma(1:panel.wM) = panel.gamma(end-panel.M+1:end);
    panel.rhs   = rhs;
    panel.up    = up;
    panel.upi   = upi;
    panel.wup   = wup;
    panel.aic   = aic;
    panel.bic   = bic;
    
end

return