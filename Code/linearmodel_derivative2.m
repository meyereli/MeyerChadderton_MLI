function [curr_whisk_use_diff2, curr_ca_use_diff2,tf_objects_all_2diff, model_results_2diff] = linearmodel_derivative2(neuract, whisker_traces);


win_sec = 20;
Fs = 31;
time_window = Fs*win_sec;

    for ianimal = 1:size(neuract, 2)

        curr_nopole = neuract{1,ianimal}(:,1);
        curr_nopole = curr_nopole(~cellfun('isempty', curr_nopole));
        curr_nopolewhisk = whisker_traces(1:size(curr_nopole,1),ianimal);
        mat_nopole = mean(cell2mat(curr_nopole'))';
        mat_nopolewhisk = cell2mat(curr_nopolewhisk);
        mat_nopolewhisk = smoothdata(mat_nopolewhisk, 'Gaussian', 10);
%         mat_nopolewhisk_2diff = diff(diff(mat_nopolewhisk));
%         mat_nopolewhisk_2diff(numel(mat_nopolewhisk)) = 0;
        mat_nopolewhisk_2diff = gradient(gradient(mat_nopolewhisk));
        
        ll = size(mat_nopolewhisk_2diff,1);
        ll_tobe = ceil(ll/time_window)*time_window;

        curr_whisk2 = [mat_nopolewhisk_2diff; zeros(1,ll_tobe-ll)'];

        curr_whisk_use2{1, ianimal} = reshape(curr_whisk2, time_window, []);

        curr_ca = [mat_nopole; zeros(1,ll_tobe-ll)'];
        curr_ca_use{1, ianimal} = reshape(curr_ca, time_window, []);

        

       
            [tf_objects_2diff] = calc_the_transfer_function(curr_whisk_use2{1, ianimal}, curr_ca_use{1, ianimal}, Fs, 'whisker');

            tf_objects_all_2diff{1, ianimal} = tf_objects_2diff;
       
           

    end
    

    [model_results_2diff] = predict_responses_from_transferfunc(curr_whisk_use2, curr_ca_use, tf_objects_all_2diff, 'whisker', 0, time_window);

    
    curr_whisk_use_diff2 = curr_whisk_use2;    
    curr_ca_use_diff2 = curr_ca_use;
    