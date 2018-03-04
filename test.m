clear; close all;

% Configurable Parameters
query = 'k+means';

% Setup
folder = dir(['pdfs/',query,'/*.pdf']);
rawDocuments(1:size(folder,1)) = tokenizedDocument;
procDocuments(1:size(folder,1)) = tokenizedDocument;

% Read in text from each PDF and preprocess it
for i=1:size(folder,1)
    text = extractFileText([folder(i).folder,'\',folder(i).name]);
    procDocuments(i) = preprocess(text);
    rawDocuments(i) = tokenizedDocument(text);
end

% Make into a bag of words
rawBag = bagOfWords(rawDocuments);
cleanBag = bagOfWords(procDocuments);
cleanBag = removeInfrequentWords(cleanBag,2);
[cleanBag,idx] = removeEmptyDocuments(cleanBag);
reduction = 1 - cleanBag.NumWords/rawBag.NumWords

% Show a word cloud, just for fun
figure
wordcloud(cleanBag);