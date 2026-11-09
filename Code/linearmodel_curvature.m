function [curr_whisk_use_curve, curr_ca_use_curve,tf_objects_all_curve, model_results_curve] = linearmodel_curvature(neuract, whisker_traces);

win_sec = 20;
Fs = 31;
time_window = Fs*win_sec;

    for ianimal = 1:size(neuract, 2)

        curr_nopole = neuract{1,ianimal}(:,1);
        curr_nopole = curr_nopole(~cellfun('isempty', curr_nopole));
        curr_nopolewhisk = whisker_traces(1:size(curr_nopole,1),ianimal);
        mat_nopole = mean(cell2mat(curr_nopole'))';
        mat_nopolewhisk = cell2mat(curr_nopolewhisk);
        mat_nopolewhisk_1diff = mat_nopolewhisk;
        
        ll = size(mat_nopolewhisk_1diff,1);
        ll_tobe = ceil(ll/time_window)*time_window;
        curr_whisk = [mat_nopolewhisk_1diff; zeros(1,ll_tobe-ll)'];
        curr_whisk_use{1, ianimal} = reshape(curr_whisk, time_window, []);
        curr_ca = [mat_nopole; zeros(1,ll_tobe-ll)'];
        curr_ca_use{1, ianimal} = reshape(curr_ca, time_window, []);     
        [tf_objects_1diff] = calc_the_transfer_function(curr_whisk_use{1, ianimal}, curr_ca_use{1, ianimal}, Fs, 'whisker');
        tf_objects_all_curve{1, ianimal} = tf_objects_1diff;
    end


[model_results_curve] = predict_responses_from_transferfunc(curr_whisk_use, curr_ca_use, tf_objects_all_curve, 'whisker', 0, time_window);
curr_whisk_use_curve = curr_whisk_use;
curr_ca_use_curve = curr_ca_use;
