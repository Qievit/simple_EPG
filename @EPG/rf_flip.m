% simulates an instantaneous RF flip
% eq. 15 or 18 found in Wiegel et al. 

function rf_flip(obj,alpha,phase)

alpha = alpha * pi/180;
phase = phase * pi/180;

T = [  cos(alpha/2)^2                  exp(2*1i*phase)*sin(alpha/2)^2  -1i*exp(1i*phase)*sin(alpha);
       exp(-2*1i*phase)*sin(alpha/2)^2 cos(alpha/2)^2                  1i*exp(-1i*phase)*sin(alpha);
       -1i/2*exp(-1i*phase)*sin(alpha) 1i/2*exp(1i*phase)*sin(alpha)   cos(alpha)];

state_matrix = T*obj.state_matrix;
obj.state_matrix = state_matrix;