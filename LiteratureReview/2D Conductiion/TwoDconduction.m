% this program solves a two-dimensional heat conduction problem, when
% supplied with the appropriate input parameters, it calculates the element
% stiffness matrix and forcing vectors then assembles it to form the global
% stiffness matrix and forcing vector.

% it uses linear (two-dimensional) triangular elements to solve the problem.

%%
% this section obtains the input to be used to generate the mesh from the
% user from the user.

L = input('Length of rectangle = ');
W = input('Width (or Height) of rectangle = ');
U = input('Length seed = ');
V = input('Height seed = ');
kx = input('Thermal conductivity in the x-direction = ');
ky = input('Thermal conductivity in the y-direction = ');
thickness = input('Thickness of the body is = ');
G = 0; 

%% this section creates the mesh, and returns mesh information
% Mesh coordinates matrix P
% Element nodes Tri
% Face Nodes: bottomface, rightface, topface, leftface

[ele_node, node_coord, b_face, r_face, t_face, l_face] = TriMeshgrid(L,W,U,V);

%% this section creates an array with node coordinates and properties

sizeof_node_coord = size(node_coord); % finds the size of node_coord
rowof_node_coord = sizeof_node_coord(1); % finds the number of rows in node_coord
indexof_node = 1:rowof_node_coord;
% the next line creates an array with nodal coordinates and extra columns
% to store node properties such as heat flux, convection, heat generation.
node_prop = [node_coord, zeros(rowof_node_coord, 5),(indexof_node)', zeros(rowof_node_coord, 2)];

%% this section determines the conditions applied to the boundaries
% for the heat generation, convection and heat flux on the boundaries.
% the vector for setting the conditions for convection and heat flux are of
% the form [a b c d] a = bottom face, b = right face, c = top face, 
% d = left face. a,b,c and d can have values of 1(True) or 0(False)

% this section checks for internal heat generation condition
heatgen_cond = input('enter 1 if the system has internal heat generation, 0 if not');
% this section checks for convection condition
convec_cond = input('enter an array for the sides exposed to convection 1 for yes 0 for no');
% this section checks for heat flux condition
heatflux_cond = input('enter an array for the sides exposed to heat flux 1 for yes 0 for no');

if heatgen_cond == 1  % if the system has internal heat generation
    G = input('heat generation value = ');
end

if convec_cond(1) == 1 % if the bottom face is exposed to convection
    h_bottom = input('the convection coefficient at bottom face = ');
    Ta_bottom = input('ambient temp at bottom face = ');
end

if convec_cond(2) == 1 % if the right face is exposed to convection
    h_right = input('the convection coefficient at right face = ');
    Ta_right = input('ambient temp at right face = ');
end

if convec_cond(3) == 1 % if the top face is exposed to convection
    h_top = input('the convection coefficient at top face = ');
    Ta_top = input('ambient temp at top face = ');
end

if convec_cond(4) == 1 % if the left face is exposed to convection
    h_left = input('the convection coefficient at left face = ');
    Ta_left = input('ambient temp at left face = ');
end

if heatflux_cond(1) == 1 % if the bottom face is exposed to heat flux
    q_bottom = input('the heat flux at bottom face = ');
end

if heatflux_cond(2) == 1 % if the right face is exposed to heat flux
    q_right = input('the heat flux at right face = ');
end

if heatflux_cond(3) == 1 % if the top face is exposed to heat flux
    q_top = input('the heat flux at top face = ');
end

if heatflux_cond(4) == 1 % if the left face is exposed to heat flux
    q_left = input('the heat flux at left face = ');
end

%% this section applies the boundary conditions to the respective nodes
% the boundary conditions are applied to the respective nodes in the
% node_prop matrix.

% this sets condition on the nodes on the bottom face
if convec_cond(1) == 1
    for c1 = 1: (length(b_face))
        node_prop( b_face(c1),3) = 1;
        node_prop( b_face(c1),4) = h_bottom;
        node_prop( b_face(c1),5) = Ta_bottom;
    end
end
if heatflux_cond(1) == 1
    for h1 = 1: (length(b_face))
        node_prop( b_face(h1), 6) = 1;
        node_prop( b_face(h1), 7) = q_bottom;
    end
end

% this sets condition on the nodes on the right face
if convec_cond(2) == 1
    for c1 = 1: (length(r_face))
        node_prop( r_face(c1),3) = 1;
        node_prop( r_face(c1),4) = h_right;
        node_prop( r_face(c1),5) = Ta_right;
    end
end
if heatflux_cond(2) == 1
    for h1 = 1: (length(r_face))
        node_prop( r_face(h1), 6) = 1;
        node_prop( r_face(h1), 7) = q_right;
    end
end

% this sets condition on the nodes on the top face
if convec_cond(3) == 1
    for c1 = 1: (length(t_face))
        node_prop( t_face(c1),3) = 1;
        node_prop( t_face(c1),4) = h_top;
        node_prop( t_face(c1),5) = Ta_top;
    end
end
if heatflux_cond(3) == 1
    for h1 = 1: (length(t_face))
        node_prop( t_face(h1), 6) = 1;
        node_prop( t_face(h1), 7) = q_top;
    end
end

% this sets condition on the nodes on the left face
if convec_cond(4) == 1
    for c1 = 1: (length(l_face))
        node_prop( l_face(c1),3) = 1;
        node_prop( l_face(c1),4) = h_left;
        node_prop( l_face(c1),5) = Ta_left;
    end
end
if heatflux_cond(4) == 1
    for h1 = 1: (length(l_face))
        node_prop( l_face(h1), 6) = 1;
        node_prop( l_face(h1), 7) = q_left;
    end
end




%%
% this section calculates and assembles the element stiffness matrices and
% forcing vectors into the global stiffness matrix and forcing vector.

kglobal = zeros((U+1)*(V+1), (U+1)*(V+1));
for i=1:(U*V*2)
    kelement = zeros((U+1)*(V+1), (U+1)*(V+1));
    elei = ele_node(i,:); % this extracts the associated nodes for the element i
    node1 = node_prop(elei(1),:);
    node2 = node_prop(elei(2),:);
    node3 = node_prop(elei(3),:);
    % the next line calls a function that would generate the element stiffness matrix
    k = Kelement(elei,node1,node2,node3,kx,ky,thickness,U,V,i);
    a = elei(1);
    b = elei(2);
    c = elei(3);
    kelement(a,a) = k(1,1);
    kelement(a,b) = k(1,2);
    kelement(a,c) = k(1,3);
    kelement(b,a) = k(2,1);
    kelement(b,b) = k(2,2);
    kelement(b,c) = k(2,3);
    kelement(c,a) = k(3,1);
    kelement(c,b) = k(3,2);
    kelement(c,c) = k(3,3);
    kglobal = kglobal+kelement;
end

%%
fglobal = zeros((U+1)*(V+1), 1);
for i=1:(U*V*2)
    felement = zeros((U+1)*(V+1), 1);
    elei = ele_node(i,:);
    node1 = node_prop(elei(1),:);
    node2 = node_prop(elei(2),:);
    node3 = node_prop(elei(3),:);
    % the next line calls a function that would generate the element forcing vector
    f = Felement(elei,node1,node2,node3,thickness,heatgen_cond,G,U,V,i);
    a = elei(1);
    b = elei(2);
    c = elei(3);
    felement(a, 1) = f(1,1);
    felement(b, 1) = f(2,1);
    felement(c, 1) = f(3,1);
    fglobal = fglobal+felement;
end

%%
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
%%
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
%%
% this section modifies the global stiffness matrix and global forcing
% vector according to the applied boundary temperatures.

for i = 1:(U+1)*(V+1)
    node = node_prop(i,:);
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
%%
% compute the values of temperatures at each node
T = inv(kglobal)*fglobal;

%%
disp('     Node       Temp');
N = 1:(U+1)*(V+1);
disp([N' T]);