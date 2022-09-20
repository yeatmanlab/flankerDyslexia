function new = fl_GetThreshold_Kids
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Analysis: Crowding
% Load reading scores and get crowding thresholds
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
meas = 2
if meas == 1 
    load flankerData_mean.mat
elseif meas == 2
    load flankerData_median.mat
end 
oldID = d4.sub;

parentDir = '~/git/psychophys/crowding';
analDir = 'Analysis';
dataDir = 'Data';

%% Extract staircases and calculate the average threshold
% Ovals
cd(fullfile(parentDir,dataDir));

for iSubject = 1: length(oldID)
    thresh.name{iSubject} = oldID(iSubject);
    thresh.quest{iSubject} = [];
    thresh.sd{iSubject} = [];
    thresh.eccen{iSubject} = [];
    
    d = dir(sprintf('%s-2*',oldID(iSubject)));

    for j = 1: min(6,length(d))
        if ~isempty(load(d(j).name))
            load(d(j).name);
            if length(config.eccen) == 1
                cd(sprintf('%s/%s',parentDir,analDir));

                [t(1), sd2(1), betaEstimate(1), betaSd(1)] = QuestBetaAnalysis_Joo(result.q(1));
                [t(2), sd2(2), betaEstimate(2), betaSd(2)] = QuestBetaAnalysis_Joo(result.q(2));

                thresh.quest{iSubject} = [thresh.quest{iSubject} 10^t(1) 10^t(2)];
                thresh.sd{iSubject} = [thresh.sd{iSubject} 10^sd2(1) 10^sd2(2)];
                thresh.eccen{iSubject} = [thresh.eccen{iSubject} config.eccen config.eccen];

                cd(sprintf('%s/%s',parentDir,dataDir));
            end
        end
    end

    thresh.quest{iSubject}(thresh.quest{iSubject} > 5.5) = NaN;
%     thresh.quest{iSubject}(thresh.quest{iSubject} < .5) = NaN;
    thresh.nStairs(iSubject,1) = sum(~isnan(thresh.quest{iSubject}(thresh.eccen{iSubject}==6)));
end
%     if sum(isnan(thresh.quest{iSubject}(thresh.eccen{iSubject}==10))) / ...
%             sum(thresh.eccen{iSubject}==10) > .5
%         badS(iSubject) = 1;
%     end


for iSubject = 1: length(oldID)
    if thresh.nStairs(iSubject) < 6
        d4.crowdingThresh(iSubject) = NaN;
    else
        d4.crowdingThresh(iSubject) = nanmean(thresh.quest{iSubject});
    end
end 


new = d4(~isnan(d4.crowdingThresh),:);
new(new.sub == 'GB310',:) = [];
new(new.sub == 'HB275',:) = [];
new(new.sub == 'IB357',:) = [];

control = new(new.towre >= 85,:);
dys = new(new.towre < 85,:);
color = summer;

controlColor = color(10,:);
dysColor = color(35,:);

% crowdingThresholds = getCrowdingKids;
% controlFullSample = crowdingThresholds(crowdingThresholds.towre_index >= 85,:);
% dysFullSample = crowdingThresholds(crowdingThresholds.towre_index < 85,:);

figure
subplot(1,2,1)
% hold on;
% scatter(controlFullSample.towre_index,controlFullSample.crowdingThresh,70,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',controlColor,'LineWidth',2);
% scatter(dysFullSample.towre_index,dysFullSample.crowdingThresh,70,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',dysColor,'LineWidth',2);
% ylabel('crowding threshold')
% xlabel('TOWRE Index')
% [r,p] = corr(crowdingThresholds.towre_index,crowdingThresholds.crowdingThresh,'Type','Spearman');
% fit1 = polyfit(crowdingThresholds.towre_index,crowdingThresholds.crowdingThresh,1);
% ax = gca;
% ax.XLim = [50 140]
% ax.YLim = [.5 4]
% y_fit = polyval(fit1,ax.XLim)
% plot(xlim,y_fit,'k')
% text(100,3.25,sprintf('r = %.3f, p = %.3f',r,p));
% axis square
% hold off;
hold on;
scatter(control.flanker_unspaced*1000,control.crowdingThresh,70,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',controlColor,'LineWidth',2);
scatter(dys.flanker_unspaced*1000,dys.crowdingThresh,70,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',dysColor,'LineWidth',2);
ylabel('crowding threshold')
xlabel('Flanker Effect')
[r,p] = corr(new.flanker_unspaced*1000,new.crowdingThresh,'Type','Spearman');
fit1 = polyfit(new.flanker_unspaced*1000,new.crowdingThresh,1);
ax = gca;
ax.XLim = [-500 1800]

y_fit = polyval(fit1,ax.XLim)
plot(xlim,y_fit,'k')
text(1500,3.25,sprintf('r = %.3f, p = %.3f',r,p));
axis square
hold off;

subplot(1,2,2)
hold on;
scatter(control.flankerSpacingEffect*1000,control.crowdingThresh,70,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',controlColor,'LineWidth',2);
scatter(dys.flankerSpacingEffect*1000,dys.crowdingThresh,70,'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',dysColor,'LineWidth',2);
ylabel('crowding threshold')
xlabel('Flanker Spacing Effect')
[r,p] = corr(new.flankerSpacingEffect*1000,new.crowdingThresh,'Type','Spearman');
fit1 = polyfit(new.flankerSpacingEffect*1000,new.crowdingThresh,1);
ax = gca;
ax.XLim = [-200 500]
ax.YLim = [1 3.5]
y_fit = polyval(fit1,ax.XLim)
plot(xlim,y_fit,'k')
text(100,3.25,sprintf('r = %.3f, p = %.3f',r,p));
axis square
hold off;

% cd /home/ekubota/git/flanker/analysis
% if meas == 1 
%     save('flankerData_mean.mat','d','d2','d3','d4','d5')
% elseif meas == 2
%     save('flankerData_median.mat','d','d2','d3','d4','d5')
% end 

 
