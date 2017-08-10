function auroc1 = type1roc(hits, fa, Nratings, Ntrials)

% Transform the confidence scales for ROC analysis
for hi = 1:size(hits,1)
    if hits(hi,1) == 4
        hits(hi,1) = 1;
    elseif hits(hi,1) == 3
        hits(hi,1) = 2;
    elseif hits(hi,1) == 2
        hits(hi,1) = 3;
    elseif hits(hi,1) == 1
        hits(hi,1) = 4;
    elseif hits(hi,1) == -1
        hits(hi,1) = 5;
    elseif hits(hi,1) == -2
        hits(hi,1) = 6;
    elseif hits(hi,1) == -3
        hits(hi,1) = 7;
    elseif hits(hi,1) == -4
        hits(hi,1) = 8;
    end
end


for fai = 1:size(fa,1)
    if fa(fai,1) == 4
        fa(fai,1) = 1;
    elseif fa(fai,1) == 3
        fa(fai,1) = 2;
    elseif fa(fai,1) == 2
        fa(fai,1) = 3;
    elseif fa(fai,1) == 1
        fa(fai,1) = 4;
    elseif fa(fai,1) == -1
        fa(fai,1) = 5;
    elseif fa(fai,1) == -2
        fa(fai,1) = 6;
    elseif fa(fai,1) == -3
        fa(fai,1) = 7;
    elseif fa(fai,1) == -4
        fa(fai,1) = 8;
    end
end

% Calculate Proportions for each cell divided by number of trials (S or N)
for co = 1:(2*Nratings)
    hit_trials = (hits(hits(:, 1) == co, :)); % Number of trials with confidence greater than co
    hit_prop(co) = numel(hit_trials(:,1))/size(hits,1); % Proportion of each cell relative to total trials
    fa_trials = (fa(fa(:, 1) == co, :));
    fa_prop(co) = numel(fa_trials(:,1))/size(fa,1);
end

% Calculation cumulative Proportions
hits_cumprop = cumsum(hit_prop);
fa_cumprop = cumsum(fa_prop);

hits_cumprop = roundn(hits_cumprop,-6); % Round to 6 decimals
fa_cumprop = roundn(fa_cumprop,-6);

hits_cumprop(isnan(hits_cumprop)) = 1/Ntrials; hits_cumprop(hits_cumprop == 1) = (Ntrials-1)/Ntrials; hits_cumprop(hits_cumprop == 0) = 1/Ntrials;
fa_cumprop(isnan(fa_cumprop)) = 1/Ntrials; fa_cumprop(fa_cumprop == 1) = (Ntrials-1)/Ntrials; fa_cumprop(fa_cumprop == 0) = 1/Ntrials;

auroc1 = AreaUnderROC([hits_cumprop' fa_cumprop']); % Hits and FA must be in columns, not rows




    
    
    
    
    
    
    
    
    


    
    
