function RunAVL(points, chordWisePanels)
numPts = length(points.position(:,1));

%reconstruct leading edge
leElements = 1:chordWisePanels:numPts;
dx = points.dx(leElements);
lePoints = points.position(leElements,:);
lex = zeros(1,length(leElements)+1);
ley = zeros(1,length(leElements)+1);
lez = zeros(1,length(leElements)+1);
for i = 1:length(leElements)-1
    lex(i) = lePoints(i,1) - (lePoints(i+1,1)-lePoints(i,1))/2 - dx(i);
    ley(i) = lePoints(i,2) - (lePoints(i+1,2)-lePoints(i,2))/2;
    lez(i) = lePoints(i,3) - (lePoints(i+1,3)-lePoints(i,3))/2;
end
%set end points
lex(end-1) = lePoints(end,1) - (lePoints(end,1)-lePoints(end-1,1))/2 - dx(end);
ley(end-1) = lePoints(end,2) - (lePoints(end,2)-lePoints(end-1,2))/2;
lez(end-1) = lePoints(end,3) - (lePoints(end,3)-lePoints(end-1,3))/2;

lex(end) = lePoints(end,1) + (lePoints(end,1)-lePoints(end-1,1))/2 - dx(end);
ley(end) = lePoints(end,2) + (lePoints(end,2)-lePoints(end-1,2))/2;
lez(end) = lePoints(end,3) + (lePoints(end,3)-lePoints(end-1,3))/2;

%reconstruct trailing edge
teElements = chordWisePanels:chordWisePanels:numPts;
dx = points.dx(teElements);
tePoints = points.position(teElements,:);
tex = zeros(1,length(teElements)+1);
tey = zeros(1,length(teElements)+1);
tez = zeros(1,length(teElements)+1);
for i = 1:length(teElements)-1
    tex(i) = tePoints(i,1) - (tePoints(i+1,1)-tePoints(i,1))/2 + dx(i);
    tey(i) = tePoints(i,2) - (tePoints(i+1,2)-tePoints(i,2))/2;
    tez(i) = tePoints(i,3) - (tePoints(i+1,3)-tePoints(i,3))/2;
end
%set end points
tex(end-1) = tePoints(end,1) - (tePoints(end,1)-tePoints(end-1,1))/2 + dx(end);
tey(end-1) = tePoints(end,2) - (tePoints(end,2)-tePoints(end-1,2))/2;
tez(end-1) = tePoints(end,3) - (tePoints(end,3)-tePoints(end-1,3))/2;

tex(end) = tePoints(end,1) + (tePoints(end,1)-tePoints(end-1,1))/2 + dx(end);
tey(end) = tePoints(end,2) + (tePoints(end,2)-tePoints(end-1,2))/2;
tez(end) = tePoints(end,3) + (tePoints(end,3)-tePoints(end-1,3))/2;

% plot3(lex,ley,lez,'k.');
% hold on
% plot3(tex,tey,tez,'k.');
% plot3(points.position(:,1),points.position(:,2),points.position(:,3),'g.');

chords = tex-lex;%sqrt((lex-tex).^2+(ley-tey).^2+(lez-tez).^2);
fid = fopen('avl/mdo.avl','w');
fprintf(fid,'testWing\n');
fprintf(fid,'0.0\n'); 
fprintf(fid,'1     0     0.0\n');
fprintf(fid,'306.31   10.33   35\n');
fprintf(fid,'0.0   0.0   0.0\n');
fprintf(fid,'0.020\n');
fprintf(fid,'SURFACE\n');
fprintf(fid,'Main Surface\n');
fprintf(fid,'12 0.0\n');
fprintf(fid,'ANGLE\n');
fprintf(fid,'0.0\n');
for i=1:length(lex)
    fprintf(fid,'SECTION\n');
    fprintf(fid,'%f %f %f %f %f %f %f\n',lex(i),ley(i),lez(i),chords(i),0,1,0);
    fprintf(fid,'NACA\n');
    fprintf(fid,'4412\n');
end
fclose(fid);

dos('avl\avl.exe < avl\runscript.run');
end