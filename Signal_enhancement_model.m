%% Signal enhancement model %%
% Note to run this script, the type1roc and type2roc functions (same Github
% folder) must be in the same folder as this script
clear all
dbstop if error

n = 10000; % Trials
sigma1 = 1; % Remains constant with training in my signal enhancement model
sigma2 = 0; % sigma2=0 corresponds to single-stage model, sigma2>0 corresponds to dual-stage model
alpha = 1.1; % Increases with training in my signal enhancement model

criterion = 0; % Response criterion set to optimal
conf_rat = 4; % number of confidence ratings
signals = [];
signaln = [];

M = 0;
signals_matrix = []; signaln_matrix = [];

M_stim_intensity = (10^M)*alpha;
sig_mean = 0+(M_stim_intensity)/2;
noise_mean = 0-(M_stim_intensity)/2;
signalPresentAbsent = round(rand(1,n)); % Randomly determine which n trials are signal/noise trials
signals_matrix(:,1) = random('norm',sig_mean,sigma1,1,sum(signalPresentAbsent==1));
signaln_matrix(:,1) = random('norm',noise_mean,sigma1,1,sum(signalPresentAbsent==0));

%% Signal distribution
% Hits % Misses
for ii = 1:length(signals_matrix(:,1))
    if signals_matrix(ii,1) > criterion
        signals_matrix(ii,2) = 1; % Hit
    else
        signals_matrix(ii,2) = 0; % Miss
    end
end
% Correct & Incorrect
for nn = 1:length(signals_matrix(:,2))
    if signals_matrix(nn,2) == 1; % Hit
        signals_matrix(nn,3) = 1; % Correct
    elseif signals_matrix(nn,2) == 0; % Miss
        signals_matrix(nn,3) = 0; % Incorrect
    end
end

%% Noise distribution
% FAs and CRs
for ii = 1:length(signaln_matrix(:,1))
    if signaln_matrix(ii,1) > criterion
        signaln_matrix(ii,2) = 1; % FA
    else
        signaln_matrix(ii,2) = 0; % CR
    end
end
% Correct & Incorrect
for nn = 1:length(signaln_matrix(:,2))
    if signaln_matrix(nn,2) == 1; % FA
        signaln_matrix(nn,3) = 0; % Incorrect
    elseif signaln_matrix(nn,2) == 0; % CR
        signaln_matrix(nn,3) = 1; % Correct
    end
end

%% Add Gaussian noise
signals_noise = []; signaln_noise = [];
signals_noise = random('norm',0,sigma2,1,length(signals_matrix(:,1)));
signals_matrix(:,4) = signals_matrix(:,1) + signals_noise';
signaln_noise = random('norm',0,sigma2,1,length(signaln_matrix(:,1)));
signaln_matrix(:,4) = signaln_matrix(:,1) + signaln_noise';
combined_dist = [signals_matrix(:,4);signaln_matrix(:,4)];
combined_dist = abs(combined_dist);

vPrctile_conf = 0 : 25 : 100;
confThr = prctile(combined_dist,vPrctile_conf);
%% Signal
for m = 1: size(signals_matrix(:,4))
    tr_signal = abs(signals_matrix(m,4));
    if signals_matrix(m,2) == 1; % Hit
        if tr_signal < confThr(2)
            signals_matrix(m,5) = 1; % confidence 1
        elseif tr_signal >= confThr(2) && tr_signal < confThr(3)
            signals_matrix(m,5) = 2; % confidence 2
        elseif tr_signal >= confThr(3) && tr_signal < confThr(4)
            signals_matrix(m,5) = 3; % confidence 3
        elseif tr_signal >= confThr(4)
            signals_matrix(m,5) = 4; % confidence 4
        end
    elseif signals_matrix(m,2) == 0; % Miss
        if tr_signal < confThr(2)
            signals_matrix(m,5) = -1; % confidence 1
        elseif tr_signal >= confThr(2) && tr_signal < confThr(3)
            signals_matrix(m,5) = -2; % confidence 2
        elseif tr_signal >= confThr(3) && tr_signal < confThr(4)
            signals_matrix(m,5) = -3; % confidence 3
        elseif tr_signal >= confThr(4)
            signals_matrix(m,5) = -4; % confidence 4
        end
    end
end
%% Noise
for m = 1: size(signaln_matrix(:,4))
    tr_signal = abs(signaln_matrix(m,4));
    if signaln_matrix(m,2) == 1; % FA
        if tr_signal < confThr(2)
            signaln_matrix(m,5) = 1; % confidence 1
        elseif tr_signal >= confThr(2) && tr_signal < confThr(3)
            signaln_matrix(m,5) = 2; % confidence 2
        elseif tr_signal >= confThr(3) && tr_signal < confThr(4)
            signaln_matrix(m,5) = 3; % confidence 3
        elseif tr_signal >= confThr(4)
            signaln_matrix(m,5) = 4; % confidence 4
        end
    elseif signaln_matrix(m,2) == 0; % CR
        if tr_signal < confThr(2)
            signaln_matrix(m,5) = -1; % confidence 1
        elseif tr_signal >= confThr(2) && tr_signal < confThr(3)
            signaln_matrix(m,5) = -2; % confidence 2
        elseif tr_signal >= confThr(3) && tr_signal < confThr(4)
            signaln_matrix(m,5) = -3; % confidence 3
        elseif tr_signal >= confThr(4)
            signaln_matrix(m,5) = -4; % confidence 4
        end
    end
end

%% Correct & Incorrect matrices
correct_incorrect(:,1) = ([signals_matrix(:,3);signaln_matrix(:,3)]);
correct_incorrect(:,2) = abs([signals_matrix(:,5);signaln_matrix(:,5)]);

hit_II = correct_incorrect(correct_incorrect(:,1) == 1,2);
fa_II = correct_incorrect(correct_incorrect(:,1) == 0,2);

%% Type I AUC
TypeIAUC = type1roc(signals_matrix(:,5),signaln_matrix(:,5),conf_rat,n)

%% Type II AUC
TypeIIAUC = type2roc(hit_II,fa_II,conf_rat,n)
