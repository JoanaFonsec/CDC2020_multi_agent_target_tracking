function plot_environment(i,z,cars,target,Datas)
%% PLOT_ENVIRONMENT Plot autonomous driving environment

n=5;

%% parsing the parameters structure
vehicle_length      = cars(1).l_f + cars(1).l_r;
vehicle_width       = cars(1).vehicle_width;
activate_obstacles  = cars(1).activate_obstacles;
obstacle_centers    = cars(1).obstacle_centers;
obstacle_size       = cars(1).obstacle_size;

%% parsing the arguments + car position

for k = 1:n
    current_pos{k}         = z{k}(end,:);  %both are cells
    car_x{k} = [current_pos{k}(1)-vehicle_length/2 current_pos{k}(1)+vehicle_length/2 current_pos{k}(1)+vehicle_length/2 current_pos{k}(1)-vehicle_length/2];
    car_y{k} = [current_pos{k}(2)+vehicle_width/2 current_pos{k}(2)+vehicle_width/2 current_pos{k}(2)-vehicle_width/2 current_pos{k}(2)-vehicle_width/2];
end

%% define obstacles
if activate_obstacles == 1 % define obstacles
    obs_x = zeros(size(obstacle_centers,1),4); % edges x coordinates
    obs_y = zeros(size(obstacle_centers,1),4); % edges y coordinates
    for i = 1:size(obstacle_centers,1)
        xc = obstacle_centers(i,1); % obstacle center x coordinate
        xsize = obstacle_size(1)/2; % obstacle x size
        obs_x(i,:) = [xc-xsize, xc+xsize, xc+xsize, xc-xsize];
        
        yc = obstacle_centers(i,2); % obstacle center y coordinate
        ysize = obstacle_size(2)/2; % obstacle y size
        obs_y(i,:) = [yc+ysize, yc+ysize, yc-ysize, yc-ysize];
    end
    
elseif activate_obstacles == 0
    % do nothing
else
    error('The flag activate_obstacles must be set to 0 or 1\n')
end


%% plot simulation environment

is = fix((i-1)/10) +1;
Datas(:,:,is) = Datas(:,:,is) - 10*ones(200,70);
s = surf(transpose(Datas(:,:,is)));
s.EdgeColor = 'none';
view(2)

% plot the car (x,y) & car path from the beggining of time
for k = 1:n
    car_handle=patch(car_x{k},car_y{k},'white','EdgeColor','b','LineWidth',2);
    rotate(car_handle,[0 0 1],rad2deg(current_pos{k}(4)),[current_pos{k}(1),current_pos{k}(2) 0]);   % This is the car
    plot(z{k}(max(1,i-30):i,1),z{k}(max(1,i-30):i,2),'white','LineWidth',2);                                                                   % This is the path
end

% Plotting the real discrete
th = 0:pi/50:2*pi;
xt = target.r(i) * cos(th) + target.x(i);
yt = target.r(i) * sin(th) + target.y(i);
plot(xt, yt,'LineWidth',2);                                       

% plot the obstacles
if activate_obstacles == 1
    for i = 1:size(obstacle_centers,1)
        patch(obs_x(i,:),obs_y(i,:),'black','EdgeColor','black');
    end
end

% plot the "end" of the track
axis([1 200 1 70])
axis equal
xticks([1 40 80 120 160 200])
yticks([1 40 70])
xlabel('x', 'FontSize', 24);
ylabel('y', 'FontSize', 24);
set(gca, 'FontSize', 20)
%title('Target circumnavigation', 'FontSize', 24)

drawnow;
%pause(0.01)

end