% this section checks for fixed nodal temperature condition
nodaltemp_cond = input('enter an array for the sides with fixed temp 1 for yes 0 for no');

if nodaltemp_cond(1) == 1 % if the bottom face has a fixed temperature
    T_bottom = input('the temperature at bottom face = ');
end

if nodaltemp_cond(2) == 1 % if the right face has a fixed temperature
    T_right = input('the temperature at right face = ');
end

if nodaltemp_cond(3) == 1 % if the top face has a fixed temperature
    T_top = input('the temperature at top face = ');
end

if nodaltemp_cond(4) == 1 % if the left face has a fixed temperature
    T_left = input('the temperature at left face = ');
end

% this section applies the node temperature and temperature toggle to the
% appropriate nodes in the node_prop matrix.
% the temp toggle is applied to column 9, while temp to column 10
% this is done for all the faces, where applicable
if nodaltemp_cond(1) == 1 % applies nodal temp to bottom face
    for h1 = 1: (length(b_face))
        node_prop( b_face(h1), 9) = 1;
        if node_prop( b_face(h1), 10) < T_bottom
            node_prop( b_face(h1), 10) = T_bottom;
        end
    end
end

if nodaltemp_cond(2) == 1 % applies nodal temp to right face
    for h1 = 1: (length(r_face))
        node_prop( r_face(h1), 9) = 1;
        if node_prop( r_face(h1), 10) < T_right
            node_prop( r_face(h1), 10) = T_right;
        end
    end
end

if nodaltemp_cond(3) == 1 % applies nodal temp to top face
    for h1 = 1: (length(t_face))
        node_prop( t_face(h1), 9) = 1;
        if node_prop( t_face(h1), 10) < T_top
            node_prop( t_face(h1), 10) = T_top;
        end
    end
end

if nodaltemp_cond(4) == 1 % applies nodal temp to left face
    for h1 = 1: (length(l_face))
        node_prop( l_face(h1), 9) = 1;
        if node_prop( l_face(h1), 10) < T_left;
            node_prop( l_face(h1), 10) = T_left;
        end
    end
end

% this section modifies the global stiffness matrix and global forcing
% vector according to the applied boundary temperatures.

for i = 1:(U+1)*(V+1)
    node = node_prop(:,i);
    if node(9) == 1
        nodetemp = node(10); % obtains temperature at node
        nodeindex = node(8); % obtains the node number
        fglobal(nodeindex) = nodetemp; % sets the known temp in fglobal
        adder = kglobal(:,nodeindex); % the column of the node in Kglobal
        adder(nodeindex) = 0; % sets this to zero so that fglobal(nodeindex) remains unchanged
        fglobal = fglobal - (adder*nodetemp);
        kglobal(:,nodeindex) = zeros((U+1)*(V+1),1);
        kglobal(nodeindex,:) = zeros(1,(U+1)*(V+1));
        kglobal(nodeindex,nodeindex) = 1; 
    end
end