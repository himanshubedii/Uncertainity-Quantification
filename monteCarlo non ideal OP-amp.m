close all; clc;  clear all; %intialization
% TOELRANCes FOR EACH COMPONENT

Nr_Nodes = 34; %Number of nodes increased from 26

global G C b;  
G  = sparse(Nr_Nodes, Nr_Nodes); 
C  = sparse(Nr_Nodes, Nr_Nodes); 
b  = sparse(Nr_Nodes,1); 

promptRun = "enter desired integer number of monte carlo runs:";
runs = input(promptRun);       %number of iterataion the user want 
%% nominal values of components

% assuming voltage source to be 1
volt = 1; 
%r1 = 5.50741e3;
%r2 = 2.00502e3;
r3 = 3.3e3;
r4 = 3.3e3;
r5 = 4.5898e3;
r6 = 4.46017e3;
r7 = 6.00261e3;
r8 = 3.3e3;
r9 = 3.3e3;
r10 = 4.25725e3;
r11 = 3.23323e3;
r12 = 5.88327e3;
r13 = 3.3e3;
r14 = 3.3e3;
r15 = 5.62599e3;
r16 = 3.6521e3;
r17 = 1.01602e3; 
r18 = 3.3e3;
r19 = 3.3e3;
r20 = 5.808498e3;
r21 = 1.2201e3;

c1 = 12e-9;
c2 = 10e-9;
c3 = 6.8e-9;
c4 = 10e-9;
c5 = 4.7e-9;
c6 = 10e-9;
c7 = 6.8e-9;
c8 = 10e-9;
c9 = 10e-9;

a = 1000;  %assumption for gain of an OP/AmP

%% tolerance part any tolernace can be given

dist = 'n';  %determines the distribution used in toler function

vt = 0; 

r1t =  5; 
r2t =  5;
r3t =  5;
r4t =  5;
r5t =  5;
r6t =  5;
r7t =  5;
r8t =  0;
r9t =  0;
r10t = 0;
r11t = 0;
r12t = 0;
r13t = 0;
r14t = 0;
r15t = 0;
r16t = 0;
r17t = 0;
r18t = 0;
r19t = 0;
r20t = 0;
r21t = 0;

c1t = 3;
c2t =3;
c3t = 3;
c4t = 0;
c5t = 0;
c6t = 0;
c7t = 0;
c8t = 0;
c9t = 0;

%% frequency constants and memory allocation

OutputNode = 5;
fmin = 0;         
fmax = 4000;         
Nrpt = 1000;   %Number of points
Vout = zeros(runs,Nrpt);
deciB = zeros(runs,Nrpt);
F = linspace(fmin, fmax, Nrpt);
Pass = 0; %for yield
%% netlist and nested for loop

for i = 1:runs

  volT(0,26,volt,vt,dist) %26 
     
  r1 = toler(5.50741e3,r1t,dist);
  storeR1(i) = r1; % any compoent can be stored to use histogram
  res(26,1,r1)
    
  %resT(26,1,r1,r1t,dist)
    
  %resT(1,6,r2,r2t,dist)
    
  r2 = toler(2.00502e3,r2t,dist);
  storeR2(i) = r2;
  res(1,6,r2);

  resT(10,14,r3,r3t,dist)
  resT(14,18,r4,r4t,dist)
  resT(18,22,r5,r5t,dist)
  resT(1,2,r6,r6t,dist)
  resT(2,7,r7,r7t,dist)
  resT(11,15,r8,r8t,dist)
    
  %r9 = toler(3.3e3,r9t,dist);
  %storeR9(i) = r9;
  %res(15,19,r9);

  resT(15,19,r9,r9t,dist)
  resT(19,23,r10,r10t,dist)
  resT(2,3,r11,r11t,dist)
  resT(3,8,r12,r12t,dist)  
  resT(12,16,r13,r13t,dist)
  resT(16,20,r14,r14t,dist)
  resT(20,24,r15,r15t,dist)
  resT(3,4,r16,r16t,dist)
  resT(4,9,r17,r17t,dist)
  resT(13,17,r18,r18t,dist)
  resT(17,21,r19,r19t,dist)
  resT(21,25,r20,r20t,dist)
  resT(4,5,r21,r21t,dist)
           
  capT(6,10,c1,c1t,dist)
  capT(22,0,c2,c2t,dist)
  capT(7,11,c3,c3t,dist)
    
  capT(23,0,c4,c4t,dist)
% c4 = toler(10e-9,c4t,dist);
% storeC4(i) = c4;
% cap(23,0,c4);
    
  capT(8,12,c5,c5t,dist)
  capT(24,0,c6,c6t,dist)
    
  capT(9,13,c7,c7t,dist)
% c7 = toler(6.8e-9,c4t,dist);
% storeC7(i) = c7;
% cap(9,13,c7);
    
  capT(25,0,c8,c8t,dist)
  capT(5,0,c9,c9t,dist)
    
