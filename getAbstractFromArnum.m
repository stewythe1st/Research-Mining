function[abstractText] = getAbstractFromArnum(arnumber, libproxycookie)

% Build http request
request = matlab.net.http.RequestMessage;
request = request.addFields(matlab.net.http.field.CookieField(libproxycookie));

% Send request and read response
url = ['http://ieeexplore.ieee.org.libproxy.mst.edu/', ...
       'xpl/articleDetails.jsp?arnumber=', num2str(arnumber)];
response = request.send(url);
html = char(response.Body.Data);

% Check for invalid libproxy session
if(contains(html, 'Please enter your Missouri S&T Userid and Password.'))
    error('Invalid libproxy login. Please check the cookie paramters.');
end

% Extract out abstract text
startIdx = strfind(html,'abstract');
endIdx = strfind(html, 'isJournal');
abstractText = html(startIdx+11:endIdx-4);

end