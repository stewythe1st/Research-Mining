clear;
close all;

% Get files
path1 = './data/MDLs Small/';
path2 = './data/Abstracts/';
dir_info = dir(path2);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files';

for i=2:numel(files)
    load(strcat(path2,files(i)));
    numTopics = 20;
    lda = fitlda(bag,numTopics,'Verbose',0);
    lsa = fitlsa(bag,numTopics);
    save(strcat(path1,files(i)),'lda','lsa','numTopics');
end