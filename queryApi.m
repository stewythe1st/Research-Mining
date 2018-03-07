function [json] = queryApi(apiKey, varargin)

% Build URL
url = 'http://ieeexploreapi.ieee.org/api/v1/search/articles?parameter';
url = [url,'&apikey=',apiKey];
for i=1:numel(varargin)
    url = [url,'&',varargin{i}];
end

% Make HTTP request
request = matlab.net.http.RequestMessage;
response = request.send(url);
json = response.Body.Data;

end