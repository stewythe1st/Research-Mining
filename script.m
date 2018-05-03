clear
close all

path = './data/Abstracts/';
dir_info = dir(path);
files = {dir_info.name};
files = files(3:end);
files = string(files);
files = files';

load('data/MDLS Small/ppl.mat')

scatter(cnt,ppl)
xlabel('Number of Documents')
ylabel('Perplexity')
set(gca, 'Ydir', 'reverse')

dx = 0.012;
dy = -0.012;

dx = dx*max(cnt);
dy = dy*max(ppl);

for i=1:numel(cnt)
   text(cnt(i)+dx,ppl(i)+dy,files(i),'fontsize',6)
end