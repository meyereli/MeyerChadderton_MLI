function [all_whisk_corrs, all_touch_corrs] = instantaneous_touch_corr(model_results_1, curr_whisk_conc, conc_model_1, neuract_touchlocs, whisking_onsets);

 win = 31;
for ianimal = 1:size(conc_model_1, 2) %animal used in example: 13
    for icond = 1:2
        curr_reconstr1 = conc_model_1{icond, ianimal};        
        curr_whisk = curr_whisk_conc{icond, ianimal};
         
        if icond == 2
           
           curr_touches = neuract_touchlocs{1,ianimal}(:,2);
           if size(curr_touches,1)> 3
               curr_touches(4:end,:) = [];
           end
           trm = rem(size(curr_reconstr1,2), 10000);
           trm1 = size(curr_reconstr1,2) - trm; 
           curr_reconstr1(:,trm1+1:trm1+trm) = [];           
           curr_whisk(:,trm1+1:trm1+trm) = [];
           temp_touches = [];
           for ivids = 1:size(curr_touches, 1)
                if isempty(curr_touches{ivids, 1})
                    continue
                else
                    temp_touches{ivids,1} = curr_touches{ivids,1} + (ivids-1)*10000; 
                end
           end
           all_touches = cell2mat(temp_touches');
           
           for itouch = 1:size(all_touches, 2)
               touch_now = floor(all_touches(1,itouch));
           %window before touch
                curr_BL1 = curr_reconstr1(1,touch_now-win:touch_now-1);                
                curr_whisk_BL = curr_whisk(1,touch_now-win:touch_now-1);                           
                temp_BL1_ccc(itouch,1) = concordance_corr(curr_BL1, curr_whisk_BL); 
                
           %window after touch
                curr_T1 = curr_reconstr1(1,touch_now:touch_now+win);                
                curr_whisk_T = curr_whisk(1,touch_now:touch_now+win);
                temp_T1_ccc(itouch,1) = concordance_corr(curr_T1, curr_whisk_T);
           end
           
                    
           all_touch_correfs_ccc(1,ianimal) = mean(temp_BL1_ccc);
           all_touch_correfs_ccc(2,ianimal) = std(temp_BL1_ccc);
           all_touch_correfs_ccc(3,ianimal) = mean(temp_T1_ccc);
           all_touch_correfs_ccc(4,ianimal) = std(temp_T1_ccc);
           
           temp_T1_ccc = [];
      
        elseif icond == 1           
            
            curr_onsets = whisking_onsets(:,ianimal); 
            trm = rem(size(curr_reconstr1,2), 10000);
            trm1 = size(curr_reconstr1,2) - trm; 
            curr_reconstr1(:,trm1+1:trm1+trm) = [];           
            curr_whisk(:,trm1+1:trm1+trm) = [];            
            nvids = size(curr_reconstr1,2) / 10000; 
            curr_onsets(nvids+1:end,:) = [];
            temp_whisks = [];
            for ivids = 1:nvids
                temp_whisks{ivids,1} = curr_onsets{ivids,1} + (ivids-1)*10000;             
            end
            
            all_whisks = cell2mat(temp_whisks)';
            temp_BL1_corr = [];                
            temp_T1_corr = [];             
               
                for iwhisk = 1:size(all_whisks, 2)
                   whisk_now = floor(all_whisks(1,iwhisk));
               %window before whisk
                    curr_BL1 = curr_reconstr1(1,whisk_now-win:whisk_now-1);
                    curr_whisk_BL = curr_whisk(1,whisk_now-win:whisk_now-1);
                    temp_BL1_ccc(iwhisk,1) = concordance_corr(curr_BL1, curr_whisk_BL);

               %window after whisk
                    curr_T1 = curr_reconstr1(1,whisk_now:whisk_now+win);
                    curr_whisk_T = curr_whisk(1,whisk_now:whisk_now+win);
                    temp_T1_ccc(iwhisk,1) = concordance_corr(curr_T1, curr_whisk_T);
                end

                all_whisk_correfs_ccc(1,ianimal) = mean(temp_BL1_ccc);
                all_whisk_correfs_ccc(2,ianimal) = std(temp_BL1_ccc);
                all_whisk_correfs_ccc(3,ianimal) = mean(temp_T1_ccc);
                all_whisk_correfs_ccc(4,ianimal) = std(temp_T1_ccc);                
                temp_T1_ccc = [];
        end    
    end
end


all_whisk_corrs{1,1} = all_whisk_correfs_ccc;
all_touch_corrs{1,1} = all_touch_correfs_ccc;
