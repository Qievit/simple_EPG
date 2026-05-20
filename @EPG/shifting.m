function state_matrix = shifting(obj,n)
m = obj.state_matrix;

if nargin < 2
    n = 1;
end

for i = 1:n
    state_matrix = [m(2,2)            m(1,1:size(m,2)-1) 0; ...
                    m(2,2:size(m,2))  0                  0; ...
                    m(3,:)                               0]; 
    m = state_matrix;
    obj.dephasing = [obj.dephasing length(obj.dephasing)];
end

obj.state_matrix = state_matrix;