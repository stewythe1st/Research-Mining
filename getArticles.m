clear;

% Load API key
load('data/private.mat');

% Initializations
records = 0;
articles = [];
total_records = records + 1;
dry_run = false;

% Query API and collect results
while records < total_records
    json = queryApi(apikey,...
                     'max_records=200',...
                     ['start_record=',num2str(records)],...
                     ['publication_title=',urlencode('Language Processing')]);
    if ~any(contains(fieldnames(json),'error_code'))
        total_records = json.total_records;
        articles = [articles;json.articles];
    end
    records = records + 200;
    if dry_run
        queries = ceil(total_records / 200);
        break;
    end
end

if ~dry_run
    save('data/Raw API Data/IEEELangProc.mat','articles');
end