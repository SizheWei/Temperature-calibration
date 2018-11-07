function scro=crossover(population,seln,pc)
global Bitlength
pcc=IfCroIfMut(pc);   %根据交叉概率决定是否进行交叉操作，1为是
if pcc==1
    %在[1,Bitlength-1]中随机产生一个交叉位
    chb=round(rand*(Bitlength-2))+1;
    scro(1,:)=[population(seln(1),1:chb) population(seln(2),chb+1:Bitlength)];
    scro(2,:)=[population(seln(2),1:chb) population(seln(1),chb+1:Bitlength)];
else
    scro(1,:)=population(seln(1),:);
    scro(2,:)=population(seln(2),:);
end