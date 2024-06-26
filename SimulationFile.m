clc;
close all;

% writerObj = VideoWriter('Target.avi'); % Name it.
% writerObj.FrameRate = 10; % How many frames per second.
% open(writerObj); 

for i = 1:180
    
s = surf(transpose(DataFlagelates(101:300,481:580,i) - 10*ones(200,100)));
s.EdgeColor = 'none';
view(2)
hold on;

% th = 0:pi/50:2*pi;
% xt = Circle(i,3) * cos(th) + Circle(i,1);
% yt = Circle(i,3) * sin(th) + Circle(i,2);
% plot(xt, yt,'r','LineWidth',2); 
xlabel('x');
ylabel('y');
set(gca, 'FontSize', 14)
pause(0.1);
axis([0 200 0 100])


% frame = getframe(gcf); %, [90 90 300 300]); % 'gcf' can handle if you zoom in to take a movie.
% writeVideo(writerObj, frame);

hold off;

end

close(writerObj);
