clear;
close all;

% Get files
path1 = './data/MDLs/';
path2 = './data/Abstracts/';
dir_info = dir(path1);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files(~contains(files,'.png'));
files = files';

for i=1:1%numel(files)
    load(strcat(path1,files(i)));
    load(strcat(path2,files(i)));
    lda = fitlda(bag,numTopics,'Verbose',0);
    lsa = fitlsa(bag,numTopics);
    save(strcat(path1,files(i)),'mdl','lda','lsa','numTopics','numTopicsRange','ppl');
end