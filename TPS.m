clear all
n = 64; t = linspace(0,2*pi,n+1); t(end) = [];
values = [cos(t); sin(t)];
centers = values./repmat(max(abs(values)),2,1);
%centers(1,:) = centers(1,:);
stx = tpaps(centers, values(1,:), 1);
sty = tpaps(centers, values(2,:), 1);
%fnplt(st), axis equal
%plot(centers(1,:), centers(2,:),'.')
%hold on
%plot(values(1,:), values(2,:),'.')
%axis equal