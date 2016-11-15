%% Test Plotting
cla
switch aero.type
    case 'steady'
        figure(1);
        hold on
        MESHX = [reshape(panel.rf1(1,:),panel.M,panel.N)', panel.rf2(1,panel.M:panel.M:end)'];
        MESHX = [MESHX;[panel.rf4(1,end-panel.M+1:end), panel.rf3(1,end)]];
        MESHY = [ reshape(panel.rf1(2,:),panel.M,panel.N)', panel.rf2(2,panel.M:panel.M:end)'];
        MESHY = [MESHY;[panel.rf4(2,end-panel.M+1:end), panel.rf3(2,end)]];
        MESHZ = [ reshape(panel.rf1(3,:),panel.M,panel.N)', panel.rf2(3,panel.M:panel.M:end)'];
        MESHZ = [MESHZ;[panel.rf4(3,end-panel.M+1:end), panel.rf3(3,end)]];

        WAKEMESHX = [reshape(panel.wrf1(1,:),panel.wM,panel.wN)',panel.wrf2(1,end)];
        WAKEMESHX = [WAKEMESHX;panel.wrf4(1,end-panel.wM+1:end),panel.wrf3(1,end)];
        WAKEMESHY = [reshape(panel.wrf1(2,:),panel.wM,panel.wN)',panel.wrf2(2,end)];
        WAKEMESHY = [WAKEMESHY;panel.wrf4(2,end-panel.wM+1:end),panel.wrf3(2,end)];
        WAKEMESHZ = [reshape(panel.wrf1(3,:),panel.wM,panel.wN)',panel.wrf2(3,end)];
        WAKEMESHZ = [WAKEMESHZ;panel.wrf4(3,end-panel.wM+1:end),panel.wrf3(3,end)];

        figure(1);
        hold on
        mesh(MESHX,MESHY,MESHZ)
        mesh(WAKEMESHX,WAKEMESHY,WAKEMESHZ)
        alpha 0.7
        plot3(panel.rc(1,:),panel.rc(2,:),panel.rc(3,:),'xr')
%         quiver3(panel.rc(1,:),panel.rc(2,:),panel.rc(3,:)...
%             ,panel.normal(1,:),panel.normal(2,:),panel.normal(3,:))
        axis equal
        hold off
    case 'unsteady'
        figure(1);
        hold on
        MESHX = [reshape(panel.rf1(1,:),panel.M,panel.N)', panel.rf2(1,panel.M:panel.M:end)'];
        MESHX = [MESHX;[panel.rf4(1,end-panel.M+1:end), panel.rf3(1,end)]];
        MESHY = [ reshape(panel.rf1(2,:),panel.M,panel.N)', panel.rf2(2,panel.M:panel.M:end)'];
        MESHY = [MESHY;[panel.rf4(2,end-panel.M+1:end), panel.rf3(2,end)]];
        MESHZ = [ reshape(panel.rf1(3,:),panel.M,panel.N)', panel.rf2(3,panel.M:panel.M:end)'];
        MESHZ = [MESHZ;[panel.rf4(3,end-panel.M+1:end), panel.rf3(3,end)]];

        WAKEMESHX = [reshape(panel.wrf1(1,:),panel.wM,panel.wN)',panel.wrf2(1,panel.wM:panel.wM:end)'];
        WAKEMESHX = [WAKEMESHX;panel.wrf4(1,end-panel.wM+1:end),panel.wrf3(1,end)];
        WAKEMESHY = [reshape(panel.wrf1(2,:),panel.wM,panel.wN)',panel.wrf2(2,panel.wM:panel.wM:end)'];
        WAKEMESHY = [WAKEMESHY;panel.wrf4(2,end-panel.wM+1:end),panel.wrf3(2,end)];
        WAKEMESHZ = [reshape(panel.wrf1(3,:),panel.wM,panel.wN)',panel.wrf2(3,panel.wM:panel.wM:end)'];
        WAKEMESHZ = [WAKEMESHZ;panel.wrf4(3,end-panel.wM+1:end),panel.wrf3(3,end)];

        figure(1);
        hold on
        mesh(MESHX,MESHY,MESHZ)
        mesh(WAKEMESHX,WAKEMESHY,WAKEMESHZ)
        alpha 0.7
        plot3(panel.rc(1,:),panel.rc(2,:),panel.rc(3,:),'xr')
%         quiver3(panel.rc(1,:),panel.rc(2,:),panel.rc(3,:)...
%             ,panel.normal(1,:),panel.normal(2,:),panel.normal(3,:))
        PlotStructure(D.Coord,D.Con);
        plot3(aeroPts(1,:),aeroPts(2,:),aeroPts(3,:),'k.');
        axis equal
        view(-45,15)
        %hold off
end