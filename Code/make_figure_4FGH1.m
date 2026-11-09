function make_figure_4FGH1(neuract_touchlocs, sort_vecs_fw, bouts_by_vid)

BL_fw = 31;
BL_touch = 300; 
% BL_puff = 93;

for ianimal = 1:size(sort_vecs_fw,2)
    curr_touch = neuract_touchlocs{1,ianimal}(:,10);
    curr_touch = curr_touch(~cellfun('isempty', curr_touch));
    curr_touch_av = cell2mat(reshape(curr_touch,1,1,[]));
    curr_touch_av = mean(curr_touch_av,3);
    
    curr_sortvec = sort_vecs_fw{1,ianimal};
    [~,sorting_order] = sortrows(curr_sortvec);
    touch_sortvec = mean(curr_touch_av(:, BL_touch:end),2);
    [~,sorting_order_t] = sortrows(touch_sortvec);    
    [stats_result(1,ianimal), stats_result(2,ianimal)] = corr(sorting_order, sorting_order_t, 'Type','Spearman');
    fw_sorting{1,ianimal} = sorting_order;
    t_sorting{1,ianimal} = sorting_order_t;
    
end

    curr_data = neuract_touchlocs{1,6}(:,10);
    curr_data = curr_data(~cellfun('isempty', curr_data));
    curr_data_mat = permute(curr_data, [2 3 1]);
    curr_data_mat = cell2mat(curr_data_mat);
    curr_data_mean = nanmean(curr_data_mat, 3);
    sort_vec = sort_vecs_fw{1,6};    
    curr_data_mean = [curr_data_mean sort_vec];
    curr_data_sort = sortrows(curr_data_mean, size(curr_data_mean,2)); 
    
    figure;    
    imagesc(curr_data_sort); 
    colmap = generate_colours(1,1,1.18, 0.98);
    colormap(colmap);
    caxis([0.98 1.18]);
    colorbar; 
    set_any_xaxis_to_standard_time;
    title('Figure 4F');
    xline(300);
    xlim([300-93 300+93]);    
    set(gcf,'renderer','painters');


%plot delta ranking
delta_rank_t = cellfun(@(x,y) (x - y), fw_sorting, t_sorting, 'UniformOutput', 0);
delta_rank_t_sort = cellfun(@(x) (sortrows(x)), delta_rank_t, 'UniformOutput', 0);
zero_indices_t = cellfun(@(x) (find(x==0)), delta_rank_t_sort,'UniformOutput', 0);
yline(0);

%count how many neurons have a delta of 0. 
nonchangers_t = cellfun(@(x) (size(x(x ==0),1)/size(x,1)*100), delta_rank_t_sort);

%find mean difference in values of delta rank
nchangers_t = cellfun(@(x) (size(x(x <0),1)/size(x,1)*100), delta_rank_t_sort);
pchangers_t = cellfun(@(x) (size(x(x >0),1)/size(x,1)*100), delta_rank_t_sort);
mean_diff_touch = cellfun(@(x) (mean(diff(x))), delta_rank_t_sort);


%%
%split whisker data in half to do baseline variability
%load bouts_by_vid
BL_fw = 31;
for ianimal = 1:size(bouts_by_vid,2)
    curr_data = bouts_by_vid(:,ianimal);
    curr_data = curr_data(~cellfun(@isempty, curr_data));
    if size(curr_data,1) == 2
       curr_mat = cat(3, curr_data{1,1}, curr_data{2,1}); 
    elseif size(curr_data,1) == 3
        curr_mat = cat(3, curr_data{1,1}, curr_data{2,1}, curr_data{3,1});
    elseif size(curr_data,1) == 1
        curr_mat = cell2mat(curr_data);
    end
    
    trial_split = floor(size(curr_mat,3)/2);
    curr_sortvec = sort_vecs_fw{1,ianimal};
    [~, sort_order_fw] = sortrows(curr_sortvec);
    curr_mat_2 = curr_mat(:,:,trial_split+1:end);
    curr_mat_av2 = mean(curr_mat_2,3);
    curr_mat_av2_tosort = mean(curr_mat_av2(:, BL_fw:end),2);
    [~, sortvec_2] = sortrows(curr_mat_av2_tosort);    
    delta_rank_w{:,ianimal} = sort_order_fw - sortvec_2;
    clear sortvec_1
    clear sortvec_2
    clear curr_mat_1
    clear curr_mat_2  
end


