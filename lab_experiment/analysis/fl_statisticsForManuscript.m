%% fl_statisticsForManuscript 
%  This script runs though all statistics included in Flanker manuscript

%% Descriptives:

%% see if IQ differs between the groups
[h,p] = ttest2(control.wasi_mr_ts,dys.wasi_mr_ts);

% Calculate Cohen's D
d = computeCohen_d(control.wasi_mr_ts,dys.wasi_mr_ts);

%% Children with dyslexia have larger Flanker Effects than controls 

% First, we analyze the PING data.

% Load in PING data
fl = fl_PING_analysis;

% Stack data: NOTE: find a more elegant way to do this. 
X(1:560,1) = fl.flanker_id;
X(561:1120,1) = fl.flanker_id;
X(1:560,2) = num2cell(fl.group);
X(561:1120,2) = num2cell(fl.group);
X(1:560,3) = num2cell(fl.congruentRT);
X(561:1120,3) = num2cell(fl.incongruentRT);
X(1:560,4) = num2cell(fl.congruentAccuracy);
X(561:1120,4) = num2cell(fl.incongruentAccuracy);
X(1:560,5) = {'congruent'};
X(561:1120,5) = {'incongruent'};

ping = cell2table(X,'VariableNames',{'subject','group','RT','accuracy','condition'});

% Run the LME to predict RT and accuracy as a function of group and
% condition.

lm1 = fitlme(ping, 'RT ~ group * condition + (1 | subject)');
lm2 = fitlme(ping, 'accuracy ~ group * condition + (1 | subject)')

%% Next, we replicate findings from the PING data in the lab data
%% (small spacing)

load('flankerData.mat')

smallSpacing = d3(d3.spacing == 'unspaced',:)
largeSpacing = d3(d3.spacing == 'spaced',:)

% small spacing main effects
lm3 = fitlme(smallSpacing,'RT ~ group * condition + (1 | subject)')
lm4 = fitlme(smallSpacing,'condition_accuracy ~ group * condition + (1 | subject)')

%% We check for homogeneity  of variance and find that it does not 
%% differ between the groups for the PING data, nor the lab data. 

% For the PING data: 
fl = fl_PING_analysis; 

X1(:,1) = fl.flankerEffect;
X1(:,2) = fl.group;

% Check for homoscedasticity 
Levenetest(X1);

% For the Laboratory data: 

% Re-code group labels as 1 and 2 
for ii = 1:height(d4)
    if d4.group(ii) == 'dyslexic'
        d4.groupcode(ii) = 1;
    elseif d4.group(ii) == 'control'
        d4.groupcode(ii) = 2;
    end 
end 

% check for homoscedasticity for the unspaced 
X2(:,1) = d4.flanker_unspaced;
X2(:,2) = d4.groupcode;

Levenetest(X2);

%% We check for normality, and find that are distributions are non-gaussian
%% both for the PING data, and the lab data. 

% Check for normal distributions: they aren't normal for PING data:

controlPING = fl(fl.group == 2,:);
dysPING = fl(fl.group == 1,:);

[H, pValue, W] = swtest(controlPING.flankerEffect);
[H, pValue, W] = swtest(dysPING.flankerEffect);

% Or, the lab data: 

control = d4(d4.group == 'control',:);
dys = d4(d4.group == 'dyslexic',:)

[H, pValue, W] = swtest(control.flanker_unspaced);
[H, pValue, W] = swtest(dys.flanker_unspaced);

% SO, we need to do some non-parametric stats, AKA the Kruskall-Wallis. 

% first compare medians for the PING data
X(:,1) = controlPING.flankerEffect;
X(:,2) = NaN;
X(1:length(dysPING.flankerEffect),2) = dysPING.flankerEffect;

[p,anovatab,stats] = kruskalwallis(X)
etaSquared = anovatab{2,5}/(sum(stats.n)-1)

% and then for the small spacing condition
[p,anovatab,stats] = kruskalwallis([[control.flanker_unspaced;NaN],dys.flanker_unspaced]);
etaSquared = anovatab{2,5}/(sum(stats.n)-1)


% SPACING

% large spacing main effects
lm3 = fitlme(largeSpacing,'RT ~ group * condition + (1 | subject)')
lm4 = fitlme(largeSpacing,'condition_accuracy ~ group * condition + (1 | subject)')

[H, pValue, W] = swtest(control.flanker_spaced);
[H,pValue,w] = swtest(control.flankerSpacingEffect);

[H, pValue, W] = swtest(dys.flanker_spaced);
[H,pValue,w] = swtest(dys.flankerSpacingEffect);

[h,p,t,stats] = ttest2(dys.flankerSpacingEffect,control.flankerSpacingEffect)
d = computeCohen_d(control.flankerSpacingEffect,dys.flankerSpacingEffect)

% three way interaction
d5(d5.adhd_dx == 1,:) = []
d5.adhd_dx = removecats(d5.adhd_dx);

lm5 = fitlme(d5, 'flanker ~ spacing * group + (1 | subject)')
