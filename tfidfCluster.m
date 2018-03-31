clear;
close all;

% Input
range = 1;
term1 = 'cluster';
term2 = 'languag';
k = 20;

% Get files
path = './data/Abstracts/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);gi
files = files';

for i=range
    load(strcat(path,files(i)))
    [~,termidx1] = find(bag.Vocabulary == term1);
    [~,termidx2] = find(bag.Vocabulary == term2);
    tfidfMatrix = tfidf(bag,'TFWeight','log','IDFWeight','smooth');
    termlist1 = tfidfMatrix(:,termidx1);
    termlist2 = tfidfMatrix(:,termidx2);
    figure
    scatter(termlist1,termlist2)
    xlabel(strcat('TFIDF of "',term1,'"'))
    ylabel(strcat('TFIDF of "',term2,'"'))
    cnt = 1;
end