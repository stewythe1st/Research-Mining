clear;

% Load API key
load('private.mat');

% Initializations
records = 1;
articles = [];
total_records = records + 1;

% Query API and collect results
while records < total_records
    json = queryApi(apikey,...
                     'max_records=200',...
                     ['start_record=',num2str(records)],...
                     ['publication_title=',urlencode('IEEE Transactions on Software Engineering')]);
    total_records = json.total_records;
    records = records + 200;
    articles = [articles;json.articles];
end

save('SoftEngJournArticles.mat','articles');