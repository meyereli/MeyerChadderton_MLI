function [results_pvalue] = make_figures_stats(input1, input2, input3);

if ~exist('input3','var')
    if iscell(input1)
        mats1 = cellfun(@(x) x(1), input1); 
        mats2 = cellfun(@(x) x(1), input2);    
        mats1 = cell2mat(mats1);
        mats2 = cell2mat(mats2);
    else 
        mats1 = input1;
        mats2 = input2;
    end
    
    figure;
    hold on;
    bar(1, mean(mats1));
    errBar = std(mats1);
    errorbar(1, mean(mats1), errBar, errBar, 'k');
    x = ones(12,1);
    scatter(x, mats1, 'k');
    bar(2, mean(mats2));
    errBar = std(mats2);
    errorbar(2, mean(mats2), errBar, errBar, 'k');
    x = ones(12,1)+1;
    scatter(x, mats2, 'k');  
    mat_for_plot= [mats1; mats2];
    for ianimal = 1:12
        plot(mat_for_plot(:,ianimal), 'k');
    end
    
    p = signrank(mats1, mats2);
    results_pvalue = p;
    results_pvalue(2,1) = mean(mats1);
    results_pvalue(3,1) = std(mats1);
    results_pvalue(4,1) = mean(mats2);
    results_pvalue(5,1) = std(mats2);

else
    
    mats1 = cellfun(@(x) x(1), input1); 
    mats2 = cellfun(@(x) x(1), input2);
    mats3 = cellfun(@(x) x(1), input3);
    if iscell(mats1)
    mats1 = cell2mat(mats1);
    end
    if iscell(mats2)
    mats2 = cell2mat(mats2); 
    end
    if iscell(mats3)
    mats3 = cell2mat(mats3); 
    end
    
    figure;
    hold on;
    bar(1, mean(mats1));
    errBar = std(mats1);
    errorbar(1, mean(mats1), errBar, errBar, 'k');
    x = ones(12,1);
    scatter(x, mats1, 'k');
    bar(2, mean(mats2));
    errBar = std(mats2);
    errorbar(2, mean(mats2), errBar, errBar, 'k');
    x = ones(12,1)+1;
    scatter(x, mats2, 'k');   
    bar(3, mean(mats3));
    errBar = std(mats3);
    errorbar(3, mean(mats3), errBar, errBar, 'k');
    x = ones(12,1)+2;
    scatter(x, mats3, 'k');
    
    p = nan;
    results_pvalue(1,1) = p;
    results_pvalue(2,1) = mean(mats1);
    results_pvalue(3,1) = std(mats1);
    results_pvalue(4,1) = mean(mats2);
    results_pvalue(5,1) = std(mats2);
    results_pvalue(6,1) = mean(mats3);
    results_pvalue(7,1) = std(mats3);

    
    
end