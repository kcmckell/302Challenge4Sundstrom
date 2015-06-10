   %%% CHRISTER SUNDSTRÖM %%%
%%% EE302 CHALLENGE PROBLEM 4 %%%
clf
clear all
clc

%%define system 
systemnumerator = input('input transfer function numerator matrix: ');
systemdenominator = input('input transfer function denominator matrix: ');
sys = tf(systemnumerator,systemdenominator)

%%define percetages for settling time and rise time
rtpercentage = input('define rise time percentage [%]: ')
rtp = (100-rtpercentage)/100;
stpercentage = input('define settling time percentage [%]: ');
stpupper = (100+stpercentage)/100;
stplower = (100-stpercentage)/100;

%%define stepsize 
stepsize = input('define size of step input: ');
opt = stepDataOptions('StepAmplitude',stepsize);

%%plot step response
[y,t] = step(sys,opt);
plot(t,y)
grid on
hold on

%%steady state counted as last value of step command
%%steady state error calculated from that
SS = y(end);
SSE = SS - stepsize;
SSEP = 100*SSE/stepsize;

%%plot limits for rise and settling time 
plot([0,t(end)],[SS*stpupper,SS*stpupper],'--','color','k')
plot([0,t(end)],[SS*stplower,SS*stplower],'--','color','k')
plot([0,t(end)],[SS*rtp,SS*rtp],'--','color','r')

%%calculate overshoot and peak time by finding max value in output
[maxi, MI] = max(y);
PT = t(MI);
MOS = maxi - SS;
POS = (MOS)/SS*100;

%%find rise time by first crossing of rise time limit
RT = find(y>rtp*SS,1,'first');
RT = t(RT);

%%find settling time by last crossing of settling time limits
ST = t(max([find(y>stpupper*SS,1,'last'),find(y<stplower*SS,1,'last')]));

s = size(t);

%%numerical integration for square error
%% if ss error is close to zero (SS<0.05), finite value is assumed correct, else "inf"
if abs(SSE)<.05
    ise = [0];
    for i = 1:s(1)-1
    ise(i+1) = ise(i) + ((y(i)+y(i+1))/2-stepsize)^2 * (t(i+1)-t(i));
    end
    ISE = ise(end);
else
    ISE = 'inf';
end

%%numerical integration for square output
%% if SS is close to zero (<0.05), finite value is assumed correct, else "inf"
if abs(y(end))<0.05
    iso = 0;
    for i = 1:s(1)-1
    iso(i+1) = iso(i) + ((y(i)+y(i+1))/2)^2 * (t(i+1)-t(i));
    end
    ISO = iso(end);
else
    ISO = 'inf'
end

%%%TABLE%%%%%%
variable = {'Steady State Error'
            'Steady-state error percentage'
            'Rise time'
            'Peak time'
            'Settling time'
            'Maximum overshoot'
            'Percent overshoot'
            'ISE'
            'ISO'};
       
data = {SSE;SSEP;RT;PT;ST;MOS;POS;ISE;ISO};
table = [variable,data]
