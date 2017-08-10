function auroc2 = type2roc(correct, incorrect, Nratings, Ntrials)


% Calculate Proportions for each cell divided by number of trials (S or N)
for co = 1:(Nratings-1)
    hit_trials = numel(correct(correct(:,1) > co));
    hit_prop(co) = hit_trials/length(correct); % Proportion of each cell relative to total trials
    fa_trials = numel(incorrect(incorrect(:,1) > co));
    fa_prop(co) = fa_trials/length(incorrect);
end
hits_cumprop = fliplr(hit_prop);
fa_cumprop = fliplr(fa_prop);
% Calculation cumulative Proportions
% hits_cumprop = cumsum(hit_prop);
% fa_cumprop = cumsum(fa_prop);
hits_cumprop(isnan(hits_cumprop)) = 1/Ntrials; hits_cumprop(hits_cumprop == 1) = (Ntrials-1)/Ntrials; hits_cumprop(hits_cumprop == 0) = 1/Ntrials;
fa_cumprop(isnan(fa_cumprop)) = 1/Ntrials; fa_cumprop(fa_cumprop == 1) = (Ntrials-1)/Ntrials; fa_cumprop(fa_cumprop == 0) = 1/Ntrials;
%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%

hits_cumprop = roundn(hits_cumprop,-6); % Round to 6 decimals
fa_cumprop = roundn(fa_cumprop,-6);



auroc2 = AreaUnderROC([hits_cumprop' fa_cumprop']); % Hits and FA must be in columns, not rows
% figure(3)
% hit_plot(2:4) = hits_cumprop;
% hit_plot(1) = 0; hit_plot(5) = 1;
% fa_plot(2:4) = fa_cumprop;
% fa_plot(1) = 0; fa_plot(5) = 1;
% plot(fa_plot,hit_plot)
% ylim([0 1])
% % 

    
    
    
    
    
    


    
    