delta_rank_w_sort = cellfun(@(x) (sortrows(x)), delta_rank_w, 'UniformOutput', 0);
zero_indices_w = cellfun(@(x) (find(x==0)), delta_rank_w_sort,'UniformOutput', 0);

%%
% calculate AUC

for ianimal = 1:size(delta_rank_t,2)    
    curr_x = 1:1:size(delta_rank_t_sort{1,ianimal},1); 
   results_auc_t_cum{1, ianimal} = trapz(curr_x, abs(delta_rank_t_sort{1,ianimal}))/length(curr_x)^2;
end
%%

for ianimal = 1:size(delta_rank_w,2)    
    curr_x = 1:1:size(delta_rank_w_sort{1,ianimal});
    results_auc_w_cum{1,ianimal} = trapz(curr_x, abs(delta_rank_w_sort{1,ianimal}))/length(curr_x)^2;
end
%%
cum_average_t = cellfun(@mean, results_auc_t_cum);
cum_average_w = cellfun(@mean, results_auc_w_cum);
cum_average_w = cell2mat(results_auc_w_cum(:));
cum_average_t = cell2mat(results_auc_t_cum(:));

%%

for ianimal = 1:12
    for ireps = 1:10000
        temp_fw = fw_sorting{1,ianimal}(randperm(length(fw_sorting{1,ianimal})));
        temp_t = t_sorting{1,ianimal}(randperm(length(t_sorting{1,ianimal})));
        shuffled_temp = temp_fw - temp_t;
        shuffled_sorted = sortrows(shuffled_temp);
        curr_x = 1:1:length(shuffled_sorted);
         shuffled_auc_temps_t(ireps,1) = trapz(curr_x, abs(shuffled_sorted))/length(curr_x)^2;
    end
   results_auc_t_shuffled(1,ianimal) = mean(shuffled_auc_temps_t); 
end


figure;
hold on;
bar(1, mean(cum_average_w));
errBar = std(cum_average_w);
errorbar(1, mean(cum_average_w), errBar, errBar, 'k');
x1 = ones(12,1);
scatter(x1, cum_average_w, 'ok');
title('Figure 4H');
bar(2, mean(cum_average_t));
errBar = std(cum_average_t);
errorbar(2, mean(cum_average_t), errBar, errBar, 'k');
x1 = ones(12,1)+1;
scatter(x1, cum_average_t, 'ok');
bar(3, mean(results_auc_t_shuffled));
errBar = std(results_auc_t_shuffled);
errorbar(3, mean(results_auc_t_shuffled), errBar, errBar, 'k');
x1 = ones(12,1)+2;
scatter(x1, results_auc_t_shuffled, 'ok');

mat_to_plot = [cum_average_w,cum_average_t]; 
for ianimal = 1:12
    plot(mat_to_plot(ianimal, :), 'k'); 
end

[aucp_t, auch_t, aucstats_t] = signrank(cum_average_t, results_auc_t_shuffled);
[aucp_wt, auch_wt, aucstats_wt] = signrank(cum_average_t, cum_average_w);


%%
%example figure
%touch
ianimal = 6;
shuffle_t_toplot = t_sorting{1,ianimal}(randperm(length(t_sorting{1,ianimal})));
shuffle_w_toplot = fw_sorting{1,ianimal}(randperm(length(fw_sorting{1,ianimal})));
shuf_t_sort_plot = shuffle_w_toplot - shuffle_t_toplot; 
shuf_t_sort_plot = sortrows(shuf_t_sort_plot);
curr_data = bouts_by_vid(:,ianimal);
curr_mat = cat(3, curr_data{1,1}, curr_data{2,1}); 
trial_split = floor(size(curr_mat,3)/2);
curr_sortvec = sort_vecs_fw{1,ianimal};
[~, sort_order_fw] = sortrows(curr_sortvec);
curr_mat_2 = curr_mat(:,:,1:trial_split);
curr_mat_av2 = mean(curr_mat_2,3);
curr_mat_av2_tosort = mean(curr_mat_av2(:, BL_fw:end),2);
[~, sortvec_2] = sortrows(curr_mat_av2_tosort);    
delta_rank_toplot = sort_order_fw - sortvec_2;
delta_rank_toplot = sortrows(delta_rank_toplot);
figure;
plot(delta_rank_t_sort{1,ianimal}, 'b-o');
hold on;
plot(shuf_t_sort_plot, 'o-', 'Color', [0.5 0.5 0.5]);
plot(delta_rank_toplot, 'r-o');
yline(0);
title('Figure 4G');