% function using the linear micro-model circuit
  opamp(22,14,27,10,dist) 
  opamp(6,14,28,18,dist)
  opamp(23,15,29,11,dist)
  opamp(7,15,30,19,dist)
  opamp(24,16,31,12,dist)
  opamp(8,16,32,20,dist)
  opamp(25,17,33,13,dist)
  opamp(9,17,34,21,dist)
    
    %% frequency and using LU decmopositon techniques
    for n=1:Nrpt
        w = 2*pi*F(n);
        s = 1i*w;
        A = G + s*C; %Enter A here! 
        %X = A\b;  % The operator "\" is an efficient way to solve AX=b.
        [L,U,P,Q] = lu(sparse(A),0.1);
        z = L\(P*(-b));
        y = U\z;
        X = Q*y;
        Vout(i,n) = abs(X(OutputNode));  % put (i,n) when doing MC loops
        deciB(i,n) = 20*log10((Vout(i,n)));
    end
     
    Vmax = max(Vout(i,1:867));  % returns the max output voltage
    Vmin = min(Vout(i,1:867));  % returns the min output voltage
    Vatt = max(Vout(i,950:end)); 
    Diff = Vmax - Vmin;         % returns the ripple
    
    if Diff < 1.01 && Vatt < 0.01 % sepcifying conditions for yield
        Pass = Pass + 1
    end
    
    %% clear it
    G  = sparse(Nr_Nodes, Nr_Nodes); 
    C  = sparse(Nr_Nodes, Nr_Nodes); 
    b  = sparse(Nr_Nodes,1); 
    
end
%here 
yield = (Pass/runs)*100
%% Stastical Data 
%mean
%  meanV = zeros(1,Nrpt);
% for m = 1:Nrpt
%      meanV(1,m) = sum(Vout(:,m))/runs; %first sum each column, then divide by number of runs
% end

meanV = sum(Vout)/runs;
 
%% To caculate standard deviation

%Sd2 = std(Vout);  %matlab builtin function, only use for testing

 Sd = zeros(1,Nrpt);
 value = zeros(1,runs);
 for counter = 1:Nrpt
    for j = 1:runs
        value(1,j) = abs((Vout(j,counter) - meanV(1,counter))^2);
     end
    Sd(1,counter) = sqrt(sum(value)/(runs-1));
 end


%% 3 sigma stuff
sd3 = Sd * 3;           %store the result of 3 multiplied by standard deviation 
meanPsd3 = meanV + sd3;  %store the result of the mean plus (3 multiplied by standard deviation)
meanMsd3 = meanV - sd3;  %store the result of the mean minus (3 multiplied by standard deviation)

z95 = 1.96;   %use z values for runs more than 30, for 95% and 99%
                                    
z99 = 2.6;      

%disp("Confidence Interval")
SE = Sd/(sqrt(runs));           %standard error

diff95 = z95*SE;                
CIplu95 = meanV + diff95;      
CImin95 = meanV - diff95; 

diff99 = z99*SE; 
CIplu99 = meanV + diff99;       
CImin99 = meanV - diff99;



%% volt output plot 
for k = 1:runs
    figure(1);  
    plot(F, Vout(k,:),'r');
    if k == 1
        hold on
    end
    grid on;
    title("Monte Carlo Analayis with " + runs + " runs");
    xlabel('Frequency (Hz)','FontSize',12);
    ylabel('Magnitude of V_{out} (V)','FontSize',12);

end
d = plot(F,meanV,F,meanPsd3,F,meanMsd3,F,CIplu95,F,CImin95,F,CIplu99,F,CImin99);
d(1).LineWidth = 1;             %mean
d(1).Color = 'k';

d(2).LineWidth = 2;             %mean + 3sd
d(2).Color = 'k';
d(2).LineStyle = '--';

d(3).LineWidth = 2;             %mean - 3sd 
d(3).Color = 'k';
d(3).LineStyle = ':';

d(4).LineWidth = 2; 
d(4).Color = 'b';               %+Confidence Interval 95%
d(4).LineStyle = '--';

d(5).LineWidth = 2; 
d(5).Color = 'b';               %-Confidence Interval 95%
d(5).LineStyle = ':';

d(6).LineWidth = 2; 
d(6).Color = 'g';               %+Confidence Interval 99%
d(6).LineStyle = '--';

d(7).LineWidth = 2; 
d(7).Color = 'g';               %-Confidence Interval 99%
d(7).LineStyle = ':';
hold off



figure(5); 
p = plot(F,meanV,F,meanPsd3,F,meanMsd3,F,CIplu95,F,CImin95,F,CIplu99,F,CImin99);
p(1).LineWidth = 2;             %mean
p(1).Color = 'k';

p(2).LineWidth = 2;             %mean + 3sd
p(2).Color = 'k';
p(2).LineStyle = '--';

p(3).LineWidth = 2;             %mean - 3sd 
p(3).Color = 'k';
p(3).LineStyle = ':';

p(4).LineWidth = 2; 
p(4).Color = 'b';               %+Confidence Interval 95%
p(4).LineStyle = '--';

p(5).LineWidth = 2; 
p(5).Color = 'b';               %-Confidence Interval 95%
p(5).LineStyle = ':';

p(6).LineWidth = 2; 
p(6).Color = 'g';               %+Confidence Interval 99%
p(6).LineStyle = '--';

p(7).LineWidth = 2; 
p(7).Color = 'g';               %-Confidence Interval 99%
p(7).LineStyle = ':';
grid on;
title("Mean, mean + 3*Sd, mean - 3*Sd, and 95% CI and 99% CI of Vout with " + runs + " runs");
xlabel('Frequency  (Hz)','FontSize',12);
ylabel('V_{out} (V)','FontSize',12);
legend({'mean','mean + 3sd','mean - 3sd','Upper LImit 95% CI','Lower Limit 95% CI','Upper LImit 99% CI','Lower LImit 99% CI'},'Location','northwest','FontSize',8)

%% histograms  
figure(6)
h = histogram(Vout); %most of the values are 1 because it's the passband value
grid on
title("A Histogram of Chapter 17 V_{out} with " + runs + " runs")
xlabel("Values of V_{out}")
ylabel("Number of Samples")

 figure(7)
 his = histogram(storeR9);
 grid on
 title("Variation of Chapter 17 R_{9} using Normal Distribution with " + runs + " runs")
 xlabel("Values of R9 (\Omega)")
 ylabel("Number of Samples")

%EoF





