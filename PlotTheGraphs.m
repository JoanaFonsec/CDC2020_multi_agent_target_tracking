x = linspace(0,990,990);
x2 = linspace(0,1800,1800);

figure(1)
subplot(4,2,1)
plot(x,t.x)
xlabel('t');
ylabel('x');
set(gca, 'FontSize', 14)
%title('Target centre x')
hold on
plot(x2,t_est.x)
hold off
axis([0 990 30 200])
legend('Real','Estimate')

subplot(4,2,2)
plot(x,t.y)
xlabel('t');
ylabel('y');
set(gca, 'FontSize', 14)
%title('Target centre y')
hold on
plot(x2,t_est.y)
hold off
axis([0 990 20 60])
legend('Real','Estimate')

subplot(4,2,3:4)
plot(x,t.r)
xlabel('t');
ylabel('r');
set(gca, 'FontSize', 14)
%title('Target radius r')
hold on
plot(x2,t_est.r)
hold off
axis([0 990 5 35])
legend('Real','Estimate')

subplot(4,2,5)
plot(x,Distc(:,1))
xlabel('t');
ylabel('D_1^b');
set(gca, 'FontSize', 14)
axis([0 990 0 3])

subplot(4,2,6)
plot(x,p{1}(:,5))
xlabel('t');
ylabel('\beta_1');
set(gca, 'FontSize', 14)
%title('Angle to the closest agent, \beta_1')
hold on
plot(x,1.57*ones(size(x)))
hold off
axis([0 990 1.2 2])

subplot(4,2,7)
plot(x,p{1}(:,6))
xlabel('t');
ylabel('u_1.x');
set(gca, 'FontSize', 14)
%title('Control input in x, u_1.x')
axis([0 990 -3 3])

subplot(4,2,8)
plot(x,p{1}(:,7))
xlabel('t');
ylabel('u_1.y');
set(gca, 'FontSize', 14)
%title('Control input in y, u_i.y')
axis([0 990 -3 3])
