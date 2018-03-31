clear;
close all;

% Input
range = 21:30;
name = 'PPLIEEETrans';

% Get files
path = './data/MDLs/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files(~contains(files,'.png'));
files = files';

fig = figure;
% set(fig,'Visible','off');
xlim([0,175]);
ylim([400,1250]);
xlabel('Number of Topics')
ylabel('Perplexity')
title('Perplexity per Data Set')
hold all;

for i=range
    load(strcat(path,files(i)));
    plot(numTopics,ppl)
    clear mld ppl numTopics
end

legend(files(range),'location','eastoutside')

fig.PaperPositionMode = 'auto';
print(strcat('data/Final/',name),'-dpng','-r0')