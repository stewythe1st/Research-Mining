function [json] = queryApi(apiKey, varargin)

% Build URL
url = 'http://ieeexploreapi.ieee.org/api/v1/search/articles?parameter';
url = [url,'&apikey=',apiKey];
for i=1:numel(varargin)
    url = [url,'&',varargin{i}];
end

% Make HTTP request
options = matlab.net.http.HTTPOptions('ConnectTimeout',30);
request = matlab.net.http.RequestMessage;
response = request.send(url,options);
json = response.Body.Data;

end