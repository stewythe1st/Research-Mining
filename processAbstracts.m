clear;
close all;

% Get files
path = './data/Articles/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);

% Loop through each file of articles
for i=1:numel(files)
    load(strcat(path,files(i)));
    
    % Extract abstract from each and turn into a tokenized document
    abstracts(1:size(articles)) = tokenizedDocument;
    cnt = 1;
    for j=1:numel(articles)
        % Filter out articles that don't have an abstract
        % Filter out any articles that have an html-based abstract ...
        % Filter out any articles that have an empty abstract
        if any(string(fieldnames(articles{j})) == 'abstract') && ...
           ~contains(articles{j}.abstract,'</div>') && ...
           numel(strsplit(articles{j}.abstract)) > 2
            try
                abstracts(cnt) = preprocess(articles{j}.abstract);
                cnt = cnt + 1;
            % If it still fails, move on and throw the error as a warning
            catch ME
                %disp(getReport(ME,'extended','hyperlinks','on'));
            end
        end
    end
    abstracts = abstracts(:,1:cnt);
    
    % Make a bag of words
    bag = bagOfWords(abstracts);
    bag = removeInfrequentWords(bag,2);
    [bag,~] = removeEmptyDocuments(bag);
    
    % Save data
    save(strcat('data/Abstracts/',files(i)),'abstracts','bag');
    clear articles abstracts
end