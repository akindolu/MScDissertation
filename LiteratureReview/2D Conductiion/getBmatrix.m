%%
% a function to calculate the "B" matrix for a linear triangular element.
% determine the jacobian of the element

function [B,J] = getBmatrix(node1, node2, node3)
X = [node1(1), node2(1), node3(1)];
Y = [node1(2), node2(2), node3(2)];
coord = [X', Y'];

H = [-1 1 0; -1 0 1];
J = H*coord;
B = (inv(J))*H;
B