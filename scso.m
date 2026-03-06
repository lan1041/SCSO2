clc;
clear;
close all;
tic;
tn=1;
nnn=10;
while(tn<=nnn)
    %% 1.模型建立
    vp=[521 860 650 1327];
    thk=[2 3 4];
    density=[2000 2000 2000 2000];
    vs=[160 250 200 400];
    vsl=length(vs);
    thkl=length(thk);
    interval=2;
    frequency=(5:interval:100);
    Frel=length(frequency);
    %% 2.频散曲线计算-得到标准曲线
    vr_real=mmat(thk,density,vp,vs,frequency,'R');%正演获得相速度
    Vvv=vr_real+2*(0.5-rand(size(vr_real))).*vr_real*0.1;
    vr_real=Vvv;
    %%
    %% 3.初始化种群-为算法提供初始值模型
    %%
    popsize=30;%沙丘猫数
    iter=100;%迭代次数
    %3.1初始化地层信息
    per=0.5;%搜索区间
    %初始化地层厚度thk
    thklow=thk-thk*per;
    thkup=thk+thk*per;
    thkf=thklow+rand(popsize,thkl).*(thkup-thklow);%初始地层厚度
    %初始化vs波速度
    vslow=vs-vs*per;
    vsup=vs+vs*per;
    vsf=vslow+rand(popsize,vsl).*(vsup-vslow);%初始vs波速度
    fit_best=zeros(popsize,1);
    fit_start=fit_best;
    %计算出初始种群每个个体的目标函数值及最优值
    parfor i=1:popsize
        temp1=mmat(thkf(i,:),density,vp,vsf(i,:),frequency,'R');
        pbtemp=temp1;
        fit_start(i)=sqrt(sum((pbtemp-vr_real).^2)/Frel);
    end
    thktemp=thkf;
    vstemp=vsf;
    fit_temp=fit_start;
    jkj=1;
    tempnul=fit_best;
    adab=fit_best;
    while(jkj<=iter)
        %% 4.1 第1阶段
        %更新沙丘猫位置
        parfor j=1:popsize
            %%计算沙丘猫位置
            tempn=round(1+(popsize-1).*rand);
            adab(j)=tempn;
            tempn1=mmat(thkf(adab(j),:),density,vp,vsf(adab(j),:),frequency,'R');
            pbtemp1=tempn1;
            tempnul(j)=sqrt(sum((pbtemp1-vr_real).^2)/Frel);
        end
        for jj=1:popsize
            if tempnul(jj)>=fit_start(jj)
                thktemp(jj,:)=thkf(jj,:)+rand*(thkf(jj,:)-thkf(adab(jj),:));
                vstemp(jj,:)=vsf(jj,:)+rand*(vsf(jj,:)-vsf(adab(jj),:));
            else
                thktemp(jj,:)=thkf(jj,:)+rand*(thkf(adab(jj),:)-round(1+(2-1).*rand)*thkf(jj,:));
                vstemp(jj,:)=vsf(jj,:)+rand*(vsf(adab(jj),:)-round(1+(2-1).*rand)*vsf(jj,:));
            end
            if thktemp(jj,:)<thklow
                thktemp(jj,:)=thklow+rand*(thkup-thklow);
            elseif thktemp(jj,:)>thkup
                thktemp(jj,:)=thklow+rand*(thkup-thklow);
            end
            if vstemp(jj,:)<vslow
                vstemp(jj,:)=vslow+rand*(vsup-vslow);
            elseif vstemp(jj,:)>vsup
                vstemp(jj,:)=vslow+rand*(vsup-vslow);
            end
        end
        %计算适应度值替换沙丘猫位置
        parfor aa=1:popsize
            temp2=mmat(thktemp(aa,:),density,vp,vstemp(aa,:),frequency,'R');
            pbtemp2=temp2;
            fit_temp(aa)=sqrt(sum((pbtemp2-vr_real).^2)/Frel);
        end
        for aba=1:popsize
            if fit_temp(aba)<fit_start(aba)
                thkf(aba,:)=thktemp(aba,:);
                vsf(aba,:)=vstemp(aba,:);
                fit_start(aba)=fit_temp(aba);
            end
        end
        %% 4.2第2阶段
        % 更新沙丘猫位置
        rn=0.02*(1-jkj/iter);
        for k=1:popsize
            thktemp(k,:)=thkf(k,:)+rn*(2*rand-1)*thkf(k,:);
            vstemp(k,:)=vsf(k,:)+rn*(2*rand-1)*vsf(k,:);
        end
        if thktemp(k,:)<thklow
            thktemp(k,:)=thklow+rand*(thkup-thklow);
        elseif thktemp(k,:)>thkup
            thktemp(k,:)=thklow+rand*(thkup-thklow);
        end
        if vstemp(k,:)<vslow
            vstemp(k,:)=vslow+rand*(vsup-vslow);
        elseif vstemp(k,:)>vsup
            vstemp(k,:)=vslow+rand*(vsup-vslow);
        end
        parfor aaa=1:popsize
            temp2=mmat(thktemp(aaa,:),density,vp,vstemp(aaa,:),frequency,'R');
            pbtemp2=temp2;
            fit_temp(aaa)=sqrt(sum((pbtemp2-vr_real).^2)/Frel);
        end
        for aaaa=1:popsize
            if fit_temp(aaaa)<fit_start(aaaa)
                thkf(aaaa,:)=thktemp(aaaa,:);
                vsf(aaaa,:)=vstemp(aaaa,:);
                fit_start(aaaa)=fit_temp(aaaa);
            end
        end
        [fitbest,index]=min(fit_start);%全局最优误差
        fit_best(jkj)=fitbest;
        vs_best=vsf(index,:);
        depth_best=thkf(index,:);
        jkj=jkj+1
    end
    toc;
    fr_best=mmat(depth_best,density,vp,vs_best,frequency,'R');
    for iji=1+tn-1:tn
        str = ['A',num2str(iji)];
    end
    xlswrite('fitbest.xlsx', fit_best,'sheet1',str);
    xlswrite('vs.xlsx', vs_best,'sheet1',str);
    xlswrite('thk.xlsx', depth_best,'sheet1',str);
    xlswrite('fr_best.xlsx', fr_best,'sheet1',str);
    tn=tn+1
end