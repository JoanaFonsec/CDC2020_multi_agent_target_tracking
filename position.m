function z = position(i,t,z)
%% Variables

    a = -0.4;
    n = 5;              % n agents
    psi = ones(n,2);    % bearing
    D = ones(n,1);      % distance to the centre
    beta = ones(n,1);   % angle between two agents
    
    for j = 1:n      % Calculate D and psi of each vehicle
        D(j) = norm([t.x(i,j) t.y(i,j)] - z{j}(i-1,1:2),2);                   % 1x1
        psi(j,:) = (1/D(j))*([t.x(i,j) t.y(i,j)]-[z{j}(i-1,1) z{j}(i-1,2)]);  % 1x2       
    end
    
%% Calculate vehicle reference

    for j = 1:n       
        v1 = psi(j,:);
        beta(j) = 200;
        
        % Calculate Beta (See which is the vehicle imediately ahead)
        for k = 1:n   
            v2 = psi(k,:);
            angle = atan2d(v2(2),v2(1)) - atan2d(v1(2),v1(1));
            if angle <= 0
                angle = angle + 360;
            end
            if angle < beta(j)
                beta(j) = angle;
            end
        end
        beta(j) = deg2rad(beta(j));
               
        %Calculate the velocity
        z{j}(i,6) = t.dotx(i,j) + (D(j) - t.r(i,j) - t.dotr(i,j))*psi(j,1) + (a + beta(j))*psi(j,2); 
        z{j}(i,7) = t.doty(i,j) + (D(j) - t.r(i,j) - t.dotr(i,j))*psi(j,2) - (a + beta(j))*psi(j,1);
        
        if sqrt(z{j}(i,6)*z{j}(i,6)+z{j}(i,7)*z{j}(i,7)) >= 1    %Up to 2 of speed
            z{j}(i,6) = z{j}(i,6) *2 / sqrt(z{j}(i,6)*z{j}(i,6)+z{j}(i,7)*z{j}(i,7));
            z{j}(i,7) = z{j}(i,7) *2/ sqrt(z{j}(i,6)*z{j}(i,6)+z{j}(i,7)*z{j}(i,7));
        end    
        
        %Calculate next position
        z{j}(i,1) = z{j}(i-1,1) + z{j}(i,6);    %This is rotated
        z{j}(i,2) = z{j}(i-1,2) + z{j}(i,7);  
        z{j}(i,3) = sqrt((z{j}(i,1)-z{j}(i-1,1))^2 + (z{j}(i,2)-z{j}(i-1,2))^2);
        if (z{j}(i,1)-z{j}(i-1,1)) < 0
            flag = 1;
        else
            flag = 0;
        end
        z{j}(i,4) = atan(((z{j}(i,2)-z{j}(i-1,2))/(z{j}(i,1)-z{j}(i-1,1))))+flag*pi;
        z{j}(i,5) = beta(j);
    end
        
%       fprintf('Angles %.2f %.2f %.2f %.2f\n',beta);

%% Simulates a car-like vehicle

% u_curr(1) = -1;
% u_curr(2) = -1;
% 
% persistent old_beta;                        % old_beta memorizes the previous beta
% if isempty(old_beta)
%     old_beta = 0; 
% end
% 
% % imposing the phisical saturation on the inputs
% a           = u_curr(1);
% beta        = u_curr(2);
% a           = min(params.a_max, max(-params.a_max, a));                 % saturation on the acceleration
% beta        = min(params.beta_max, max(-params.beta_max, beta));        % saturation on the sideangle
% beta        = min(old_beta+params.beta_dot_max*params.Ts, max(old_beta-params.beta_dot_max*params.Ts, beta)); % saturation on the sideangle rate
% 
% % vehicle dynamics equations
% z_new(1) = z_curr(1) + (z_curr(3)*cos(z_curr(4)+beta))*params.Ts;
% z_new(2) = z_curr(2) + (z_curr(3)*sin(z_curr(4)+beta))*params.Ts;
% z_new(3) = z_curr(3) + a*params.Ts;
% z_new(4) = z_curr(4) + (z_curr(3)*sin(beta)/params.l_r)*params.Ts;
% 
% % saving the current beta 
% old_beta = beta;
end