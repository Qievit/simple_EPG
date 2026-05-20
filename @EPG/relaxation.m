% simulates relaxation

function state_matrix = relaxation(obj,t)

E   =   [   exp(-t/obj.T2)    0             0; ...
            0             exp(-t/obj.T2)    0; ... 
            0             0             exp(-t/obj.T1)];

E_long = obj.M0*(1-exp(-t/obj.T1));

state_matrix = E * obj.state_matrix;
state_matrix(3,1) = state_matrix(3,1) + E_long;
obj.state_matrix = state_matrix; % Update the object's state matrix