function Db = radar(i,t,p,n)

if i==1   % Calculate D of each vehicle in the first step
    Sigma = zeros(500,n);
    Db = zeros(500,n);

    for j = 1:n      
        Db(1,j) = 999;                                              
        for beta = 0:pi/50:2*pi    
            dista = norm([t.x(1)+t.r(1)*cos(beta) t.y(1)+t.r(1)*sin(beta)] - p{j}(1,1:2),2);
            if dista < abs(Db(1,j))                                                     % Real measured distance to boundary
                Sigma(i,j) = sign(norm([t.x(1) t.y(1)] - p{j}(1,1:2),2) - t.r(1));      % Real inside (-1) or outside (1) of circle   
                Db(1,j) = dista*Sigma(i,j);               
            end
        end  
    end
else
    for j = 1:n      % Calculate D of each vehicle
        Db(i,j) = 999;
        for beta = 0:pi/50:2*pi    
            dista = norm([t.x(i)+t.r(i)*cos(beta) t.y(i)+t.r(i)*sin(beta)] - p{j}(i-1,1:2),2);
            if dista < abs(Db(i,j))
                Sigma(i,j) = sign(norm([t.x(i) t.y(i)] - p{j}(i-1,1:2),2) - t.r(i));       % Real inside (-1) or outside (1) of circle   
                Db(i,j) = dista*Sigma(i,j);
            end
        end        
    end
end

end