function [fitvalue,cumsump]=fitnessfun(population)
global Bitlength
global truetablelist
global costofmea
global popsize
testtable=[];
caltable=[];
fitvalue=zeros(popsize,1);
cumsump=zeros(popsize,1);
numberoftruevalue=size(truetablelist,1)/2;
sumcostofmea=zeros(popsize,1);%测量点成本  mm 
sumcostofcal=zeros(popsize,1);%标定误差成本
sumcost=zeros(popsize,1);%总成本
fitvalue=zeros(popsize,1);%适应度值
for i=1:popsize
    caltable=[];
    testtable=[];
    for k=1:Bitlength
        if population(i,k)==1
            testtable(end+1)=k-21;
        else
            caltable(end+1)=k-21;
        end
    end
    %测定总成本
    sumcostofmea(i)=costofmea*size(testtable,2);
    for j=1:(numberoftruevalue)
        volcaltable=[];
        voltesttable=[];
        for h=1:size(testtable,2)
            voltesttable(end+1)=truetablelist(2*j,(testtable(h)+21));%是不是应该改成J？
        end
        for h=1:size(caltable,2)
            volcaltable(end+1)=truetablelist(2*j,(caltable(h)+21));
        end
        fitresult=interp1(voltesttable,testtable,volcaltable,'spline');
        deviationresult=abs(fitresult-caltable);
        %误差标定总成本
        anumberfortest=size(caltable,2);
        for l=1:(anumberfortest)
            if deviationresult(l)<=0.5
                sumcostofcal(i)=sumcostofcal(i)+0;
            elseif deviationresult(l)<=1.0
                sumcostofcal(i)=sumcostofcal(i)+1;
            elseif deviationresult(l)<=1.5
                sumcostofcal(i)=sumcostofcal(i)+5;
            elseif deviationresult(l)<=2.0
                sumcostofcal(i)=sumcostofcal(i)+10;
            else 
                sumcostofcal(i)=sumcostofcal(i)+10000;
            end
%               error05=sum(deviationresult<=0.5);
%               error10=sum(deviationresult<=1.0);
%               error15=sum(deviationresult<=1.5);
%               error20=sum(deviationresult<=2.0);
%               error30=sum(deviationresult>2);
%               sumcostofcal(i)=sumcostofcal(i)+error10-error05+5*(error15...
%                   -error10)+10*(error20-error15)+error30*10000;
        end
    end
    sumcostofcal(i)=sumcostofcal(i)/numberoftruevalue;%算出平均值
    sumcost(i)=sumcostofmea(i)+sumcostofcal(i);%总成本
    fitvalue(i)=1/sumcost(i);%适应度函数值
end
%计算选择概率
fsum=sum(fitvalue);
Pperpopulation=fitvalue/fsum;
Pperpopulation_20=Pperpopulation.^20;
psum=sum(Pperpopulation_20);
Pperpopulation_20=Pperpopulation_20/psum;
%计算累计概率
cumsump(1)=Pperpopulation_20(1);
for i = 2:popsize
    cumsump(i)=cumsump(i-1)+Pperpopulation_20(i);
end
fitvalue=fitvalue';
cumsump=cumsump';