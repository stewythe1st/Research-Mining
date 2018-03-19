clear;

% Load API key
load('data/private.mat');

% Initializations
records = 2000;
articles = [];
total_records = records + 1;

% Query API and collect results
while records < total_records
    json = queryApi(apikey,...
                     'max_records=200',...
                     ['start_record=',num2str(records)],...
                     ['publication_title=',urlencode('IEEE Communications Magazine')]);
    if ~any(contains(fieldnames(json),'error_code'))
        total_records = json.total_records;
        articles = [articles;json.articles];
    end
    records = records + 200;
end

save('data/IEEECommJournArticles.mat','articles');