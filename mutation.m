%新种群变异操作
function smnew=mutation(snew,pmutation)
global Bitlength
smnew=snew;
pmm=IfCroIfMut(pmutation);  %根据变异概率决定是否进行变异操作，1为是
if pmm==1
    %在[1,Bitlength-1]中随机产生一个变异位
    chb=round(rand*(Bitlength-1))+1;
    smnew(chb)=abs(snew(chb)-1);
end