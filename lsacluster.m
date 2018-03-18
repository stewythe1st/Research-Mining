clear;
close all;

% Read in abstracts
load('SoftEngJournArticles.mat');
abstracts(1:size(articles)) = tokenizedDocument;
for i=1:numel(articles)
    if any(string(fieldnames(articles{i})) == 'abstract')
        if numel(strsplit(articles{i}.abstract)) > 2
            abstracts(i) = preprocess(articles{i}.abstract);
        end
    end
end
clear articles;

% Make a bag of words
abstracts = removeEmptyDocuments(abstracts);
bag = bagOfWords(abstracts);
bag = removeInfrequentWords(bag,2);
[bag,idx] = removeEmptyDocuments(bag);

% Run an LSA model
numcomponents = 15;
mdl = fitlsa(bag,numcomponents);

% Show wordclouds for each category
figure;
dim = ceil(sqrt(numcomponents));
for i=1:numcomponents
    subplot(dim,dim,i);
    [temp,idx] = sort(mdl.DocumentScores(:,i),'descend');
    bagtemp = bagOfWords(abstracts(idx(1:12)));
    wordcloud(bagtemp);
    title("Topic " + i)
end

% Show a radar plot for 
figure;
data = mdl.DocumentScores(1:10,:);
labels = strcat('Topic',{' '},string(1:numcomponents));
spider_plot(data,labels,10,1,'LineWidth',2);