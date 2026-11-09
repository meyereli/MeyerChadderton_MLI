function [model_results_1_shift] = linearmodel_resampled(curr_whisk_use, curr_ca_use, tf_objects_all);


win_sec = 20;
Fs = 31;
time_window = Fs*win_sec;

%randomly resample trace 
for ianimal = 1:size(curr_whisk_use, 2)
    for icond = 1:size(curr_whisk_use,1)
        curr_data = curr_ca_use{icond,ianimal}; 
        curr_data(curr_data == 0) = mean(mean(curr_data));
        curr_data = curr_data(:);        
   %     curr_data_shift = circshift(curr_data, shift_win*Fs);
        curr_data_shift = curr_data; 
         curr_data_shift = curr_data_shift(randperm(length(curr_data_shift)));
        
        curr_ca_use_shift{icond, ianimal} = reshape(curr_data_shift, time_window, []);
       
    end
end


%%
per_cluster = 0;
[model_results_1_shift] = predict_responses_from_transferfunc(curr_whisk_use, curr_ca_use_shift, tf_objects_all, 'whisker', 0, time_window);

