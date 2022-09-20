 [d3 d4 d5] = fl_loaddata('median',[],[],[])

controlColor = [118/255 160/255 138/255];
dysColor = [46/255 96/255 74/255];

figure; 
subplot(2,3,1)
accLineplot_PING(controlColor,dysColor)
axis square

subplot(2,3,2)
RTLineplot_PING(controlColor,dysColor)
axis square 

subplot(2,3,3)
fl_PINGbarGraph(controlColor,dysColor)
axis square

subplot(2,3,4)
accLineplot_noNeutral(d3,controlColor,dysColor)
axis square

subplot(2,3,5)
RTlinePlot_noNeutral(d3,controlColor,dysColor)
axis square

subplot(2,3,6)
flankerBarGraph(d4,controlColor,dysColor)
axis square

% lme1 = fitlme(d3,'RT ~ condition * spacing * group + (1 | subject)')
% % 
% % 
% % % flanker spaced vs. unspaced - age is significant in both models, only
% % % unspaced is significant. 
% lme1 = fitlme(d4,'flanker_spaced ~ group + visit_age')
% lme2 = fitlme(d4,'flanker_unspaced ~ group + visit_age')
% 
% % Test if dyslexics are younger/older than controls in our sample (it's
% % not). This goes in the methods section - dyslexic and control subjects
% % were matched for age
% lm = fitlm(d4,'visit_age ~ group')
% lm1 = fitlm(d4,'flanker_spaced ~ wj_brs')
% 
% % Test the group by spacing interaction controling for age (even though we
% % technically don't need to control for age since it doesnt' differ by
% % group)
% lme4a = fitlme(d5,'flanker ~ spacing * group + visit_age + (1 | subject)')
% lme4b = fitlme(d5,'flanker ~ spacing * group + (1 | subject)')
% % Since dyslexia is often comorbid with adhd and it is already known that
% % adhd is associated with poor flanker performance, we re-rant our model
% % covarying for adhd diagnosis. We confirmed that subjects with adhd do
% % show increased flanker effects. But, even controling for adhd diagnosis,
% % dyslexics also still have significantly higher flanker effect and show a
% % significant interaction with spacing.
% lme4c = fitlme(d5,'flanker ~ spacing * group + visit_age + wasi_fs2 + adhd_dx + (1 | subject)'); %consider adding the adhd subplot figures as supplimentary
% 
% % We can also calculate this same effect as a between subjects by first
% % calculating spacing effect for each subject. Results are very similar as
% % above
% lme3 = fitlme(d4,'flankerSpacingEffect ~ group  + visit_age')
% 
% % Now let's test both models with ADHD
% lme4b_2 = fitlme(d5,'flanker ~ spacing * group * adhd_dx + (1 | subject)')
% lme3_2 = fitlme(d4,'flankerSpacingEffect ~ group * adhd_dx + visit_age')
% 
% 
% 
% lme3_2 = fitlme(d4,'flankerSpacingEffect ~ towre + ctopp_pa')
% 
% % % % 
% % % % % group effect, but less strong towre effect.
% % lme1 = fitlme(d4,'flankerSpacingEffect ~ towre + visit_age')
% %  lme2 = fitlme(d4,'flankerSpacingEffect ~ group + visit_age')
% % % 
% % % 
% % % 
% % % % when we add ADHD to the model, only the interaction is significant 
% %  lme3 = fitlme(d4,'flankerSpacingEffect ~ towre * adhd_dx + visit_age')
% % lme4 = fitlme(d4,'flankerSpacingEffect ~ adhd_dx * group + visit_age')
% % % 
% % % remove ADHD subs from the model, still significant group effect
% % lme5 = fitlme(d4(d4.adhd_dx == 0,:),'flankerSpacingEffect ~ group + visit_age')
% % 
% % % lme5 = fitlme(d4,'towre ~ crowdingThresh + visit_age')
% % lme6 = fitlme(d4,'towre ~ flankerSpacingEffect + visit_age')