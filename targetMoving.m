%% INIT
%clear; 
close all; clc;

% Inititalization target
Datas = DataFlagelates(151:350,511:580,92:170);

t.x = Circle(1,1)*ones(500,1);
t.y = Circle(1,2)*ones(500,1);
t.r = Circle(1,3)*ones(500,1);

n=5;

for j = 1:n
    t_est.x(1,j) = t.x(1);
    t_est.y(1,j) = t.y(1);
    t_est.r(1,j) = t.r(1);
end

% Inititalization agents

cars = cars_setup;
z1(1,:)                      = [cars(1).x0, cars(1).y0, cars(1).v0, cars(1).psi0]; 
z2(1,:)                      = [cars(2).x0, cars(2).y0, cars(2).v0, cars(2).psi0];
z3(1,:)                      = [cars(3).x0, cars(3).y0, cars(3).v0, cars(3).psi0]; 
z4(1,:)                      = [cars(4).x0, cars(4).y0, cars(4).v0, cars(4).psi0];
z5(1,:)                      = [cars(5).x0, cars(5).y0, cars(5).v0, cars(5).psi0];
p = {z1 z2 z3 z4 z5};

% Initialization distances
Db = radar(1,t,p,n);
%Db = newradar(1,t,p,n,Datas);

%% Set up the movie.
writerObj = VideoWriter('out.avi'); % Name it.
writerObj.FrameRate = 10; % How many frames per second.
open(writerObj); 

for i = 2:990
  
    hold off; plot(0,0); hold on;
     
    is = fix((i-1)/10) +1;
    t.x(i) = Circle(is,1) +rem((i-1),10)*(Circle(is+1,1)-Circle(is,1))/10;      
    t.y(i) = Circle(is,2) +rem((i-1),10)*(Circle(is+1,2)-Circle(is,2))/10;
    t.r(i) = Circle(is,3) +rem((i-1),10)*(Circle(is+1,3)-Circle(is,3))/10;

    %% Calculations

    % Distances to agent j
    %Db = radar(i,t,p,n);
    Db = newradar(i,t,p,n,Datas);
    
    %% Estimates of c and r by LSQ
    
    for j = 1:n    
        %Minimization of a circle for vehicle j using 3 vehicles (j, j-1, and j+1)
        c1=j;
        c2=j-1;
        c3=j+1;
        if j==1  %for vehicle 1, the car before is n
            c2=n;
        elseif j==n  %for vehicle n, the car after is 1
            c3=1;            
        end
        
        fun = @(x) (norm(x(1:2) - p{c1}(i-1,1:2)) - (x(3)+Db(i,c1)))^2 +(norm(x(1:2) - p{c2}(i-1,1:2)) - (x(3)+Db(i,c2)))^2 +(norm(x(1:2) - p{c3}(i-1,1:2)) - (x(3)+Db(i,c3)))^2;
        x0 = [t_est.x(i-1,j),t_est.y(i-1,j),t_est.r(i-1,j)];
        A = -eye(3);
        b = [0;0;0];
        err(i-1,:) = fmincon(fun,x0,A,b);

        %Estimates of each circle t_est for each vehice j
        t_est.x(i,j) = err(i-1,1);
        t_est.y(i,j) = err(i-1,2);
        t_est.r(i,j) = err(i-1,3);     
        
        %Derivatives of estimates. To be used in the position function
         t_est.dotx(i,j) = t_est.x(i,j) - t_est.x(i-1,j);
         t_est.doty(i,j) = t_est.y(i,j) - t_est.y(i-1,j);
         t_est.dotr(i,j) = t_est.r(i,j) - t_est.r(i-1,j); 
        
    end
    
    %% Position
    
    p = position(i,t_est,p);
    plot_environment(i,p,cars,t,Datas);
    frame = getframe(gcf); %, [90 90 300 300]); % 'gcf' can handle if you zoom in to take a movie.
    writeVideo(writerObj, frame);
end

hold off
close(writerObj);

