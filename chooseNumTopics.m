clear;
close all;

% Get files
path = './data/MDLs/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files';

for i=1:numel(files)
    if contains(files(i),'.png')
        close all;
        imshow(char(strcat('data/MDLs/',files(i))))
        numTopicsRange = numTopics;
        numTopics = input(char(strcat('NumTopics for ',files(i),': ')));
        save(strcat('data/MDLs/',filename),'mdl','numTopics','numTopicsRange','ppl');
    else
        load(strcat(path,files(i)));
        filename = files(i);
    end
end