% Solve the boar population with wolves, hunting and deer
%% Wolves
clearvars
clc
close all

r=0.48;
c=0.01;
d=0.24;
e=0.005; % how much wild boars a wolve should eat to reproduce

N_ini=100;
W_ini=25;

N_store=[];
W_store=[];
T_store=[];

N = N_ini;
W = W_ini;
time = 0;
iter = 0;
dt=0.01; %years small dt to keep it in balance

%% Numerical

while time<100
    iter = iter+1;
    time=time+dt;
    dN=r.*N-c.*W.*N;
    dW=-d.*W+e.*N.*W;
    N=N+dN*dt;
    W=W+dW*dt;
    N_store(iter)=N;
    W_store(iter)=W;
    T_store(iter)=time;
end

figure(1);
subplot(2,1,1)
plot(T_store,N_store, 'k')
hold on
plot(T_store,W_store,'r')
xlabel('Time');
ylabel('N');
legend('Wild boars','Wolves')
title('Evolution boar and wolve population')

subplot(2,1,2)
plot(N_store,W_store, 'k')
xlabel('N')
ylabel('W')

%% Analytic error: check correctness of numerical solutions
clearvars
clc

r=0.48;
c=0.01;
d=0.24;
e=0.005; % how much wild boars a wolve should eat to reproduce

N_ini=100;
W_ini=25;

N_store=[];
W_store=[];
T_store=[];

N = N_ini;
W = W_ini;
time = 0;
iter = 0;
dt=0.01; %years small dt to keep it in balance

Fcheck=@(N,W,r,c,d,e) d*log(N)-e*N+r*log(W)-c*W;

% calculate constant using initial values
Cst=Fcheck(N_ini,W_ini,r,c,d,e);

% Correct numerical solutions? Depends on dt!
%Diff_Num_An=Cst-Fcheck(N_store,W_store,r,c,d,e);

time = 0;
iter = 0;
steps=linspace(0.00001,0.01,20);
RMSE=zeros(1,length(steps));
time_error=zeros(1,length(steps));

for i=1:numel(steps)
    tic;
    dt=steps(i);
    N_store=[];
    W_store=[];
    T_store=[];
    N = N_ini;
    W = W_ini;
    time = 0;
    iter = 0;
    
    while time<100
        iter = iter+1;
        time=time+dt;
        dN=r.*N-c.*W.*N;
        dW=-d.*W+e.*N.*W;
        N=N+dN*dt;
        W=W+dW*dt;
        N_store(iter)=N;
        W_store(iter)=W;
        T_store(iter)=time;
    end

    Diff_Num_An=Cst-Fcheck(N_store,W_store,r,c,d,e);
    RMSE(i)=(sum((Diff_Num_An).^2)/length(T_store)).^0.5;
    
    if RMSE(i)<0.00001*Cst
        time_error(i)=RMSE(i);
    end
    
    calc = toc;
    calcTime(i) = calc;
end

figure(2);
subplot(2,1,1)
plot(steps,RMSE);
title('RMSE versus time step')
xlabel('Time step')
ylabel('RMSE')

subplot(2,1,2)
plot(steps,calcTime)
title('Time step versus calculation time')
xlabel('Time step')
ylabel('Calculation time')

%% ode45
clearvars
clc

r=0.48;
c=0.01;
d=0.24;
e=0.005;

N_ini=100;
W_ini=50;

%odefun_handle = @(t,y) [ry(1)-cy(2)*y(1);-dy(2)+ey(1)*y(2)];

tspan=[0 100];
y0=[N_ini; W_ini];
options = odeset('RelTol',1e-3,'AbsTol',1e-4);
[t,y]=ode45(@(t,y) odefun(t,y,r,c,d,e),tspan,y0,options);

figure(3);
subplot(2,1,1)
plot(t,y(:,1));
hold on
plot(t,y(:,2));
xlabel('Time');
ylabel('N');
legend('Wild boars','Wolves')
title('Evolution boar and wolve population')

subplot(2,1,2)
plot(y(:,1),y(:,2), 'k')
xlabel('N')
ylabel('W')
title('Boars versus Wolves')

%% Human hunting
clearvars
clc

r=0.48;
c=0.01;
d=0.24;
e=0.005;

N_ini=100;
W_ini=25;

h = 0.50;
tspan=[0 90];
y0=[N_ini; W_ini];
odefun2 = @(t,y) [r*y(1)-c*y(2)*y(1)-h;-d*y(2)+e*y(1)*y(2)];
[t2,y2]=ode45(odefun2,tspan,y0);

figure(4);
subplot(2,1,1)
plot(t2,y2(:,1));
hold on
plot(t2,y2(:,2));
xlabel('Time');
ylabel('N');
legend('Wild boars','Wolves')
title('Evolution boar and wolve population with hunting')

subplot(2,1,2)
plot(y2(:,1),y2(:,2), 'k')
xlabel('N')
ylabel('W')
title('Boars versus Wolves')

%% Smart hunting
clearvars
clc

r=0.48;
c=0.01;
d=0.24;
e=0.005; % how much wild boars a wolve should eat to reproduce

N_ini=100;
W_ini=25;

alpha=0.1;
tspan=[0 90];
y0=[N_ini; W_ini];
odefun2 = @(t,y) [r*y(1)-c*y(2)*y(1)-alpha*y(1);-d*y(2)+e*y(1)*y(2)];
[t2,y2]=ode45(odefun2,tspan,y0);

figure(5);
subplot(2,1,1)
plot(t2,y2(:,1));
hold on
plot(t2,y2(:,2));
xlabel('Time');
ylabel('N');
legend('Wild boars','Wolves')
title('Evolution boar and wolve population with smart hunting')

subplot(2,1,2)
plot(y2(:,1),y2(:,2), 'k')
xlabel('N')
ylabel('W')
title('Boars versus Wolves')

%% Roe deer
r=0.48;
c=0.01;
d=0.24;
e=0.005;
r2=0.48;
c2=0.01;
e2=0.005;

alpha=0.01; % hunting

N_ini=100;
W_ini=25;
R_ini=80;

tspan=[0 100];
y0=[N_ini; W_ini;R_ini];

odefun3 = @(t,y) [r*y(1)-c*y(2)*y(1)-alpha*y(1);-d*y(2)+e*y(1)*y(2)+e2*y(2)*y(3);r2*y(3)-c2*y(2)*y(3)];
[t3,y3]=ode45(odefun3,tspan,y0);

figure(6);
subplot(2,1,1)
plot3(y3(:,1),y3(:,2),y3(:,3));
scatter3(y3(:,1),y3(:,2),y3(:,3),30,t3,'filled');
xlabel('N');
ylabel('W');
zlabel('R');
grid on
colormap(parula);
c = colorbar;
c.Label.String = 'Time (years)';

subplot(2,1,2)
plot(t3,y3(:,1));
hold on
plot(t3,y3(:,2));
plot(t3,y3(:,3));
xlabel('Time');
ylabel('N');
legend('Wild boars','Wolves','Deers')
title('Evolution boar and wolve population')
