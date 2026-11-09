function [results_corrs, curr_whisk_conc, conc_model_1] = run_correlations_curvature(model_results_1, curr_whisk_use); 





for ianimal = 1:12
    %data organized by column 
   
        
        for icond = 1
            
            curr_model_conc = model_results_1{icond,ianimal};
            
            for model_idx = 1:size(curr_model_conc, 2)            
            
                conc_model_1{icond,ianimal}{1,model_idx} = reshape(curr_model_conc{1, model_idx}, 1, []);
                curr_whisk_conc{icond,ianimal} = reshape(curr_whisk_use{icond,ianimal}, 1, []); %
                %CCC
                clear R1ccc
                R1ccc = concordance_corr(conc_model_1{icond,ianimal}{1,model_idx},curr_whisk_conc{icond,ianimal});
                corr_results_conc_ccc{icond,ianimal}{1,model_idx} = R1ccc;            
            end
        end
    
    
    
end











results_corrs{1,1} = corr_results_conc_ccc(1,:);

