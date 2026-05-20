function record(obj)
current_F = [flipud(obj.state_matrix(1,:)');obj.state_matrix(2,2:end)'];
current_Z = [flipud(obj.state_matrix(3,:)');conj(obj.state_matrix(3,2:end))'];

F_states = [zeros((size(current_F,1)-size(obj.F_states,1))/2,size(abs(obj.F_states),2));
            obj.F_states;
            zeros((size(current_F,1)-size(obj.F_states,1))/2,size(abs(obj.F_states),2))];
Z_states = [zeros((size(current_Z,1)-size(obj.Z_states,1))/2,size(abs(obj.Z_states),2));
            obj.Z_states;
            zeros((size(current_Z,1)-size(obj.Z_states,1))/2,size(abs(obj.Z_states),2))];

obj.F_states = [F_states current_F];
obj.Z_states = [Z_states current_Z];