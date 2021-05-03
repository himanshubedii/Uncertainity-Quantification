%--------------------------------------------------------------------------
close all; clc;  clear all; %intialization
tic                             %start time
Nr_Nodes = 26; %Number of actual nodes (do not include additional variables)

global G C b;  
G  = sparse(Nr_Nodes, Nr_Nodes); 
C  = sparse(Nr_Nodes, Nr_Nodes); 
b  = sparse(Nr_Nodes,1); 

runs = [];
while isempty(runs)
    promptRun = "enter desired integer number of monte carlo runs:";
    runs = input(promptRun);      %number of loops
    if isempty(runs) 
        fprintf("Please enter integer\n")
    elseif isinteger(runs) == 0
        break
    end
end      %number of loops 

%% individual component distributions 
fprintf("Acceptable tolerances are:\n 'n' for normal \n 'u' for uniform \n 1 for lowest value \n 2 for highest value\n")
prompt = "enter distribution of R1: ";
r1d = input(prompt,'s');
prompt = "enter distribution of R2: ";
r2d = input(prompt,'s');
prompt = "enter distribution of R3: ";
r3d = input(prompt,'s');
prompt = "enter distribution of R4: ";
r4d = input(prompt,'s');
prompt = "enter distribution of R5: ";
r5d = input(prompt,'s');
prompt = "enter distribution of R6: ";
r6d = input(prompt,'s');
prompt = "enter distribution of R7: ";
r7d = input(prompt,'s');
prompt = "enter distribution of R8: ";
r8d = input(prompt,'s');
prompt = "enter distribution of R9: ";
r9d = input(prompt,'s');
prompt = "enter distribution of R10: ";
r10d = input(prompt,'s');
prompt = "enter distribution of R11: ";
r11d = input(prompt,'s');
prompt = "enter distribution of R12: ";
r12d = input(prompt,'s');
prompt = "enter distribution of R13: ";
r13d = input(prompt,'s');
prompt = "enter distribution of R14: ";
r14d = input(prompt,'s');
prompt = "enter distribution of R15: ";
r15d = input(prompt,'s');
prompt = "enter distribution of R16: ";
r16d = input(prompt,'s');
prompt = "enter distribution of R17: ";
r17d = input(prompt,'s');
prompt = "enter distribution of R18: ";
r18d = input(prompt,'s');
prompt = "enter distribution of R19: ";
r19d = input(prompt,'s');
prompt = "enter distribution of R20: ";
r20d = input(prompt,'s');
prompt = "enter distribution of R21: ";
r21d = input(prompt,'s');
prompt = "enter distribution of C1: ";
c1d = input(prompt,'s');
prompt = "enter distribution of C2: ";
c2d = input(prompt,'s');
prompt = "enter distribution of C3: ";
c3d = input(prompt,'s');
prompt = "enter distribution of C4: ";
c4d = input(prompt,'s');
prompt = "enter distribution of C5: ";
c5d = input(prompt,'s');
prompt = "enter distribution of C6: ";
c6d = input(prompt,'s');
prompt = "enter distribution of C7: ";
c7d = input(prompt,'s');
prompt = "enter distribution of C8: ";
c8d = input(prompt,'s');
prompt = "enter distribution of C9: ";
c9d = input(prompt,'s');

prompt = "which component should appear in the comp histogram(1-30): ";
histo = input(prompt);
%% cap distributions
%% nominal values
volt = 1;
r1 = 5477.9;
r2 = 2007.6;
r3 = 3300;
r4 = 3300;
r5 = 4589.8;
r6 = 4440;
r7 = 5999.9;
r8 = 3300;
r9 = 3300;
r10 = 4.25725e3;
r11 = 3.2201e3;
r12 = 5.88327e3;
r13 = 3300;
r14 = 3300;
r15 = 5.62599e3;
r16 = 3.63678e3;
r17 = 1.0301e3; 
r18 = 3300;
r19 = 3300;
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
a = 10000; %told 10000
%% tolerance section
r1t = 5;        %should be 5,actually it doesn't matter
r2t = 5;        %should be 5
r3t = 5;        % the rest were assumed
r4t = 5;
r5t = 5;
r6t = 5;
r7t = 5;
r8t = 5;
r9t = 5;
r10t = 5;
r11t = 5;
r12t = 5;
r13t = 5;
r14t = 5;
r15t = 5;
r16t = 5;
r17t = 5; 
r18t = 5;
r19t = 5;
r20t = 5;
r21t = 5;

c1t = 5;
c2t = 5;
c3t = 5;
c4t = 5;
c5t = 5;
c6t = 5;
c7t = 5;
c8t = 5;
c9t = 5;
%% if you don't want to enter dists at beginning
dist = 'n';   %determines the distribution used in toler function
% r1d = dist;
% r2d = dist;
% r3d = dist;
% r4d = dist;
% r5d = dist;
% r6d = dist;
% r7d = dist;
% r8d = dist;
% r9d = dist;
% r10d = dist;
% r11d = dist;
% r12d = dist;
% r13d = dist;
% r14d = dist;
% r15d = dist;
% r16d = dist;
% r17d = dist;
% r18d = dist;
% r19d = dist;
% r20d = dist;
% r21d = dist;
% c1d = dist;
% c2d = dist;
% c3d = dist;
% c4d = dist;
% c5d = dist;
% c6d = dist;
% c7d = dist;
% c8d = dist;
% c9d = dist;

