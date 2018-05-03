clear
close all

% Get files
path = './data/Abstracts/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files';
cnt = [];

for i=1:numel(files)
    load(strcat(path,files(i)));
    cnt(i) = numel(abstracts);
end

% Draw chart
figure
bar(ppl);
set(gca,'XTickLabel',string(files));
set(gca,'XTick',1:numel(files));
xtickangle(45);