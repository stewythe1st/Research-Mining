clear journals x; 
journals = [];
for i=1:numel(articles)
    j = extractfield(articles{i},'publication_title');
    journals = [journals,string(j)];
end
x(:,1) = unique(journals);
for i = 1:size(x,1)
    x(i,2) = numel(find(journals==x(i,1)));
end
x