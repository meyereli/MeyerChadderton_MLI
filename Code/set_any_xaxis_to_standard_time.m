function set_any_xaxis_to_standard_time

ax = gca;
curr_xlim = ax.XLim(2);
curr_xlim_1 = ax.XLim(1);
new_xlim = curr_xlim + (31 - rem(curr_xlim,31));

x_ticks_new = curr_xlim_1:31:new_xlim;
new_labels = floor(linspace(1, new_xlim/31, new_xlim/31));

xticks(x_ticks_new);
xticklabels(new_labels);
xlabel('Time (s)');