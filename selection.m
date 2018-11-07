%选择操作
function seln=selection(cumsump)
%从种群中选择两个个体
for i=1:2
    r = rand;
    prand=cumsump-r;
    j=1;
    while prand(j)<0
        j=j+1;
    end
    seln(i)=j;
end