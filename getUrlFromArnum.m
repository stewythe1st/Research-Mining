function[link] = getUrlFromArnum(arnumber, libproxycookie)

% Build http request
request = matlab.net.http.RequestMessage;
request = request.addFields(matlab.net.http.field.CookieField(libproxycookie));

% Send request and read response
url = ['http://ieeexplore.ieee.org.libproxy.mst.edu/', ...
       'stamp/stamp.jsp?arnumber=', num2str(arnumber)];
response = request.send(url);
html = char(response.Body.Data);

% Check for invalid libproxy session
if(contains(html, 'Please enter your Missouri S&T Userid and Password.'))
    error('Invalid libproxy login. Please check the cookie paramters.');
end

% Extract out PDF link
linkIdx = strfind(html,'.pdf');
startIdx = find(html(1:linkIdx)=='"',1,'last');
endIdx = find(html(linkIdx:end)=='"',1,'first');
link = html(startIdx+1:linkIdx+endIdx-2);

end