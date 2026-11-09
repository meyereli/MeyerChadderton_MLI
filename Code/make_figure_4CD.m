function make_figure_4CD(all_whisk,all_movtouch, all_touch)

BL_fw = 31;
BL_touch = 300; 
curr_win =45;
%Figure 4C, D
figure;
subplot(2,1,1)
title('Figure 4C');
hold on;
x = 1:size(all_whisk,2); 
y = nanmean(all_whisk,1); 
errBar_sem = nanstd(all_whisk, 1)/sqrt(size(all_whisk,1)); 
ts = tinv([0.025  0.975],length(y)-1);
errBar =  ts(1,1)*errBar_sem;
H=shadedErrorBar(x, y, errBar, 'r');

y = nanmean(all_movtouch,1); 
errBar_sem = nanstd(all_movtouch, 1)/sqrt(size(all_movtouch,1));
ts = tinv([0.025  0.975],length(y)-1)';
errBar =  ts(1,1)*errBar_sem;
H=shadedErrorBar(x, y, errBar, 'b');
set(gca,'XColor', 'none')
ylabel('dF/F');
ylim([0.98, 1.08]);
xline(31);
subplot(2,1,2)
hold on;
y = nanmean(all_touch(:, BL_touch - 31 : BL_touch+154),1); 
errBar_sem = nanstd(all_touch(:, BL_touch - 31 : BL_touch+154), 1)/sqrt(size(all_touch,1)); 
ts = tinv([0.025  0.975],length(y)-1)';
errBar =  ts(1,1)*errBar_sem;
H=shadedErrorBar(x, y, errBar, 'b');
xline(31);
ax = gca;
curr_xlim = ax.XLim(2);
curr_xlim_1 = ax.XLim(1);
new_xlim = curr_xlim + (31 - rem(curr_xlim,31));
x_ticks_new = curr_xlim_1:31:new_xlim;
new_labels = floor(linspace(1, new_xlim/31, new_xlim/31));
xticks(x_ticks_new);
xticklabels(new_labels);
xlabel('Time (s)');
ylabel('dF/F');
ylim([0.98, 1.08]);
figure;
hold on;
xaxis_vec_large = ones(1,328);
y1 = nanmean(all_whisk(:, 62:120),2) - nanmean(all_whisk(:, 1:BL_fw),2);
violin(y1,'x',[1 0 3], 'medc','');
errorbar(1, nanmean(y1), std(y1), std(y1), 'k');
y3 = nanmean(all_touch(:,BL_touch+31:BL_touch+120),2) - nanmean(all_touch(:, 1:BL_touch),2);
violin(y3,'x',[2 0 3],'facecolor','b', 'medc','');
errorbar(2, nanmean(y3), nanstd(y3), nanstd(y3), 'k');
ylim([-0.04 0.2]);
ylabel('Evoked Ca2+ amp. (dF/F');
title('Figure 4D');
yline(0);
[ p1, h1, stats1] = ranksum(y1, y3);
txt = ['p = ', string(p1)];
text(0.1, 0.18, txt);