%% frequency constants and memory allocation
OutputNode = 5;             %should be 5
fmin = 1;                   %from 1Hz
fmax = 4e3;                 %to 6kHz, change this later???
Nrpt = 1000;                %Number of samples
Vout = zeros(runs,Nrpt);
deciB = zeros(runs,Nrpt);
comps = 30;
storeC1 = zeros(comps,runs);    %component 1
F = linspace(fmin, fmax, Nrpt);
pass = 0;
%comp = 'R9';
%% netlist and nested for loop
for i = 1:runs
    fprintf("Run number " + i + "\n")
    
    vol(26,0,volt) %26 should be the positive node and 0 should be the negative node
    
    storeC1(1,i) = resT(26,1,r1,r1t,r1d);
    storeC1(2,i) = resT(1,6,r2,r2t,r2d);
    storeC1(3,i) = resT(10,14,r3,r3t,r3d);
    storeC1(4,i) = resT(14,18,r4,r4t,r4d);
    storeC1(5,i) = resT(18,22,r5,r5t,r5d);   
    storeC1(6,i) = resT(1,2,r6,r6t,r6d);
    storeC1(7,i) = resT(2,7,r7,r7t,r7d);
    storeC1(8,i) = resT(11,15,r8,r8t,r8d);
    storeC1(9,i) = resT(15,19,r9,r9t,r9d);
    storeC1(10,i) = resT(19,23,r10,r10t,r10d);   
    storeC1(11,i) = resT(2,3,r11,r11t,r11d);
    storeC1(12,i) = resT(3,8,r12,r12t,r12d);     
    storeC1(13,i) = resT(12,16,r13,r13t,r13d);
    storeC1(14,i) = resT(16,20,r14,r14t,r14d);
    storeC1(15,i) = resT(20,24,r15,r15t,r15d);
    storeC1(16,i) = resT(3,4,r16,r16t,r16d);
    storeC1(17,i) = resT(4,9,r17,r17t,r17d); 
    storeC1(18,i) = resT(13,17,r18,r18t,r18d);
    storeC1(19,i) = resT(17,21,r19,r19t,r19d);    
    storeC1(20,i) = resT(21,25,r20,r20t,r20d);   
    storeC1(21,i) = resT(4,5,r21,r21t,r21d);
    
    storeC1(22,i) = capT(6,10,c1,c1t,c1d);           
    storeC1(23,i) = capT(22,0,c2,c2t,c2d);   
    storeC1(24,i) = capT(7,11,c3,c3t,c3d);
    storeC1(25,i) = capT(23,0,c4,c4t,c4d);
    storeC1(26,i) = capT(8,12,c5,c5t,c5d);
    storeC1(27,i) = capT(24,0,c6,c6t,c6d);    
    storeC1(28,i) = capT(9,13,c7,c7t,c7d);    
    storeC1(29,i) = capT(25,0,c8,c8t,c8d);    
    storeC1(30,i) = capT(5,0,c9,c9t,c9d);   

    vcvs(10,0,14,22,a)
    vcvs(18,0,14,6,a)
    vcvs(11,0,15,23,a)
    vcvs(19,0,15,7,a)
    vcvs(12,0,16,24,a)
    vcvs(20,0,16,8,a)
    vcvs(13,0,17,25,a)
    vcvs(21,0,17,9,a)
    
    %% frequency stuff
    for n=1:Nrpt
        w = 2*pi*F(n);
        s = 1i*w;
        A = G + s*C;  %Enter A here! 
        %X = A\b;  % The operator "\" is an efficient way to solve AX=b.
        [L,U,P,Q] = lu(sparse(A),0.1);
        z = L\(P*(-b));
        y = U\z;
        X = Q*y;
        Vout(i,n) = abs(X(OutputNode));  % put (i,n) when doing MC loops
        deciB(i,n) = 20*log10(Vout(i,n));
    end
    %% add yield calculations here
    %pass band ripple and minimum attenuation
%     if ( && (max(deciB(i,951:end)) < -40))
%         pass = pass + 1;
%     end
    %% clear it
    G  = sparse(Nr_Nodes, Nr_Nodes); 
    C  = sparse(Nr_Nodes, Nr_Nodes); 
    b  = sparse(Nr_Nodes,1); 
end
% yield = (pass/runs) * 100;
% fprintf("Yield is %d percent\n",yield)
%% Data Manipulation
%mean
%used to be in for loop but now it's not
meanV = sum(Vout)/runs; %first sum each column, then divide by number of runs
%meandB = sum(deciB)/runs;

