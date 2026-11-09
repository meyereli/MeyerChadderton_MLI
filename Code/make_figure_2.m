function [sort_vecs_fw] = make_figure_2(bouts_by_animal, neuract, whisker_traces, whisking_onsets, all_whisk)

curr_data = bouts_by_animal{1,6}; 
BL_fw = 36;

sorting_vect = mean(curr_data(:,BL_fw : end),2);
[~,sorting_order] = sortrows(sorting_vect);
sorted_whiskact = curr_data(sorting_order,:);
figure
imagesc(sorted_whiskact);
curr_max = max(max(curr_data));
curr_min = min(min(curr_data));
[colmap] = generate_colours(1, 1, 1.13, 0.98);
colormap(colmap);
caxis([0.98 1.18]);
colorbar;
xline(BL_fw, '--k');
set_any_xaxis_to_standard_time;
set(gca,'FontSize',12);
ylabel('Cell #');
set(gcf,'renderer','painters');
title('Figure 2A');

sort_vecs_fw = cellfun(@(x) (mean(x(:,BL_fw : end),2)), bouts_by_animal, 'UniformOutput',0);
%%
ca_bouts = neuract; 
whisking_bouts = whisker_traces; 

curr_bouts = whisking_bouts(1:2,3);
curr_onsets = whisking_onsets(1:2,3);
curr_ca = ca_bouts{1,3}(1:2,1);
 for ianimal = 1:12
     curr_bouts = whisking_bouts(1:2,ianimal);
     curr_onsets = whisking_onsets(1:2,ianimal);
     curr_ca = ca_bouts{1,ianimal}(1:2,1);
     fw_BL = 31;
     for ivids = 1:size(curr_bouts,1)
         bouts_use = curr_bouts{ivids,1}';
         onsets_use = curr_onsets{ivids,1}; 
         ca_use = curr_ca{ivids,1};
         whisk_temp = [];
         ca_temp = [];
         std_temp = [];
         for iwhisk = 1:size(onsets_use,1) %iwhisk = 13 used in Figure!!
             onset_temp = onsets_use(iwhisk,1);
             whisk_temp(iwhisk,:) = bouts_use(:, onset_temp-fw_BL:onset_temp+94);
         end
      animal_whisks(ivids,:, ianimal) = mean(whisk_temp,1);
    end
 end

 test = squeeze(mean(animal_whisks,1))'; 
 errBar_sem = std(test, 1)/sqrt(12);
 ts = tinv([0.025  0.975],length(test)-1)';
 errBar =  ts(1,1)*errBar_sem;
 figure;
 subplot(2,1,1)
 hold on
 x = 1:length(errBar);
 shadedErrorBar(x, mean(test,1), errBar, 'k'); 
 set_any_xaxis_to_standard_time;
 title('Figure 2B');
 hold on;
 subplot(2,1,2)
 y = nanmean(all_whisk(:,1:126),1); 
 errBar_sem = nanstd(all_whisk(:,1:126), 1)/sqrt(size(all_whisk,1)); 
 ts = tinv([0.025  0.975],length(y)-1)';
 errBar =  ts(1,1)*errBar_sem;
 H=shadedErrorBar(x, y, errBar, 'r');
 set_any_xaxis_to_standard_time;
 ylabel('dF/F')
 figure;
 hold on;
 xaxis_vec_large = ones(1,328);
y1 = nanmean(all_whisk(:, 62:120),2) - nanmean(all_whisk(:, 1:BL_fw),2);
violin(y1,'x',[1 0 3], 'medc','');
ylim([-0.04 0.2]);
ylabel('Evoked Ca2+ amp. (dF/F');
title('Figure 2C');
yline(0);
errorbar(1, nanmean(y1), nanstd(y1), nanstd(y1), 'k');