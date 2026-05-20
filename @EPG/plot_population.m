function plot_population(obj)

figure1 = figure();
% Echo magnitudes
subplot1 = subplot(1,2,1,'parent',figure1);
hold on
plot([0:size(obj.F_states,2)-1],real(obj.F_states(ceil(end/2),:)),'Parent',subplot1,'LineWidth',2)
xlim([0 size(obj.F_states,2)-1])
hold on
plot([0:size(obj.F_states,2)-1],imag(obj.F_states(ceil(end/2),:)),'Parent',subplot1,'LineWidth',2)
xlim([0 size(obj.F_states,2)-1])
title("Echo magnitude")
ylabel("Echo population")
xlabel("Time")
grid on
legend("Real","Imaginary","Location","best")

% Look into total populations
subplot3 = subplot(1,2,2, 'parent',figure1);
hold on
scatter([0:size(obj.F_states,2)-1],sum(abs(obj.F_states(1:length(obj.state_matrix)-1,:)).^2,1) ...
                +sum(abs(obj.F_states(length(obj.state_matrix)+1:end,:)).^2,1) ...
                +sum(abs(obj.F_states(length(obj.state_matrix),:)).^2,1) ...
                +sum(abs(obj.Z_states(1:length(obj.state_matrix)-1,:)).^2,1) ...
                +sum(abs(obj.Z_states(length(obj.state_matrix)+1:end,:)).^2,1) ...
                +sum(abs(obj.Z_states(length(obj.state_matrix),:)).^2,1), ...
                'Parent',subplot3,'LineWidth',2)
scatter([0:size(obj.F_states,2)-1], ... 
    sum(abs(obj.F_states(1:length(obj.state_matrix)-1,:)).^2,1) ...
                +sum(abs(obj.F_states(length(obj.state_matrix)+1:end,:)).^2,1) ...
                +sum(abs(obj.F_states(length(obj.state_matrix),:)).^2,1),...
                'Parent',subplot3,'LineWidth',2)
scatter([0:size(obj.F_states,2)-1],sum(abs(obj.Z_states(1:length(obj.state_matrix)-1,:)).^2,1) ...
                +sum(abs(obj.Z_states(length(obj.state_matrix)+1:end,:)).^2,1) ...
                +sum(abs(obj.Z_states(length(obj.state_matrix),:)).^2,1), ...
                'Parent',subplot3,'LineWidth',2)

title("Absolute squared population")
ylabel("Population")
xlabel("Time")
xlim([0 size(obj.F_states,2)-1])
grid on
legend("|F|^2","|Z|^2","|Z|^2 + |F|^2","Location","best")

fontsize(scale=1.5)