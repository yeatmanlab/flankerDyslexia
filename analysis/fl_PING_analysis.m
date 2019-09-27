% code for analyzing PING data
function fl = fl_PING_analysis
cd ~/git/flanker/data/PING

T = readtable('flanker01.txt');

% reconfigure data

tmp(:,1) = T.flanker01_id(2:end);
tmp(:,2) = T.subjectkey(2:end);
tmp(:,3) = num2cell(str2double(T.interview_age(2:end))); 
tmp(:,4) = num2cell(str2double(T.tbx_arrowscon_rt(2:end)));
tmp(:,5) = num2cell(str2double(T.tbx_arrowsincon_rt(2:end)));
tmp(:,6) = num2cell(str2double(T.tbx_flkr_arwcon_p(2:end)));
tmp(:,7) = num2cell(str2double(T.tbx_flkr_arwincon_p(2:end)));
tmp(:,8) = num2cell(str2double(T.tbx_attention_score(2:end)));
tmp(:,9) = num2cell(str2double(T.nih_flanker_computed(2:end)));


T2 = readtable('orrt01.txt');

tmp2(:,1) = T2.orrt01_id(2:end);
tmp2(:,2) = T2.subjectkey(2:end);
tmp2(:,3) = num2cell(str2double(T2.interview_age(2:end)));
tmp2(:,4) = num2cell(str2double(T2.tbx_reading_score(2:end)));

or = cell2table(tmp2,'VariableNames',{'or_id','subjectkey','age','readingScore'})

% read in vocab scores 
T3 = readtable('tpvt01.txt');
tmp3(:,1) = T3.subjectkey(2:end);
tmp3(:,2) = num2cell(str2double(T3.tbx_vocab_theta(2:end)));

vocab = cell2table(tmp3, 'VariableNames',{'subjectkey','vocab'});

% combine flanker and reading score into one matrix

for ii = 1:length(tmp)
    subnum = tmp(ii,2);
    tmp(ii,10) = table2cell(or(strcmp(or.subjectkey,subnum),4));
    tmp(ii,11) = table2cell(vocab(strcmp(vocab.subjectkey,subnum),2));
end 


fl = cell2table(tmp,'VariableNames',{'flanker_id','subjectkey','age','congruentRT','incongruentRT',...
   'congruentAccuracy','incongruentAccuracy','attention_score','nih_flanker_score','readingScore', 'vocab'});

fl(isnan(fl.congruentRT),:) = []; fl(isnan(fl.incongruentRT),:) = []; 
fl(isnan(fl.incongruentAccuracy),:) = []; fl(isnan(fl.congruentAccuracy),:) = [];
fl(isnan(fl.readingScore),:) = [];

% get only our age range: 7-13
fl(fl.age < 84,:) = [];
fl(fl.age > 156,:) = [];

% exclude low IQ
meanIQ = nanmean(fl.vocab);
stdvocab = nanstd(fl.vocab*2);
IQcutoff = meanIQ - stdvocab;

fl(fl.vocab < IQcutoff,:) = [];

fl.flankerEffect = fl.incongruentRT - fl.congruentRT;

% 
mdl = fitlme(fl,'readingScore ~ age');
SS = mdl.Residuals.Raw;
ReadingZscore = zscore(SS);


% 
fl.SS = ReadingZscore;
[r,p] = corr(fl.flankerEffect,fl.SS,'Type','Spearman')


for ii = 1:height(fl)
    if fl.SS(ii) < -1
        fl.group(ii) = 1;
    elseif fl.SS(ii) >= -1
        fl.group(ii) = 2;
    end 
end 

dys = fl(fl.SS < -1,:);
control = fl(fl.SS >= -1,:);

[h,p,ci,stats] = ttest2(dys.flankerEffect,control.flankerEffect)
% 
