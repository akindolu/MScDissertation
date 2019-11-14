% this program solves a one-dimensional heat conduction problem, when
% supplied with the appropriate input parameters, it calculates the element
% stiffness matrix and forcing vectors then assembles it to form the global
% stiffness matrix and forcing vector.

% it uses linear (one-dimensional) elements to solve the problem.

%%
% this section obtains the necessary input from the user.

n = input('please enter the number of element n = ');
startnode = 1;
endnode = n+1;
KThermal = input('please enter the thermal conductivity KThermal = ');
L = input('please enter the length of the element L = ');
l = L/n;
Ta = input('please enter the ambient temperature at startnode Ta = ');
Tb = input('please enter the ambient temperature at endnode Tb = ');
csa = input('please enter the cross sectional area csa = ');
p = input('please enter the perimeter P = ');
direct = zeros(1,3);
typeofq = 0;
typeofh = 0;
h = 0;
direct(1) = input('enter 1 if the system has internal heat generation, or 0 if it doesn''t ');
if direct(1) == 1;
    G = input('Enter the value of internal heat generation G = ');
else
    G = 0;
end
direct(2) = input('enter 1 if the system is exposed to convection, or 0 if it is not');
if direct(2) == 1;
    typeofh = input('enter 1 for convection on lateral surface only , 2 for convection on end node only, 3 for both ');
    if typeofh == 1;
        h = input('enter the lateral coefficient of convection h = ');
    elseif typeofh == 2
        ha = input('enter the coefficient of convection on the startnode ha = ');
        hb = input('enter the coefficient of convection on the endnode hb = ');
    elseif typeofh == 3
        h = input('enter the lateral coefficient of convection h = ');
        ha = input('enter the coefficient of convection on the startnode ha = ');
        hb = input('enter the coefficient of convection on the endnode hb = ');
    end
else
    h = 0; ha = 0; hb = 0;
end
direct(3) = input('enter 1 if the system is exposed to heat flux, or 0 if it is not ');
if direct(3) == 1;
    typeofq = input('enter 1 for heat flux on lateral surface only , 2 for heat flux on end node only, 3 for both ');
    if typeofq == 1;
        h = input('enter the lateral heat flux q = ');
    elseif typeofq == 2
        qa = input('enter the heat flux on the startnode qa = ');
        qb = input('enter the heat flux on the endnode qb = ');
    elseif typeofq == 3
        q = input('enter the lateral heat flux q = ');
        qa = input('enter the heat flux on the startnode qa = ');
        qb = input('enter the heat flux on the endnode qb = ');
    end
else
    q = 0; qa = 0; qb = 0;
end


%%
% this section calculates and assembles the element stiffness matrices and
% forcing vectors into the global stiffness matrix and forcing vector.

kglobal = zeros(n+1, n+1);
for i=1:n
    kelement = zeros(n+1, n+1);
    % for a the main FEM program, the next line could call a function that
    % would generate the element stiffness matrix
    k = Kelement(l,csa,KThermal,h,ha,hb,direct,typeofh,endnode,startnode,i);
    kelement(i, i) = k(1,1);
    kelement(i, i+1) = k(1,2);
    kelement(i+1, i) = k(2,1);
    kelement(i+1, i+1) = k(2,2);
    kglobal = kglobal+kelement;
end

%%
fglobal = zeros(n+1, 1);
for i=1:n
    felement = zeros(n+1, 1);
    % for a the main FEM program, the next line could call a function that
    % would generate the element forcing vector
    f = Felement(l,csa,p,h,ha,hb,q,qa,qb,G,Ta,Tb,direct,typeofh,typeofq,endnode,startnode,i);
    felement(i, 1) = f(1,1);
    felement(i+1, 1) = f(2,1);
    fglobal = fglobal+felement;
end

%%
Tcond_start = input('enter 1 if the start has a fixed temp, 0 if not');
if Tcond_start == 1
    Tstartnode = input('enter the temperature of the start node');
    fglobal(2) = fglobal(2)-(kglobal(2,1))*Tstartnode;
    kglobal(1,:) = zeros(1, (n+1));
    kglobal(:,1) = zeros((n+1), 1);
    kglobal(1,1) = 1;
    fglobal(1) = Tstartnode;
end

Tcond_end = input('enter 1 if the end has a fixed temp, 0 if not');
if Tcond_end == 1
    Tendnode = input('enter the temperature of the end node');
    fglobal(n) = fglobal(n) - (kglobal((n),(n+1)))*Tendnode;
    kglobal((n+1),:) = zeros(1, (n+1));
    kglobal(:,(n+1)) = zeros((n+1), 1);
    kglobal((n+1), (n+1)) = 1;
    fglobal(n+1) = Tendnode;
end
%%
% compute the values of temperatures at each node
T = inv(kglobal)*fglobal;

%%
disp('     Node       Temp');
N = 1:n+1;
disp([N' T]);