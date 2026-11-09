function [curr_whisk_use, curr_ca_use, tf_objects_all, model_results_1] = linearmodel_standard(neuract, whisker_traces);


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

        ll = size(mat_nopolewhisk,1);
        ll_tobe = ceil(ll/time_window)*time_window;
        curr_whisk = [mat_nopolewhisk; zeros(1,ll_tobe-ll)'];
        curr_whisk_use{1, ianimal} = reshape(curr_whisk, time_window, []);
        curr_ca = [mat_nopole; zeros(1,ll_tobe-ll)'];
        curr_ca_use{1, ianimal} = reshape(curr_ca, time_window, []);
        curr_pole1 = neuract{1,ianimal}(:,2);
        curr_pole1 = curr_pole1(~cellfun('isempty', curr_pole1));
        curr_pole1whisk = whisker_traces(size(curr_nopole,1)+1:size(curr_pole1,1)+size(curr_nopole,1),ianimal);
        mat_pole1 = mean(cell2mat(curr_pole1'))';
        mat_pole1whisk = cell2mat(curr_pole1whisk);
        mat_pole1whisk = smoothdata(mat_pole1whisk, 'Gaussian', 10);

        ll = size(mat_pole1whisk,1);
        ll_tobe = ceil(ll/time_window)*time_window;
        curr_whisk = [];
        curr_whisk = [mat_pole1whisk; zeros(1,ll_tobe-ll)'];
        curr_whisk_use{2, ianimal} = reshape(curr_whisk, time_window, []);
        curr_ca = [mat_pole1; zeros(1,ll_tobe-ll)'];
        curr_ca_use{2, ianimal} = reshape(curr_ca, time_window, []);

%         curr_polepuff = neuract{1,ianimal}(:,3);
%         curr_polepuff = curr_polepuff(~cellfun('isempty', curr_polepuff));
%         curr_polepuffwhisk = whisker_traces(size(curr_nopole,1)+size(curr_pole1,1) +1:end,ianimal);
%         mat_polepuff = mean(cell2mat(curr_polepuff'))';
%         mat_polepuffwhisk = cell2mat(curr_polepuffwhisk);
%         mat_polepuffwhisk = smoothdata(mat_polepuffwhisk, 'Gaussian', 10);

%         ll = size(mat_polepuffwhisk,1);
%         ll_tobe = ceil(ll/time_window)*time_window;
%         curr_whisk = [];
%         curr_whisk = [mat_polepuffwhisk; zeros(1,ll_tobe-ll)'];
%         curr_whisk_use{3, ianimal} = reshape(curr_whisk, time_window, []);
%         curr_ca = [mat_polepuff; zeros(1,ll_tobe-ll)'];
%         curr_ca_use{3, ianimal} = reshape(curr_ca, time_window, []);
        

        for icond = 1:2
            [tf_objects] = calc_the_transfer_function(curr_whisk_use{icond, ianimal}, curr_ca_use{icond, ianimal}, Fs, 'whisker');

            tf_objects_all{icond, ianimal} = tf_objects;
        end
    end

%%

[model_results_1] = predict_responses_from_transferfunc(curr_whisk_use, curr_ca_use, tf_objects_all, 'whisker', 0, time_window);
