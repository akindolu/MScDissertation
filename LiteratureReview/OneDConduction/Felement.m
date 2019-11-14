% a function to calculate the element forcing vector of a linear element
% in a one dimensional heat conduction problem

function Fe = Felement(l,csa,p,h,ha,hb,q,qa,qb,G,Ta,Tb,direct,typeofh,typeofq,endnode,startnode,i)
    % l = length of the element; csa = cross sectional area of the element
    % p = perimeter of the element; h = coefficient of convection;
    % q = heat flux; G = internal heat generation; 
    % Ta = ambient temperature at the first node; 
    % Tb = ambient temperature at the last node;
    Fe = zeros(2,1); % create a matrix Fe with null elements for the forcing function
    if direct(1) == 1 
    % the body has internal heat generation    
        N = [1/2 1/2];
        Feg = G*(N')*csa*l;  % Forcing vector due to internal heat generation
        Fe = Fe+Feg;
    end

    if direct(2) == 1
    % the body is exposed to convection    
        if ((typeofh == 1)||(typeofh == 3))
            % ie lateral surface only or lateral and endnode convection
            N = [1/2 1/2];
            Fec = h*Ta*(N')*P*l;  % element forcing vector due to lateral convection
            Fe = Fe+Fec;
        end
        if (((typeofh == 2)||(typeofh == 3))&&(endnode == (i+1)))
            % ie endnode only or lateral and endnode convection at the endnode
            N = [0 1];
            Fec = hb*Tb*(N')*csa;  % element forcing vector due to endnode convection
            Fe = Fe+Fec;
        end
        if (((typeofh == 2)||(typeofh == 3))&&(startnode == (i)))
            % ie endnode only or lateral and endnode convection at the
            % startnode
            N = [1 0];
            Fec = ha*Ta*(N')*csa;  % element forcing vector due to startnode convection
            Fe = Fe+Fec;
        end
    end

    if direct(3) == 1
    % the body is exposed to heat flux    
        if ((typeofq == 1)||(typeofq == 3))
            % ie lateral surface only or lateral and endnode heat flux
            N = [1/2 1/2];
            Feq = -q*(N')*P*l;  % element forcing vector due to lateral heat flux
            Fe = Fe+Feq;
        end
        if (((typeofq == 2)||(typeofq == 3))&&(endnode == (i+1)))
            % ie endnode only or lateral and endnode convection at the endnode
            N = [0 1];
            Feq = -qb*(N')*csa;  % element forcing vector due to endnode heat flux
            Fe = Fe+Feq;
        end
        if (((typeofq == 2)||(typeofq == 3))&&(startnode == (i)))
            % ie endnode only or lateral and endnode heat flux at the
            % startnode
            N = [1 0];
            Feq = -qa*(N')*csa;  % element forcing vector due to startnode heat flux
            Fe = Fe+Feq;
        end
    end
end