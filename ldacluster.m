clear;
close all;

% Read in abstracts
load('data/IEEECommJournArticles.mat');
abstracts(1:size(articles)) = tokenizedDocument;
cnt = 1;
for i=1:numel(articles)
    % Filter out articles that don't have an abstract
    if any(string(fieldnames(articles{i})) == 'abstract')
        % Filter out any articles that have an html-based abstract
        if ~contains(articles{i}.abstract,'</div>')
            % Filter out any articles that have an empty abstract
            if numel(strsplit(articles{i}.abstract)) > 2
                abstracts(cnt) = preprocess(articles{i}.abstract);
                cnt = cnt + 1;
            end
        end
    end
end
abstracts = abstracts(:,1:cnt);
clear articles

% Make a bag of words
bag = bagOfWords(abstracts);
bag = removeInfrequentWords(bag,2);
[bag,idx] = removeEmptyDocuments(bag);

% % Select a subset for training to determine perplexity
% cvp = cvpartition(numel(abstracts),'HoldOut',0.1);
% abstractsTrain = abstracts(cvp.training);
% abstractsTest = abstracts(cvp.test);
% bag = bagOfWords(abstractsTrain);
% bag = removeInfrequentWords(bag,2);
% bag = removeEmptyDocuments(bag);

% % Find a target number of topics
% numTopicsRange = [10 20 40 80 160];
% parfor i = 1:numel(numTopicsRange)
%     mdl(i) = fitlda(bag,numTopicsRange(i),'Verbose',1);
%     [~,ppl(i)] = logp(mdl(i),abstractsTest');
% end

% Run an LSA model
numcomponents = 15;
mdl = fitlda(bag,numcomponents);

% Show wordclouds for each category
dim = ceil(sqrt(numcomponents));
figure
for i = 1:numcomponents
    subplot(dim,dim,i)
    wordcloud(mdl,i);
    title("Topic " + i)
end

% Show topic mixtures
figure
topicMixtures = transform(mdl,abstracts(1:numcomponents)');
barh(topicMixtures(1:numcomponents,:),'stacked')
xlim([0 1])
title("Topic Mixtures")
xlabel("Topic Probability")
ylabel("Document")