function [results_diff] = correlate_derivatives(model_results_1diff, model_results_2diff, curr_whisk_use_diff, curr_whisk_use_diff2);


for ianimal = 1:12
    %data organized by column 
   
        
        for icond = 1;
             conc_model_1{icond,ianimal} = reshape(model_results_1diff{icond, ianimal}{1,1}, 1, []);
            conc_model_2{icond,ianimal} = reshape(model_results_1diff{icond, ianimal}{1,1}, 1, []);    
             curr_whisk_conc{icond,ianimal} = reshape(curr_whisk_use_diff{icond,ianimal}, 1, []); %

            %CCC
            clear R1ccc
            R1ccc = concordance_corr(conc_model_1{icond,ianimal},curr_whisk_conc{icond,ianimal});
            corr_results_1diff_ccc{icond,ianimal}{1,1} = R1ccc;
 %           2nd diff
            curr_whisk_conc{icond,ianimal} = reshape(curr_whisk_use_diff2{icond,ianimal}, 1, []); %

           % CCC
            clear R2ccc
            R2ccc = concordance_corr(conc_model_2{icond,ianimal},curr_whisk_conc{icond,ianimal});
            corr_results_2diff_ccc{icond,ianimal}{1,1} = R2ccc;
  
        end
    
    clear curr_whisk_conc;
    
end


results_diff{1,1} = corr_results_1diff_ccc;
results_diff{2,1} = corr_results_2diff_ccc;