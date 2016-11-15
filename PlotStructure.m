function out = PlotStructure(nodes,connections)
con = connections';
nod = nodes';
% figure
% hold on
% axis equal
for i = 1:length(con)
    ind1 = con(i,1);
    ind2 = con(i,2);
    x = nod([ind1 ind2],1);
    y = nod([ind1 ind2],2);
    z = nod([ind1 ind2],3);
    plot3(x,y,z,'k-');
    plot3(x,y,z,'ro');
end