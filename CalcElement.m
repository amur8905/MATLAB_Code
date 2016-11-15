function out = CalcElement(m,n)
tqc = getTQC(m);
xm = tqc(2);
ym = tqc(1);

qcl = getQCL(n);
qcr = getQCR(n);
x1n = qcl(2);
y1n = qcl(1);
x2n = qcr(2);
y2n = qcr(1);

A = 1/((xm-x1n)*(ym-y2n) - (xm-x2n)*(ym-y1n));
B = ((x2n-x1n)*(xm-x1n)+(y2n-y1n)*(ym-y1n))/sqrt((xm-x1n)^2 + (ym-y1n)^2);
C = ((x2n-x1n)*(xm-x2n)+(y2n-y1n)*(ym-y2n))/sqrt((xm-x2n)^2 + (ym-y2n)^2);
D = 1/(y1n-ym)*(1 + (xm-x1n)/sqrt((xm-x1n)^2 + (ym-y1n)^2));
E = 1/(y2n-ym)*(1 + (xm-x2n)/sqrt((xm-x2n)^2 + (ym-y2n)^2));

out = 1/(4*pi)*(A*(B-C)+D-E);

if isnan(out)
    warning('element was NaN')
end

end
