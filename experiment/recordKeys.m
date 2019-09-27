function [keyWasPressed, responseTime, key] = recordKeys(startTime)%, duration)
% Return if a key was pressed and the fastest response time.

keyWasPressed = false;
responseTime = NaN;
key = '';
%start = GetSecs;

% Check for pressed keys while the stimulus is still displaying
[keyIsDown, ~, keyCode] = KbCheck;
if keyIsDown
    keyWasPressed = true;
    key = KbName(keyCode);
    responseTime = [responseTime GetSecs-startTime];
end 

responseTime = min(responseTime);

end