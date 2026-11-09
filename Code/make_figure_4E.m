function make_figure_4E(neuract_touchlocs)

%Figure 4E
%from neuract_touchlocs
%column 7: Ca aligned to whisk onset per neuron
%column 9: Ca aligned to touch onset per neuron
BL_fw = 31;
BL_touch = 300; 
BL_puff = 93;

for ianimal = 1:size(neuract_touchlocs, 2)
    for ivids = 1:size(neuract_touchlocs{1,ianimal})
        curr_data = cell2mat(neuract_touchlocs{1,ianimal}(ivids,7));
        curr_data_touch = cell2mat(neuract_touchlocs{1,ianimal}(ivids,9));
        curr_data_mean = mean(curr_data,3);
        latency_to_peak_mean = [];
        for irow = 1:size(curr_data_mean, 1)
             try                
               data_use = curr_data_mean(irow, BL_fw:BL_fw+45); 
               data_use_mean = movmean(data_use, 5);
               upper_statelevel = max(data_use_mean); 
               lower_statelevel = min(data_use_mean); 
               latency_to_peak_mean(irow,:) = risetime(data_use_mean, 'StateLevels',[lower_statelevel upper_statelevel]); 
             catch
                latency_to_peak_mean(irow,:) = nan;
                latency_to_peak_mean(irow,:) = nan;
                latency_to_peak_mean(irow,:) = nan; 
             end 
        end
        latency_to_peak_time_mean = latency_to_peak_mean/31;  
        latency_byneuron_temp(:,ivids) = latency_to_peak_time_mean(:,1);        
        if isempty(curr_data_touch)
            latency_byneuron_temp_touch(:,ivids) = nan;
        else
        curr_data_mean_touch = nanmean(curr_data_touch,3);
        latency_to_peak_mean_touch = [];
            for irow = 1:size(curr_data_mean_touch, 1)
                try
                    data_use = curr_data_mean_touch(irow, BL_touch:BL_touch+45); 
                    data_use_mean = movmean(data_use, 5);
                    upper_statelevel = max(data_use_mean); 
                    lower_statelevel = min(data_use_mean); 
                    latency_to_peak_mean_touch(irow,:) = risetime(data_use_mean, 'StateLevels',[lower_statelevel upper_statelevel]);
                catch
                    latency_to_peak_mean_touch(irow,:) = nan;
                    latency_to_peak_mean_touch(irow,:) = nan;
                    latency_to_peak_mean_touch(irow,:) = nan; 
                end 
            end        

            latency_to_peak_time_mean_touch = latency_to_peak_mean_touch/31;
            if ~isempty (latency_to_peak_time_mean_touch)
                latency_byneuron_temp_touch(:,ivids) = latency_to_peak_time_mean_touch(:,1);
            else
                latency_byneuron_temp_touch(:,ivids) = nan;
            end
          end
        
        
    end    
    latency_byneuron{1,ianimal} = nanmean(latency_byneuron_temp,2);
    latency_byneuron{2,ianimal} = nanstd(latency_byneuron_temp,[],2);
    latency_byneuron_temp = [];    
    latency_byneuron_touch{1,ianimal} = nanmean(latency_byneuron_temp_touch,2);
    latency_byneuron_touch{2,ianimal} = nanstd(latency_byneuron_temp_touch,[],2);
    latency_byneuron_temp_touch = [];
end

%%
figure; 
idx_nans = isnan(latency_byneuron_touch{1,6});
curr_data = latency_byneuron_touch{1,6};
curr_data(idx_nans) = [];
yvalues_size = size(curr_data,1);
yvalues = 1:yvalues_size;
curr_data_sort = sortrows(curr_data);
plot(curr_data_sort, yvalues, '>');
set(gca, 'ydir', 'reverse');
hold on;
curr_data = latency_byneuron{1,6};
curr_data(idx_nans) = [];
curr_data_sort = sortrows(curr_data);
plot(curr_data_sort, yvalues, '>');
set(gca, 'ydir', 'reverse');
hold on;
title('Figure 4E');
xlabel('Rise time (s)');
ylabel('Cell #');
figure;
temp = latency_byneuron(1,:)';
latency_whisk = cell2mat(temp);
hold on;
yline(0);
errBar = nanstd(latency_whisk);
errorbar(1, nanmean(latency_whisk), errBar, errBar, 'k');
violin(latency_whisk,'x',[1 0 4], 'medc','');
temp = latency_byneuron_touch(1,:)';
latency_touch = cell2mat(temp);
hold on;
errBar = nanstd(latency_touch);
errorbar(2, nanmean(latency_touch), errBar, errBar, 'k');
violin(latency_touch,'x',[2 0 4],'facecolor','b', 'medc','');
ylabel('Rise time (s)');
title('Figure 4E');
[pw2, hw2, stats2] = signrank(latency_whisk, latency_touch);
txt = ['p = ', string(pw2)];
text(3, 0.18, txt);
