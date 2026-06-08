function [] = plot_states(obj)

load("epg_color.mat","EPG_color")

figure1 = figure();

% Show state space of F
subplot(1,2,1,'parent',figure1);
h = heatmap(abs(obj.F_states));
h.XDisplayLabels = repmat({' '},1,size(obj.F_states,2));
h.YDisplayLabels = repmat({' '},size(obj.F_states,1),1);
grid off;
colormap(EPG_color)
colorbar;
ylabel('F State');
xlabel("Echo")
title('State Evolution - F');


% Show state space of Z
subplot(1,2,2,'parent',figure1);
h = heatmap(abs(obj.Z_states));
h.XDisplayLabels = repmat({' '},1,size(obj.F_states,2));
h.YDisplayLabels = repmat({' '},size(obj.F_states,1),1);
grid off;
colormap(EPG_color)
colorbar;
ylabel('Z State');
xlabel("Echo")
title('State Evolution - Z');


fontsize(scale=1.5)
