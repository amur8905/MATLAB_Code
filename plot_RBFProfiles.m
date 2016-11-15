close all
set(0,'defaultLineLineWidth', 2)
X = linspace(0,2.5);
figure
hold on

r=0.5;
x = X/2;
plot(X,(1-x).^2); %wendland C0
plot(X,(1-x).^4.*(4*x + 1)); %wendland C2
plot(X,(1-x).^6.*(35*x.^2+18*x+3)/3); %wendland C4
plot(X,(1-x).^8.*(32*x.^3+25*x.^2+8*x+1)); %wendland C6
plot(X,pi*((1/12*x.^3)-r^2*x+4/3*r^3)/(pi*(-r^2*0+4/3*r^3))); %euclid's hat
legend('Wendland C0', 'Wendland C2', 'Wendland C4', 'Wendland C6','Euclid Hat');
xlabel('r');
ylabel('\phi(r)');

figure 
hold on
X = linspace(0,2.1);
x = X/2;
plot(X,x.^2.*log(x)); %thin plate spline
plot(X,exp(-x.^2)); %gaussian
plot(X,sqrt(1+x.^2)); %multiquadric
plot(X,1./sqrt(1+x.^2)); %inverse multiquadric
legend('Thin Plate Spline','Gaussian','Multiquadric','Inverse Multiquadric');
xlabel('r');
ylabel('\phi(r)');
xlim([0,2.1]);

set(0,'defaultLineLineWidth', 1)