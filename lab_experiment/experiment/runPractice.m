function runPractice(sub_num, trial)

mt_prepSounds; 
% Set number of runs 
nruns = 1;
%trial = int2str(trial);

% Preallocate a cell array to collect data. 

C = cell((nruns*12),5);

 
 % Perform standard setup for Psychtoolbox
PsychDefaultSetup(2);

% Define black, white, and gray
black = BlackIndex(0);
white = WhiteIndex(0);
gray = white / 2;


ListenChar(2);

% Open the window 
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'UseRetinaResolution');
[window, rect] = PsychImaging('OpenWindow', 0, gray);%, [0 0 1280 600]);
HideCursor;


% Get the center coordinates of the screen
[centerX, centerY] = RectCenter(rect);    
 
% Get the size of the screen window in pixels
[screenXpixels, screenYpixels] = Screen('WindowSize', window);

% % Disable all keys except for space bar, down arrow, right arrow, this
% might change computer to computer
% 
oldenablekeys = RestrictKeysForKbCheck([66,115,117]);



% Display instructions for the task
instructions = 'Press the arrow indicating the direction of the center arrow.\n Press space to begin.\n';
Screen('TextFont', window, 'Courier');
Screen('TextSize', window, 40);
DrawFormattedText(window, instructions, 'center','center', 0, [], [], [], 1.5);
Screen('Flip', window);
 
% Wait until user presses a key
[~, ~, ~] = KbWait([], 2); 

stim = {'>><>>', '<<><<', '> > < > >', '< < > < <', '>>>>>', '<<<<<', ...
    '> > > > >', '< < < < <', '++>++', '++<++', '+ + > + +', '+ + < + +'};

conditionMatrix = []; 

% Generate condition matrix in random order. 1-12 symbolizes each posisble stimuli, and
% nruns is how many instances of each stimuli we want. 

for ii = 1:nruns 
    conditionMatrix = [conditionMatrix randperm(12)];
end 


for ti = 1:length(conditionMatrix) 
    Screen('TextFont', window, 'Courier');
    Screen('TextSize', window, 80);
%     [normBoundsRect(1,:), ~]= Screen('TextBounds', window, '<')
%     [normBoundsRect(2,:), ~]= Screen('TextBounds', window, '>')
%     [normBoundsRect(3,:), ~]= Screen('TextBounds', window, '+')
    DrawFormattedText(window, stim{conditionMatrix(ti)}, 'center','center', 0, [], [], [], 1.5);
  % Save the time the screen was flipped
    stimulusStartTime = Screen('Flip', window);
    % Wait until user presses a key
    [~, ~, ~] = KbWait([], 2); 
    
    %save RT 
    [keyWasPressed, responseTime, key] = recordKeys(stimulusStartTime);
    %sprintf('%s', [responseTime key]) 
    % Collect data
    C(ti,1) = {ti}; %trial number 
    if conditionMatrix(ti) == 1 
        C(ti,2) = {'unspaced'};
        C(ti,3) = {'incongruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'DownArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end 
    elseif conditionMatrix(ti) == 2
        C(ti,2) = {'unspaced'};
        C(ti,3) = {'incongruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'RightArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 3
        C(ti,2) = {'spaced'};
        C(ti,3) = {'incongruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'DownArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 4
        C(ti,2) = {'spaced'};
        C(ti,3) = {'incongruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'RightArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 5
        C(ti,2) = {'unspaced'};
        C(ti,3) = {'congruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'RightArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 6
        C(ti,2) = {'unspaced'};
        C(ti,3) = {'congruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'DownArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 7
        C(ti,2) = {'spaced'};
        C(ti,3) = {'congruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'RightArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 8
        C(ti,2) = {'spaced'};
        C(ti,3) = {'congruent'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'DownArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 9
        C(ti,2) = {'unspaced'};
        C(ti,3) = {'neutral'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'RightArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 10
        C(ti,2) = {'unspaced'};
        C(ti,3) = {'neutral'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'DownArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 11
        C(ti,2) = {'spaced'};
        C(ti,3) = {'neutral'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'RightArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end
    elseif conditionMatrix(ti) == 12
        C(ti,2) = {'spaced'};
        C(ti,3) = {'neutral'};
        C(ti,4) = {responseTime};
        if strcmp(key, 'DownArrow')
            C(ti,5) = {1};
        else C(ti,5) = {0};
        end 
    end
    
    correct = C{ti,5};
    if correct == 1
        PsychPortAudio('Start', 0, 1, 0, 1); % play sound
        Screen('DrawDots', window, [centerX, centerY], 20, [0 1 0], [],[]);
        Screen('Flip', window);
        WaitSecs(1);
    else 
        PsychPortAudio('Start', 2, 1, 0, 1); % play sound
        Screen('DrawDots', window, [centerX, centerY], 20, [1 0 0], [],[]);
        Screen('Flip', window);
        WaitSecs(1);
    end 
end 

T = cell2table(C, 'VariableNames', {'Trial', 'Spacing', 'Congruent', 'RT',...
    'Accuracy'});
    
% Name file using sub_num  & write  table 
trial_str = int2str(trial);
file_name = strcat(sub_num,'-',datestr(now, 'yyyymmdd-HHMM'),'-practice',trial_str,'.txt');

%move to data file and write table
h = pwd;
cd data 
writetable (T, file_name); 
cd(h)
%% close out

finished = 'Press space to continue.';
Screen('TextFont', window, 'Courier');
Screen('TextSize', window, 40); 
DrawFormattedText(window, finished, 'center', 'center', 0);
Screen('Flip', window);

KbWait;
sca;
Screen('close')
ListenChar(0);


    