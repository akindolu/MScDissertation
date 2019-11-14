% a program to create a structured mesh on a rectangular object, when given
% the length of the sides and the number of mesh seeds on the horizontal
% and vertical sides.

function[tri, P, bottomface, rightface, topface, leftface] = TriMeshgrid(L,W,U,V)

%%
% instantiate a vector x and y which is gotten by dividing L by U and W by
% V

x = 1: (L/U) : (L+1);
y = 1: (W/V) : (W+1);

%%
% a meshgrid is generated, this is in turn used to create an array of nodal
% coordinates for all the nodes in the mesh

[Y, X] = meshgrid(y,x);
XT = X';
YT = Y';
P = [X(:), Y(:)];

%%
% the triangles are then formed by assigning the appropriate nodes to each
% triangle, note that the nodes are assigned in the clockwise direction

% generate an array with the same physical structure as the elements and
% also with the same nodal numberings

A = zeros((V+1),(U+1));
a = 1:(U+1);
for n = 0:V
    A(n+1,:) = a+(n*(U+1))*ones(1,(U+1));
end

% determine the nodes associated to each triangle

tri = zeros((U*V*2), 3);
c = 1;
for i = 1:V
    for j = 1:U
        n1 = A(i,j);
        n2 = A(i, j+1);
        n3 = A(i+1, j+1);
        n4 = A(i+1, j);
                
        tri(c,:) = [n1 n2 n3];
        c = c+1;
        tri(c,:) = [n3 n4 n1];
        c = c+1;
    end
end

figure(1);
axis equal;
hold on
title('Triangular Mesh');
trimesh(tri, P(:,1), P(:,2));
hold off


%%
% this determines the nodes on the four sides of the element
bottomface = 1: (U+1);
rightface = (U+1):(U+1):((U+1)*(V+1));
topface = ((U+1)*V)+1:((U+1)*(V+1));
leftface = 1:(U+1):(((U+1)*V)+1);
