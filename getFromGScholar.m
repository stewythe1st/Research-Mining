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
dir = join(['pdfs/',searchterms],'');
if ~exist(dir, 'dir')
     mkdir(dir);
end

% Cookie stuff
cookie1 = matlab.net.http.Cookie('GSP','A=6qKj5w:CPTS=1520124685:LM=1520124685:S=buUR1ahVyKEgMR2G');
cookie2 = matlab.net.http.Cookie('NID','125=iSO-4VkA3rF1B_zLnWokM6p-H-SZgqOG4v-seYM8dHVkyi3r4LUbLdj6MYCM6k6gTJ2gS3-UEvSpvMB_9hSiJGWkmtm7k68v_xuORfxysy8UlUpnMnDcSZBG0RWdGFCZDh3k7mCTPa32F7D1YVPLcwvDchGA5I-97WqjjTtDMKjTfstnx9HHt_o1lNfo_mJoUuGfS8Jsviz0JehiGYFZlCIOqQLTjKQuaqPoBTKepFbsIFepoyDmt_jP89tv5MyYgZTwQXZ1kbLBzT3ELfM');
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
        pdfs(k,1) = join([dir,'/',pdfs(k,1)],'');
        
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