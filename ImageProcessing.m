clc;
close all;

writerObj = VideoWriter('Target.avi'); % Name it.
writerObj.FrameRate = 10; % How many frames per second.
open(writerObj); 
Circle = zeros(88,3);

for i = 1:100
    
data = DataFlagelates(151:350,511:580,i+92);
s = surf(transpose(data - 10*ones(200,70)));
s.EdgeColor = 'none';
view(2)
hold on;

if i<18
    min = 20;
    max = 32;
elseif i<33
    min = 15;
    max = 29; 
elseif i<45
    min = 6;
    max = 20;
elseif i<63
    min = 7;
    max = 14;
elseif i<88
    min = 3;
    max = 11; 
end    
[c,r] = imfindcircles(data,[min max]);

if r>=1
    Circle(i,:) = [c(1,:),r(1)]; 
    aux = Circle(i,1);
    Circle(i,1) = Circle(i,2);
    Circle(i,2) = aux;
else
    Circle(i,:) = 2*Circle(i-1,:) -Circle(i-2,:); 
end
if i>1  
    if Circle(i,3) - Circle(i-1,3)>= 0.3
        Circle(i,3) = Circle(i-1,3)+0.3;
    elseif Circle(i,3) - Circle(i-1,3)<= -0.7
        Circle(i,3) = Circle(i-1,3)-0.7;
    end
    if Circle(i,1) - Circle(i-1,1)>=3 
        Circle(i,1) = Circle(i-1,1)+3;
    elseif Circle(i,1) - Circle(i-1,1)<= -0.5
        Circle(i,1) = Circle(i-1,1)-0.5;
    end
        if Circle(i,2) - Circle(i-1,2)>= 1
        Circle(i,2) = Circle(i-1,2)+1;
    elseif Circle(i,2) - Circle(i-1,2)<= -2 
        Circle(i,2) = Circle(i-1,2)-2;
    end
end

viscircles(Circle(i,1:2),Circle(i,3),'EdgeColor','b');

xlabel('x');
ylabel('y');
set(gca, 'FontSize', 14)

pause(0.2);
axis([1 200 1 70])
hold off;

frame = getframe(gcf); %, [90 90 300 300]); % 'gcf' can handle if you zoom in to take a movie.
writeVideo(writerObj, frame);

end

close(writerObj);
