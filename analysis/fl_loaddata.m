function [d3 d4 d5] = fl_loaddata(meas, agerange, filterby, val)
% Load flanker data
%
% [d3 d4] = fl_loaddata(meas, agerange)
%
% Inputs
%
% meas     - 'mean' or 'median'. Default to 'median'
% agerange - [min_age max_age]. default to [0 100]
% filterby - remove subjects who do not meet a certain criteria on the
%            variable 'filterby' that is in the table. filterby can either
%            be a string or a cell array of strings.
% val      - The value to filterby. If 1 value is give then only subjects
%            where 'filterby' is equal to val will be retained. If two
%            values are give then subjects within the range will be
%            retained. val can either be a single val, a range or a cell
%            array of vals/ranges.
%
% Output
%
% d3 - longform dataframe
% d4 - wideform dataframe
%% Set parameters
if ~exist('meas', 'var') || isempty(meas)
    meas = 'median';
end

if ~exist('agerange', 'var') || isempty(agerange)
    agerange = [0 100]; % age range in years
end

agerange = agerange.*12; % convert age to months

% Make filterby a cell
if exist('filterby', 'var') && ~isempty(filterby) && ~iscell(filterby)
   tmp{1} = filterby;
   filterby = tmp;
   tmp{1} = val;
   val = tmp;
elseif ~exist('filterby', 'var') || isempty(filterby)
    filterby={};
end

%% Load data
if strcmp(meas,'mean')
    load flankerData_mean.mat
elseif strcmp(meas,'median')
    load flankerData_median.mat
end

% Filter based on age range
d4 = d4(d4.visit_age > agerange(1) & d4.visit_age < agerange(2),:);
d3 = d3(d3.visit_age > agerange(1) & d3.visit_age < agerange(2),:);
d5 = d5(d5.visit_age > agerange(1) & d5.visit_age < agerange(2),:);


% If another filteby variable is define then only retain subjects with
% filterby=val
for ii = 1:length(filterby)
    if length(val{ii})==1
        d3(d3.(filterby{ii}) ~= val{ii},:) = []; % single val case
        d4(d4.(filterby{ii}) ~= val{ii},:) = []; % single val case
        d5(d5.(filterby{ii}) ~= val{ii},:) = []; % single val case
    elseif length(val{ii})==2
        d3(d3.(filterby{ii}) < val{ii}(1) | d3.(filterby{ii}) > val{ii}(2),:) = []; % range
        d4(d4.(filterby{ii}) < val{ii}(1) | d4.(filterby{ii}) > val{ii}(2),:) = []; % range
        d5(d5.(filterby{ii}) < val{ii}(1) | d5.(filterby{ii}) > val{ii}(2),:) = []; % range
    end
end
