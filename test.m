clear; close all;

% Configurable Parameters
query = 'k+means';

% Setup
folder = dir(['pdfs/',query,'/*.pdf']);
rawDocuments(1:numel(folder)) = tokenizedDocument;
rawDocuments = rawDocuments';
procDocuments(1:numel(folder)) = tokenizedDocument;
procDocuments = procDocuments';

% Read in text from each PDF and preprocess it
parfor i=1:numel(folder)
    text = extractFileText([folder(i).folder,'\',folder(i).name]);
    procDocuments(i) = preprocess(text);
    rawDocuments(i) = tokenizedDocument(text);
end
poolobj = gcp('nocreate');
delete(poolobj);

% Make into a bag of words
rawBag = bagOfWords(rawDocuments);
cleanBag = bagOfWords(procDocuments);
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);
reduction = 1 - cleanBag.NumWords/rawBag.NumWords;

% Show a word cloud, just for fun
% figure
% wordcloud(cleanBag);

numTopicsRange = [5 10 15 20 25];
ppl(1:numel(numTopicsRange)) = double(0);
parfor i = 1:numel(numTopicsRange)
    numTopics = numTopicsRange(i);
    mdl(i) = fitlda(cleanBag,numTopics,'Verbose',0);
    [~,ppl(i)] = logp(mdl(i),procDocuments);
end
poolobj = gcp('nocreate');
delete(poolobj);


figure
topicMixtures = transform(mdl(4),procDocuments(1:10));
barh(topicMixtures(1:10,:),'stacked')
xlim([0 1])
title("Topic Mixtures")
xlabel("Topic Probability")
ylabel("Document")