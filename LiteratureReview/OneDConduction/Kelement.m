% a function to calculate the element stiffness matrix of a linear element
% in a one dimensional heat conduction problem

function Ke = Kelement(l,csa,KThermal,h,ha,hb,direct,typeofh,endnode,startnode,i)
    % l = length of the element; csa = cross sectional area of the element
    % KThermal = thermal conductivity; p = perimeter of the element; h =
    % coefficient of convection; direct = specifies the types of heat losses in
    % the system; typeofh = type of convection(lateral or endnode); n = number
    % of elements; endnode = node number of the last node
    %%
    B = [-1/l 1/l];  
    Ke = (B')*(B)*csa*l*KThermal; %element stiffness matrix due to conduction
    if direct(2) == 1  
    % that is if the system is exposed to convective heat transfer    
        if ((typeofh == 1)||(typeofh == 3))  
            % ie lateral surface only or lateral and endnode convection
            NtrN = [2/6 1/6; 1/6 2/6];
            Kec = h*NtrN*P*l; % element stiffness matrix due to lateral convection
            Ke = Ke + Kec;
        end
        if (((typeofh == 2)||(typeofh == 3))&&(endnode == (i+1)))
            % ie endnode only or lateral and endnode convection
            NtrN = [0 0; 0 1];
            Kec = hb*NtrN*csa;  % element stiffness matrix due to endnode convection
            Ke = Ke+Kec;
        end
        if (((typeofh == 2)||(typeofh == 3))&&(startnode == (i)))
            % ie endnode only or lateral and endnode convection
            NtrN = [1 0; 0 0];
            Kec = ha*NtrN*csa;  % element stiffness matrix due to startnode convection
            Ke = Ke+Kec;
        end
    end
end

