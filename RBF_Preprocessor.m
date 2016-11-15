function H = RBF_Preprocessor(Xs,Xa,degP,rbf,radius)
Ns = length(Xs(:,1));
Na = length(Xa(:,1));

%build the components of the Css matrix
Ps = [];
for k = 0:degP
    for j = 0:degP
        for i = 0:degP
            if i+j+k <= degP
                Ps = [Ps; (Xs(:,1).^i.*Xs(:,2).^j.*Xs(:,3).^k)'];
            end
        end
    end
end
M = zeros(Ns);
for i = 1:Ns
    for j = 1:Ns
        M(i,j) = RBF(rbf,radius,Xs(i,:),Xs(j,:));
    end
end
Mi = inv(M);
%P(4,:) = P(4,:) + 1;
Pst = Ps';
Mp = inv(Ps*Mi*Pst);

%build Aas matrix
Pa = [];
for k = 0:degP
    for j = 0:degP
        for i = 0:degP
            if i+j+k <= degP
                Pa = [Pa Xa(:,1).^i.*Xa(:,2).^j.*Xa(:,3).^k];
            end
        end
    end
end
right = zeros(Na,Ns);
for i = 1:Na
    for j = 1:Ns
        right(i,j) = RBF(rbf,radius,Xa(i,:),Xs(j,:));
    end
end
Aas = [Pa right];

%construct coupling matrix
H = Aas*[Mp*Ps*Mi; Mi - Mi*Pst*Mp*Ps*Mi];
if degP == 0
    Aas = right;
    H = Aas*Mi;
end
end

function out = RBF(rbf,r,X,Xc)
Xnorm = sqrt((X(:,1) - Xc(:,1)).^2 + (X(:,2) - Xc(:,2)).^2 + (X(:,3) - Xc(:,3)).^2);
x = Xnorm/r;
switch rbf
    case 'C0'
        out = (1-x).^2;
        if Xnorm > r
            out = 0;
        end
    case 'C2'
        out = (1 - x).^4.*(4*x + 1);
        if Xnorm > r
            out = 0;
        end
    case 'C4'
        out = (1-x).^6.*(35*x.^2+18*x+3)/3;
        if Xnorm > r
            out = 0;
        end
    case 'C6'
        out = (1-x).^8.*(32*x.^3+25*x.^2+8*x+1);
        if Xnorm > r
            out = 0;
        end
    case 'Euclid'
        out = pi*((1/12*x.^3)-0.5^2*x+4/3*0.5^3)/(pi*(-0.5^2*0+4/3*0.5^3));
        if Xnorm > r
            out = 0;
        end
    case 'Multiquadric'
        out = sqrt(1+x.^2);
    case 'InverseMulti'
        out = 1./sqrt(1+x.^2);
    case 'TPS'
        out = x.^2*log(x);
    case 'Gaussian'
        out = exp(-x.^2);
    otherwise
        error('RBF not recognised.');
end
if isnan(out)
    out = 0;
end
end