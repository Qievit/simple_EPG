function [] = plot_states(obj)

load("epg_color.mat","EPG_color")

figure1 = figure();
n_echos = size(obj.F_states,2); 

% Show state space of F
subplot(1,2,1,'parent',figure1);
h = heatmap(abs(obj.F_states));
% h.YDisplayData = mat2cell(num2str([length(obj.state_matrix)-1 :-1: -length(obj.state_matrix)+1]'),ones(1,length(obj.state_matrix)*2-1))
% h.YLimits = {length(obj.F_states) length(obj.F_states)}
s = struct(h);
s.XAxis.Visible='off';
s.YAxis.Visible='off';
grid off;
colormap(EPG_color)
%*(obj.tau/dt)]*dt/obj.tau
colorbar;% xlim([0 n_echos]);%ylim([-rel_phases(end) rel_phases(end)])
ylabel('F State');
xlabel("Echo")
title('State Evolution - F');


% Show state space of Z
subplot(1,2,2,'parent',figure1);
% set(subplot2,'Layer','top','YTick',0);
h = heatmap(abs(obj.Z_states));
s = struct(h);
s.XAxis.Visible='off';
s.YAxis.Visible='off';
grid off;
colormap(EPG_color)
colorbar; %xlim([0 n_echos]);%ylim([-rel_phases(end) rel_phases(end)])
ylabel('Z State');
xlabel("Echo")
title('State Evolution - Z');


fontsize(scale=1.5)
