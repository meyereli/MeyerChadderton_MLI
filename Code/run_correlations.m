function [results_corrs, curr_whisk_conc, conc_model_1, conc_model_shift] = run_correlations(model_results_1, model_results_1_shift, curr_whisk_use); 




for ianimal = 1:12
    %data organized by column 
   
        
        for icond = 1:size(model_results_1,1)
             conc_model_1{icond,ianimal} = reshape(model_results_1{icond, ianimal}{1,1}, 1, []);
            conc_model_shift{icond,ianimal} = reshape(model_results_1_shift{icond, ianimal}{1,1}, 1, []);    
             curr_whisk_conc{icond,ianimal} = reshape(curr_whisk_use{icond,ianimal}, 1, []); %
            %CCC
            clear R1ccc
            R1ccc = concordance_corr(conc_model_1{icond,ianimal},curr_whisk_conc{icond,ianimal});
            corr_results_conc_ccc{icond,ianimal}{1,1} = R1ccc;
            %shifted comparison
            %CCC
            clear R1ccc
            R1ccc = concordance_corr(conc_model_shift{icond,ianimal},curr_whisk_conc{icond,ianimal});
            corr_results_conc_ccc_shift{icond,ianimal}{1,1} = R1ccc;

            
         
        end
    
    
    
end




results_corrs{1,1} = corr_results_conc_ccc(1,:);
results_corrs{2,1} =  corr_results_conc_ccc_shift(1,:);
