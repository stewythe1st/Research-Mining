function [documents] = preprocess(textData)

% Erase URLs, punctuation and numbers
cleanTextData = eraseURLs(textData);
cleanTextData = regexprep(cleanTextData,'\d','');
cleanTextData = erasePunctuation(cleanTextData);

% Convert the text data to lowercase.
cleanTextData = lower(cleanTextData);

% Tokenize the text.
documents = tokenizedDocument(cleanTextData);

% Remove a list of stop words.
documents = removeWords(documents,stopWords);

% Remove words with 2 or fewer characters, and words with 15 or greater
% characters.
documents = removeShortWords(documents,2);
documents = removeLongWords(documents,15);

% Normalize the words using the Porter stemmer.
documents = normalizeWords(documents);

end