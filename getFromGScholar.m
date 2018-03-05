clear;

% Configurable parameters
articles = 50;
maxPages = 20;
searchterms = 'k means';

% Set up
searchterms = urlencode(searchterms);
pdfs = strings(articles,2);
k = 1;
page = 0;
if ~exist('pdfs', 'dir')
    mkdir('pdfs');
end
directory = join(['pdfs/',searchterms],'');
if ~exist(directory, 'dir')
     mkdir(directory);
end

% Cookie stuffz
cookie1 = matlab.net.http.Cookie('GSP','IN=7e6cc990821af63+d8a86af7aa9cc61b:LD=en:A=6qKj5w:CPTS=1520203338:LM=1520203338:S=hVWpKlmnVkesE2ii');
cookie2 = matlab.net.http.Cookie('NID','125=MtLp4THhyZfUWshnOHI2GNHuTBys_a-egHn3ypLVPZ5I0CtkxfeMdMqNBMSLrD8GfJvPJOjXn_G_D3tVhclVgTAEh1mgH6Do1pB1yKgkUmpU57JcaA57JsloaqWhhOhL1GLg9XCAwT33Fqxf2f3JRApjEd8RWkK7SobClpFfy8jgB94RWPsVTOJGwWQMoBM1iBhyjlQXg0dUgwyFlVtNtCoBx-e3h4eS8ixzArKI787V3T9GvororcZYYDIHY2Ymd-qa8jgstpQ-aFtezVQ');
request = matlab.net.http.RequestMessage;
request = request.addFields(matlab.net.http.field.CookieField([cookie1 cookie2]));

% Query each page of Google Scholar looking for PDFs until enough are found
while k <= articles && page <= maxPages
    
    % Get page of Google Schola search results
    url = join(['https://scholar.google.com/scholar', ...
                '?start=',num2str(page * 10), ...
                '&q=',searchterms ...
                ],'');
    response = request.send(url);
    searchText = char(response.Body.Data);
    
    % For each time ".pdf" appears in the results HTML...
    for i=strfind(searchText,'.pdf')
        j = i;
        
        % Find the name of the PDF and save it in column 1
        while searchText(j) ~= '/'
            j = j - 1;
        end
        pdfs(k,1) = string(searchText(j+1:i+3));
        pdfs(k,1) = regexprep(pdfs(k,1),':|&|?|=|?|;','');
        pdfs(k,1) = join([directory,'/',pdfs(k,1)],'');
        
        % Check to see if we've already saved a PDF by this name
        if any(strcmp(pdfs(k,1),pdfs(1:k-1,1)))
            continue
        end
        
        % Find the URL of the PDF and save it in column 2
        while searchText(j) ~= '"'
            j = j - 1;
        end
        pdfs(k,2) = string(searchText(j+1:i+3));
        
        % Try downloading the PDF
        try
            websave(pdfs(k,1), pdfs(k,2));
            temp = dir([char(pdfs(k,1)),'*']);
            temp = temp.name;
            if(endsWith(temp,'.html'))
                throw MException('','Downloaded file is not a PDF');
            end
            
        % If download failed, show a warning and delete the invalid file
        catch ME
            warning('Couldn''t fetch %s\n%s\n%s', ...
                    pdfs(k,1), pdfs(k,2), ME.message);
            delete([char(pdfs(k,1)),'*']);
            k = k - 1;
        end
        
        % Increment counter until we've reached the limit
        k = k + 1;
        if k > articles
            break;
        end
    end
    
    % Increment page counter and loop again
    page = page + 1;
end

% Warn if insufficient results found
if k < articles
    warning(['MaxPages reached before sufficient number of articles '...
    'found! Try running again with higher MaxPages value.']);
end

% Clean up
clearvars i j k page