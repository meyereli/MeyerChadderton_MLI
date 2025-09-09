
function [model_results] = predict_responses_from_transferfunc(curr_whisk_use, curr_ca_use, tf_objects, predict_what, per_cluster, cell_exclusion, time_window)

 
Fs = 31;

Ts = 1/31; %sample time = time between samples

model_results_notouch = [];
model_results_touch1 = [];

if cell_exclusion < 1
    
I = 1:size(curr_whisk_use{1,1},1);
opt = compareOptions('Samples', I);

for animal_idx = 1:size(curr_whisk_use,2)
  
 if strcmp(predict_what, 'calcium')
   
   curr_input = whisker{1, animal_idx};
   curr_output_cl1 = calcium_cl1{1, animal_idx};
   curr_output_cl2 = calcium_cl2{1, animal_idx};
   curr_model1 = tf_objects{icond,animal_idx};
   
   for seg_idx = 1:size(curr_input,2)
             
       dataobj_val1 = iddata(curr_output_cl1(:,seg_idx), curr_input(:,seg_idx), Ts); 
       dataobj_val2 = iddata(curr_output_cl2(:,seg_idx), curr_input(:,seg_idx), Ts); 
       
       [model_resp1, fit1, ic1] = compare(dataobj_val1, curr_model1, opt);
       [model_resp2, fit2, ic2] = compare(dataobj_val2, curr_model2, opt);
       
       model_results_notouch{1,animal_idx}{1,1}(:,seg_idx) = model_resp1.y;
       model_results_notouch{1,animal_idx}{2,1}(:,seg_idx) = fit1;
       model_results_notouch{1,animal_idx}{3,1}(:,seg_idx) = ic1;
       
       model_results_notouch{2,animal_idx}{1,1}(:,seg_idx) = model_resp2.y;
       model_results_notouch{2,animal_idx}{2,1}(:,seg_idx) = fit2;
       model_results_notouch{2,animal_idx}{3,1}(:,seg_idx) = ic2;
   end
   
   
 elseif strcmp(predict_what, 'whisker')
     
     for icond = 1:3
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
    ylim([60 160]);
end


elseif cell_exclusion > 0
   
    I = 1:size(curr_whisk_use,1);
    opt = compareOptions('Samples', I);

    
    curr_model = tf_objects;
   
   
   
    if strcmp(predict_what, 'calcium')
   
    curr_input = curr_whisk_use;
    curr_output = curr_ca_use;
    
   
    for seg_idx = 1:size(curr_input,2)
             
       dataobj_val = iddata(curr_output(:,seg_idx), curr_input(:,seg_idx), Ts); 
       
       
       [model_resp, fit, ic] = compare(dataobj_val, curr_model, opt);
       
       
       model_results_notouch{1,1}(:,seg_idx) = model_resp.y;
       model_results_notouch{2,1}(:,seg_idx) = fit;
       model_results_notouch{3,1}(:,seg_idx) = ic;
       
   end
   
   
 elseif strcmp(predict_what, 'whisker')
     
   curr_input = curr_ca_use;
   
   curr_output = curr_whisk_use;
  
   
   for seg_idx = 1:size(curr_input,2)
             
       dataobj_val = iddata(curr_output(:,seg_idx), curr_input(:,seg_idx), Ts); 
        
       
       [model_resp, fit, ic] = compare(dataobj_val, curr_model, opt);
       
       
       model_results_notouch{1,1}(:,seg_idx) = model_resp.y;
       model_results_notouch{2,1}(:,seg_idx) = fit;
       model_results_notouch{3,1}(:,seg_idx) = ic;
       
       
   end
     
     
 end
    
    
end


    
    
end
