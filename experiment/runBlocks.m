
PsychJavaTrouble

%% Clear screen and workspace
sca;
close all;
clearvars;
% 
% % Save current directory
 h = pwd;


fprintf('Welcome!\n\n\n');

subjectName = input('What is your name? ','s');
fprintf('\n');
subjectIni = input('What is your subject ID? ','s');
fprintf('\n');

fprintf('\n');
fprintf('Thank you!\n');
fprintf('\n');
fprintf('\n');

doPractice = 1;
trial = 1;

while doPractice
    if trial == 1
        aaa = input('Do you want to practice (y/n) ? ','s');
    else
        aaa = input('Do you want to practice more (y/n) ? ','s');
    end
    if strcmp(aaa, 'y')
        runPractice(subjectIni,trial);
        clc;
    else
        doPractice = 0;
        clc;
    end
    trial = trial + 1;
end

doRunMain = 1;
trial = 1;

while doRunMain
    if trial == 1 
        aaa = input('Do you want to run the main task (y/n) ? ','s');
    else
        aaa = input('Do you want to run the main task again (y/n) ? ','s');
    end
    if strcmp(aaa, 'y')
        runFlanker(subjectIni,trial);
        clc;
    else
        doRunMain = 0;
    end
    trial = trial + 1;
end