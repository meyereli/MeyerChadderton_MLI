%Code to generate figures for Meyer & Chadderton 2025
%(https://doi.org/10.1101/2025.08.12.669821)
%Script tested in Matlab 2018b

%load all data files connected to this project in the workspace!
%have all m-files associated with this project on the Matlab path!
% 

%reassemble cell arrays of data
for ianimal = 1:12
    ianimal_s = string(ianimal);
    vname = strcat('animal', ianimal_s);
    neuract_touchlocs{1,ianimal} = eval(vname); 
    
end

clear animal1 animal2 animal3 animal4 animal5 animal6 animal7 animal8 animal9 animal10 animal11 animal12

for ianimal = 1:12
    ianimal_s = string(ianimal);
    vname = strcat('neuract_animal', ianimal_s);
    neuract{1,ianimal} = eval(vname);   
    
end

clear neuract_animal1 neuract_animal2 neuract_animal3 neuract_animal4 neuract_animal5 neuract_animal6 neuract_animal7 neuract_animal8 neuract_animal9 neuract_animal10 neuract_animal11 neuract_animal12
clear ianimal ianimal_s vname

%%
% Figure 4
[all_whisk, all_touch, all_movtouch] = make_figure_4B(neuract_touchlocs, bouts_by_vid);

make_figure_4CD(all_whisk,all_movtouch, all_touch)
make_figure_4E(neuract_touchlocs)
%%
%Figure 2
[sort_vecs_fw] = make_figure_2(bouts_by_animal, neuract, whisker_traces, whisking_onsets, all_whisk);

%%
%Figure 4F
make_figure_4FGH1(neuract_touchlocs, sort_vecs_fw, bouts_by_vid)

%%
%mean and sem of number of MLIs per animal
number_of_neurons = cellfun(@(x) size(x,1), bouts_by_animal);
mean_number_of_neurons = mean(number_of_neurons);
std_number_of_neurons = std(number_of_neurons);

%%
%Figure 3 & 5 - linear transfer function
[curr_whisk_use, curr_ca_use, tf_objects_all, model_results_1] = linearmodel_standard(neuract, whisker_traces);
[model_results_1_shift] = linearmodel_resampled(curr_whisk_use, curr_ca_use, tf_objects_all);

%%
%figure 3
[results_corrs, curr_whisk_conc, conc_model_1, conc_model_shift] = run_correlations(model_results_1, model_results_1_shift, curr_whisk_use); 
%figure 5
[all_whisk_corrs, all_touch_corrs] = instantaneous_touch_corr(model_results_1, curr_whisk_conc, conc_model_1, neuract_touchlocs, whisking_onsets);
%%
%Figure 3 - Velocity, acceleration and curvature
[curr_whisk_use_diff, curr_ca_use_diff,tf_objects_all_1diff, model_results_1diff] = linearmodel_derivative1(neuract, whisker_traces);
[curr_whisk_use_diff2, curr_ca_use_diff2,tf_objects_all_2diff, model_results_2diff] = linearmodel_derivative2(neuract, whisker_traces);
[results_diff] = correlate_derivatives(model_results_1diff, model_results_2diff, curr_whisk_use_diff, curr_whisk_use_diff2);
[curr_whisk_use_curve, curr_ca_use_curve,tf_objects_all_curve, model_results_curve] = linearmodel_curvature(neuract, curv_smooth);
[results_curv, curr_whisk_conc, conc_model_1] = run_correlations_curvature(model_results_curve, curr_whisk_use_diff); 
%%
%Figure 3 - whisking correlations vs shifted
[results_pvalue] = make_figures_stats(results_corrs{1,1}, results_corrs{2,1});
title('Figure 3C');
ylabel('CCC');
[results_pvalue] = make_figures_stats(results_diff{1,1}, results_diff{2,1}, results_curv{1,1});
ylabel('CCC');
title('Figure 3E');
%figure 5
[results_pvalue] = make_figures_stats(all_whisk_corrs{1,1}(3,:), all_touch_corrs{1,1}(3,:));
ylabel('CCC');
title('Figure 5C');

%%
% x = 1:time_window;
% for animal_idx = 1:12
%     
%     curr_prediction1 = model_results_1diff{1,animal_idx}{1,1};  
%         
%     to_plot = curr_whisk_use{1,animal_idx};
%    figure;
%    hold on;
%     
%     for seg_idx = 1:size(curr_prediction1,2)
%         x_use = x+(seg_idx*time_window);
%      
%         plot(x_use,to_plot(:,seg_idx), 'k');
%         hold on;
%         plot(x_use, curr_prediction1(:,seg_idx), 'r');
%     
%     end
%    
%     title(strcat('Animal ', num2str(animal_idx)));
% end


