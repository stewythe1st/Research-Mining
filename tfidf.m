clear;
close all;

% Input
range = 1;
term = 'cluster';
k = 20;

% Get files
path = './data/Abstracts/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files';

for i=range
    load(strcat(path,files(i)));
    [~,idx] = find(bag.Vocabulary == term);
    tfidfMatrix = tfidf(bag,'TFWeight','log','IDFWeight','smooth');
    [sorted,sortedidx] = sort(tfidfMatrix(:,idx),'descend');
    figure
    bar(sorted(1:k))
    xtickangle(45)
    set(gca,'Xtick',1:k)
    set(gca,'XTickLabel',string(sortedidx(1:k)))
    xlabel('Document')
    ylabel('TFIDF')
    title(strcat('TFIDF of','{ }','"',term,'"'))
end