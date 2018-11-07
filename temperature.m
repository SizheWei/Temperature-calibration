tic
global Bitlength
global truetablelist
global costofmea %测量一个的成本
global popsize
Bitlength=90; %编码长度
%直接读入文件
truetablelist=csvread('dataform20160902.csv');
popsize=150; %初始种群的大小
costofmea=50;%测量一个温度值的成本为50
Generationmax=2;    %最大代数
pcrossover=0.95;     %交配概率
pmutation=0.05;      %变异概率
%产生初始种群
population=round(rand(popsize,Bitlength)-0.2);
%计算适应度，返回值为适应度fitvalue和积累概率cumsump
[fitvalue,cumsump]=fitnessfun(population);
Generation=1;
while Generation<Generationmax+1
    for j=1:2:popsize
        %选择操作
        seln=selection(cumsump);
        %交叉操作
        scro=crossover(population,seln,pcrossover);
        scnew(j,:)=scro(1,:);
        scnew(j+1,:)=scro(2,:);
        %变异操作
        smnew(j,:)=mutation(scnew(j,:),pmutation);
        smnew(j+1,:)=mutation(scnew(j+1,:),pmutation);
    end
    population=smnew;   %产生新种群
    %计算新种群的适应度
    [fitvalue,cumsump]=fitnessfun(population);
    %记录当前代最好的适应度和平均适应度
    [fmax,nmax]=max(fitvalue);
    fmean=mean(fitvalue);
    ymax(Generation)=1/fmax;  %此处计算的是该代最优成本
    ymean(Generation)=1/fmean;%计算平均最优成本
    %记录当前代的最佳染色体
    unit=population(nmax,:);
    xmax=zeros(Generationmax,Bitlength);
    xmax(Generation,:)=unit;
    Generation=Generation+1;
end

toc

Generation=Generation-1;
bestpopulation=unit;
bestvalue=ymax(Generation);
finaltesttable=[];
for i=1:Bitlength
    if unit(i)==1
        finaltesttable(end+1)=i-21;
    end
end
disp('The final data we choose is:');
disp(finaltesttable);
disp('The final cost is:');
disp(bestvalue);

figure(1);
hand1=plot(1:Generation,ymax);
set(hand1,'linestyle','-','linewidth',1.8,'marker','*','markersize',6)
hold on;
hand2=plot(1:Generation,ymean);
set(hand2,'color','r','linestyle','-','linewidth',1.8,'marker','h',...
    'markersize',6)
xlabel('进化代数');ylabel('最优/平均成本值');xlim([1 Generationmax]);
legend('最优成本','平均成本');
hold off;
