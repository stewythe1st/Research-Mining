clear;
close all;

% Get files
path = './data/Abstracts/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);

% Loop through each file of articles
for i=1:numel(files)
    load(strcat(path,files(i)));
    
    % Run LDAs with varying numTopics
    numTopics = [10,20,40,80,120,160];
    parfor j = 1:numel(numTopics)
        mdl(j) = fitlda(bag,numTopics(j),'Verbose',0);
        [~,ppl(j)] = logp(mdl(j),abstracts');
    end
    
    % Plot perplexity graph
    fig = figure;
    set(fig,'Visible','off');
    plot(numTopics,ppl)
    xlabel('Number of Topics')
    ylabel('Perplexity')
    title(files(i))
    
    % Save image
    fig.PaperPositionMode = 'auto';
    print(strcat('data/MDLs/',erase(files(i),'.mat')),'-dpng','-r0')
    
    % Save data
    save(strcat('data/MDLs/',files(i)),'mdl','ppl','numTopics');
    clear mld ppl numTopics abstracts bag
end