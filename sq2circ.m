set(0, 'defaultTextInterpreter', 'latex'); 
n = 64; t = linspace(0,2*pi,n+1); t(end) = [];
values = [cos(t); sin(t)];
centers = values./repmat(max(abs(values)),2,1);
st = tpaps(centers, values(1,:), 1);
fnplt(st), axis equal
hold on
plot3(centers(1,:),centers(2,:),values(1,:),'ro','LineWidth',5)
xlabel('$$x$$');
ylabel('$$y$$');
zlabel('$$\overline{x}$$');

