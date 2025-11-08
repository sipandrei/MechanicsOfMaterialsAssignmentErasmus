data = readtable('./data.csv');
[rows,~] = size(data);
x = 1;
for i=1:rows
    if rem(i,10) == 0
        dataSmall{x,:} = data{i,:};
        x = x+1;
    end
end

d = 6; %mm
l0=30; %mm
area = pi*d^2/4;

trueStrain = log(1+dataSmall{:,2});
trueStress = dataSmall{:,1}./area.*(1+dataSmall{:,2});

p = polyfit([dataSmall{1,2},dataSmall{10,2}],[dataSmall{1,1}./area,dataSmall{10,1}./area],1);
idealLinearStress02 = p(1)*(dataSmall{:,2}+0.002)+p(2);
min = 1e10;
for i=1:rows/10
    for j=1:rows/10
        if abs(idealLinearStress02(i)-dataSmall{j,1}./area) < min
            min = abs(idealLinearStress02(i)-dataSmall{j,1}./area);
            yield = dataSmall{j,1}./area;
            yieldRow = j;
        end
    end
end

young = dataSmall{yieldRow-1,1}./area./dataSmall{yieldRow-1,2};
WHR = diff(trueStress)./diff(trueStrain);
WHR(isinf(WHR)) = 0;  

figure;
plot(data{:,2},data{:,1}./area,'b-');
hold on;
xlabel('Strain');
ylabel('Stress');
plot(trueStrain,trueStress,'r-');
%plot(data{:,2}.*(1+0.2.*data{:,2}),data{:,1}./area, '--');
legend("Normal","True");
plot(dataSmall{1:20,2}+0.002,p(1)*dataSmall{1:20,2}+p(2));
%set(gcf,'position', [0,0,max(trueStrain)+10,max(trueStress)+10]);
hold off;

figure;
plot(trueStrain,[WHR(1);WHR]);
hold on;
xlabel('True Strain');
ylabel('WHR');
%ylim([-2,2]);
hold off;
