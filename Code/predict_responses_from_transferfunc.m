
function [model_results] = predict_responses_from_transferfunc(curr_whisk_use, curr_ca_use, tf_objects, predict_what, cell_exclusion, time_window)

 
Fs = 31;

Ts = 1/31; %sample time = time between samples

model_results = [];

if cell_exclusion < 1
    
I = 1:size(curr_whisk_use{1,1},1);
opt = compareOptions('Samples', I);

for animal_idx = 1:size(curr_whisk_use,2)
  
 if strcmp(predict_what, 'whisker')
     
     for icond = 1:size(tf_objects,1)
    curr_input = curr_ca_use{icond, animal_idx};
    curr_output = curr_whisk_use{icond,animal_idx};
    curr_model1 = tf_objects{icond,animal_idx};
  
        for seg_idx = 1:size(curr_input,2)
             
           dataobj_val1 = iddata(curr_output(:,seg_idx), curr_input(:,seg_idx), Ts); 
           [model_resp1, fit1, ic1] = compare(dataobj_val1, curr_model1, opt);
           model_results{icond,animal_idx}{1,1}(:,seg_idx) = model_resp1.y;
           model_results{icond,animal_idx}{2,1}(:,seg_idx) = fit1;
           model_results{icond,animal_idx}{3,1}(:,seg_idx) = ic1;


        end
     
     
    end
 end 
    
end

%%

x = 1:time_window;
for animal_idx = 11%1:size(curr_whisk_use,2)
    figure;
    
    curr_prediction1 = model_results{1,animal_idx}{1,1};
    if strcmp(predict_what, 'calcium')
        to_plot = calcium_cl1{1,animal_idx};
    elseif strcmp(predict_what, 'whisker')
        to_plot = curr_whisk_use{1,animal_idx};
    end
    
    for seg_idx = 1:size(curr_prediction1,2)
        x_use = x+(seg_idx*time_window);
        plot(x_use,to_plot(:,seg_idx), 'k');
        hold on;
        plot(x_use, curr_prediction1(:,seg_idx), 'r');
    
    end
   
    title(strcat('Animal ', num2str(animal_idx)));
   
end

end