% find standard deviation
%Sd2 = std(Vout);       %matlab builtin function, only use for testing
%nested loops, find a way to get around that
if runs > 1
    SdV = zeros(1,Nrpt);
    valueV = zeros(1,runs);
    for counter = 1:Nrpt
        for j = 1:runs
            valueV(1,j) = abs((Vout(j,counter) - meanV(1,counter))^2);
        end
        SdV(1,counter) = sqrt(sum(valueV)/(runs-1));
    end
    % 3 sigma stuff
    sd3V = SdV * 3;                     %store the result of 3 multiplied by standard deviation 
    meanPsd3V = meanV + sd3V;           %store the result of the mean plus (3 multiplied by standard deviation)
    meanMsd3V = meanV - sd3V;           %store the result of the mean minus (3 multiplied by standard deviation)
    
    
    % 95% and 99% confidence interval with Z score
    %sample size is the number of runs
    %gonna use z values because that's easier
    %THIS FORMULA ONLY WORKS FOR NORMALLY DISTRIBUTED DATA
    %so if we use uniform data, this won't work

    z95 = 1.96;                     %use z values for runs more than 30, 
                                    %don't have anything else for now
    z99 = 2.6;                      %gonna round up for now

    %disp("Confidence Interval")
    SE = SdV/(sqrt(runs));           %standard error

    diff95 = z95*SE;                
    CIplu95 = meanV + diff95;       %in green
    CImin95 = meanV - diff95; 

    diff99 = z99*SE; 
    CIplu99 = meanV + diff99;       %in magenta
    CImin99 = meanV - diff99;
end

%% volt output plot 
for k = 1:runs
    figure(1);  
    plot(F, Vout(k,:),'blue');
    if k == 1
        hold on
    end
    grid on;
    title("Monte Carlo for Ch.4 Circuit for [] with " + runs + " runs");
    xlabel('Frequency (Hz)','FontSize',12);
    ylabel('Magnitude of V_{out} (V)','FontSize',12);
end
if runs > 1
    d = plot(F,meanV,F,meanPsd3V,F,meanMsd3V);
    d(1).LineWidth = 1;             %mean
    d(1).Color = 'yellow';

    d(2).LineWidth = 2;             %mean + 3sd
    d(2).Color = 'magenta';
    d(2).LineStyle = '--';

    d(3).LineWidth = 2;             %mean - 3sd 
    d(3).Color = 'r';
    d(3).LineStyle = ':';
    
end
hold off

% for k = 1:runs
%     figure(1);  
%     plot(F, deciB(k,:));
%     if k == 1
%         hold on
%     end
%     grid on;
%     title("Monte Carlo for Ch. 4 with " +comp+ " with " + runs + " runs");
%     xlabel('Frequency (Hz)','FontSize',12);
%     ylabel('Magnitude of V_{out} (dB)','FontSize',12);
% 
% end
% hold off
%% mean, mean + 3sigma, mean - 3sigma and 95% and 99% Confidence interval plot
% plot(F,meanV,F,meanPsd3,F,meanMsd3,'LineWidth',1)
if runs > 1
    figure(2); 
    p = plot(F,meanV,F,meanPsd3V,F,meanMsd3V,F,CIplu95,F,CImin95,F,CIplu99,F,CImin99);
    p(1).LineWidth = 2;             %mean
    p(1).Color = 'r';

    p(2).LineWidth = 2;             %mean + 3sd
    p(2).Color = 'r';
    p(2).LineStyle = '--';

    p(3).LineWidth = 2;             %mean - 3sd 
    p(3).Color = 'r';
    p(3).LineStyle = ':';

    p(4).LineWidth = 2; 
    p(4).Color = 'k';               %+Confidence Interval 95%
    p(4).LineStyle = '--';

    p(5).LineWidth = 2; 
    p(5).Color = 'k';               %-Confidence Interval 95%
    p(5).LineStyle = ':';

    p(6).LineWidth = 2; 
    p(6).Color = 'm';               %+Confidence Interval 99%
    p(6).LineStyle = '--';

    p(7).LineWidth = 2; 
    p(7).Color = 'm';               %-Confidence Interval 99%
    p(7).LineStyle = ':';
    grid on;
    title("Statistical info of Vout wrt R1,R2,R5,R9,C2,C9 with " + runs + " runs");
    xlabel('Frequency  (Hz)','FontSize',12);
    ylabel('V_{out} (V)','FontSize',12);
    legend('mean','mean + 3sd','mean - 3sd','Upper LImit 95% CI','Lower Limit 95% CI','Upper LImit 99% CI','Lower LImit 99% CI','FontSize',8)
%% histograms of R1 and 
    figure(3)
    his = histogram(storeC1(histo,:)); %most of the values are 1 because it's the passband value
    grid on
    title("Variation of R1 for LPF w/Ideal Op-amps, " + dist+ " Dist with " + runs + " runs")
    xlabel("Values of R1 (\Omega)")
    ylabel("Number of Samples")

end
%% vout histogram
figure(4)
h = histogram(Vout); %most of the values are 1 because it's the passband value
grid on
title("A Histogram of Chapter 4 V_{out} " + dist +" Distribution with " + runs + " runs")
xlabel("Values of V_{out}")
ylabel("Number of Samples")

toc                             %stop time
%EoF