function D = radar(i,t,p,n,data)

boundary = 0.07;

if i==1                % Initialization calculation
    D = zeros(500,n);

    for j = 1:n      
        D(1,j) = 999;                                              
        for beta = 0:pi/50:2*pi    
            dista = norm([t.x(1)+t.r(1)*cos(beta) t.y(1)+t.r(1)*sin(beta)] - p{j}(1,1:2),2);
            if dista < abs(D(1,j))                                                     % Real measured distance to boundary
                Sigma = sign(norm([t.x(1) t.y(1)] - p{j}(1,1:2),2) - t.r(1));      % Real inside (-1) or outside (1) of circle   
                D(1,j) = dista*Sigma;               
            end
        end  
    end
    
else                    % Calculation for the cicle
    for j = 1:n
        is = fix((i-1)/10) +1;
        found=0;
        D(i,j) = 0;
        if p{j}(i-1,1)>197 || p{j}(i-1,2)>67 || p{j}(i-1,1)<2 || p{j}(i-1,2)<2
            Sigma = 1;
        else
            local_density = data(fix(p{j}(i-1,1)),fix(p{j}(i-1,2)),is);  %density in the vehicle point
            Sigma=sign(boundary-local_density);                 %Inside or out in the vehicle point
        end
        for radius = 1:50
            for beta = 0:pi/40:2*pi    
                point = [fix(p{j}(i-1,1)+radius*cos(beta)) , fix(p{j}(i-1,2)+radius*sin(beta))];
                if point(1)>0 && point(2)>0 && point(1)<199 && point(2)<69
                    density = data(point(1),point(2),is);
                    if density > boundary && Sigma>0 && found==0       %Found boundary when outside the circle!
                        D(i,j) = radius*Sigma;
                        found=1;
                    elseif density < boundary && Sigma<0 && found==0   %Found boundary when inside the circle!
                        D(i,j) = radius*Sigma;
                        found=1;
                    end
               % else
                %    D(i,j) = D(i-1,j);
                end                
            end   
        end
    end
end

end