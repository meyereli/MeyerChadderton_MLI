function [all_whisk, all_touch, all_movtouch] = make_figure_4B(neuract_touchlocs, bouts_by_vid)


for ianimal =6    
    curr_data = neuract_touchlocs{1,ianimal}(:,10);
    curr_data = curr_data(~cellfun('isempty', curr_data));
    curr_data_mat = permute(curr_data, [2 3 1]);
    curr_data_mat = cell2mat(curr_data_mat);
    curr_data_mean = nanmean(curr_data_mat, 3);
    sort_vec = nanmean(curr_data_mean(:, 300:end),2);    
    curr_data_mean = [curr_data_mean sort_vec];
    curr_data_sort = sortrows(curr_data_mean, size(curr_data_mean,2));    
    figure;     
    imagesc(curr_data_sort); 
    colmap = generate_colours(1,1,1.18, 0.98);
    colormap(colmap);
    caxis([0.98 1.18]);
    colorbar; 
    xline(300);
    xlim([300-93 300+93]);    
    set(gcf,'renderer','painters');   
   
end
title('Figure 4B Biii   touch trials');

ax = gca;
curr_xlim = ax.XLim(2);
curr_xlim_1 = ax.XLim(1);
new_xlim = curr_xlim + (31 - rem(curr_xlim,31));

x_ticks_new = curr_xlim_1:31:new_xlim;
new_labels = [-3; -2; -1; 0; 1; 2; 3];

xticks(x_ticks_new);
xticklabels(new_labels);
xlabel('Time from touch (s)');
ylabel('Cell #');
c = colorbar;
c.Label.String = ('dF/F');

%%

for ianimal = 6
    curr_data = neuract_touchlocs{1,ianimal}(:,8);
    curr_data = curr_data(~cellfun('isempty', curr_data));
    curr_data_mat = permute(curr_data, [2 3 1]);
    curr_data_mat = cell2mat(curr_data_mat);
    curr_data_mean = nanmean(curr_data_mat, 3);     
    curr_data_mean = [curr_data_mean sort_vec];
    curr_data_sort = sortrows(curr_data_mean, size(curr_data_mean,2));     
    figure; 
    
    imagesc(curr_data_sort); 
   % colmap = generate_colours(1,1,1.18, 0.98);
    colormap(colmap);    
    caxis([0.98 1.18]);
    colorbar; 
    title(string(ianimal));
    xline(52);

    set(gcf,'renderer','painters');
    
    
    
   
end
title('Figure 4B Bii   touch trials');

ax = gca;
curr_xlim = ax.XLim(2);
curr_xlim_1 = ax.XLim(1);
new_xlim = curr_xlim + (31 - rem(curr_xlim,31));

x_ticks_new = curr_xlim_1-10:31:new_xlim-10;
new_labels = [-2; -1; 0; 1; 2; 3; 4];

xticks(x_ticks_new);
xticklabels(new_labels);
xlabel('Time from touch (s)');
ylabel('Cell #');
c = colorbar;
c.Label.String = ('dF/F');



%%

BL_fw = 31;
BL_touch = 300; 
curr_win =45;

%%

for ianimal = 1:size(neuract_touchlocs, 2)
     curr_whisk = bouts_by_vid(:,ianimal);
     curr_touch = neuract_touchlocs{1,ianimal}(:,10);  
     curr_movtouch = neuract_touchlocs{1,ianimal}(:,8);
     curr_whisk = curr_whisk(~cellfun('isempty', curr_whisk));
     curr_whisk = cell2mat(permute(curr_whisk,[2,3,1]));
     curr_whisk_mean = mean(curr_whisk,3);
     whisk_resps_mean(:,ianimal) = mean(mean(curr_whisk_mean(:,BL_fw+1:BL_fw+curr_win),2) - mean(curr_whisk_mean(:,1:BL_fw),2)); %only calc difference for last 2 seconds of bout
     whisk_resps(ianimal,:) = mean(curr_whisk_mean,1) - mean(mean(curr_whisk_mean(:, 1:BL_fw),1)); 
     all_trials_whisk{1,ianimal} = curr_whisk_mean;
     curr_touch = curr_touch(~cellfun('isempty', curr_touch));
     curr_movtouch = curr_movtouch(~cellfun('isempty', curr_movtouch));
     curr_touch = cell2mat(permute(curr_touch,[2,3,1]));
     curr_movtouch = cell2mat(permute(curr_movtouch, [2,3,1]));
     curr_touch_mean = mean(curr_touch,3);
     curr_movtouch_mean = mean(curr_movtouch,3);
     touch_resps_mean(:,ianimal) = mean(mean(curr_touch_mean(:,BL_touch+1:BL_touch+curr_win),2) - mean(curr_touch_mean(:,1:BL_touch),2)); 
     touch_resps(ianimal,:) = mean(curr_touch_mean,1) - mean(mean(curr_touch_mean(:, 1:31),1));
     movtouch_resps_mean(:,ianimal) = mean(mean(curr_movtouch_mean(:,BL_fw+1:BL_fw+curr_win),2) - mean(curr_movtouch(:,1:BL_fw),2));
     movtouch_resps(ianimal,:) = mean(curr_movtouch_mean,1) - mean(mean(curr_movtouch_mean(:, 1:BL_fw),1)); 
     all_trials_touch{1,ianimal} = curr_touch_mean;
     all_trials_movtouch{1,ianimal} = curr_movtouch_mean;
     movtouch_resps_end_mean(:,ianimal) = mean(mean(curr_movtouch_mean(:,155:end),2) - mean(curr_movtouch(:,1:BL_fw),2));
     whisk_resps_end_mean(:,ianimal) = mean(mean(curr_whisk_mean(:,155:end),2) - mean(curr_whisk_mean(:,1:BL_fw),2));
end

all_trials_whisk = all_trials_whisk(:);
all_trials_touch = all_trials_touch(:);
all_trials_movtouch = all_trials_movtouch(:);
all_whisk = cell2mat(all_trials_whisk);
all_touch = cell2mat(all_trials_touch);
all_movtouch = cell2mat(all_trials_movtouch);
