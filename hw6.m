%% PSY 265, HW6, spring2018
% @author Cristopher Garduno Luna

%% Problem 1
% clean workspace and close plots
close all; clear all;

% initialize neurons
RSN1 = initNeuron('rsn');
RSN2 = initNeuron('rsn');
MSN1 = initNeuron('msn');
MSN2 = initNeuron('msn');

% initialize weights, first number is RSN number, second is MSN number
We11 = 275; We12 = 275; We21 = 275; We22 = 275;
Wi = -30;

% initialize current injection for RSN1
% 100pA starting at t = 100
I_rsn1 = [zeros(1,100), 100 * ones(1,RSN1.T-100)];

% run simulation 
for t = 1:(RSN1.T-1)
    RSN1 = compEuler(RSN1, I_rsn1(t), t);

    if t == 1  % no input from each MSN at t = 1
        MSN1 = compEuler(MSN1, RSN1.post(t)*We11, t);
        MSN2 = compEuler(MSN2, RSN1.post(t)*We12, t);
    else 
        MSN1 = compEuler(MSN1, RSN1.post(t)*We12 + MSN2.post(t-1)*Wi, t);
        MSN2 = compEuler(MSN2, RSN1.post(t)*We12 + MSN1.post(t-1)*Wi, t);
    end
end

% plot results
subplot(4,1,1);
plot(1:2000, RSN1.v(1:2000));
xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('RSN1 Voltage');
set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
subplot(4,1,2);
plot(1:2000, RSN2.v(1:2000));
xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('RSN2 Voltage');
set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
subplot(4,1,3);
plot(1:2000, MSN1.v(1:2000));
xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('MSN1 Voltage');
set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
subplot(4,1,4);
plot(1:2000, MSN2.v(1:2000));
xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('MSN2 Voltage');
set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);



%% Problem 2





%% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ %%

% initNeuron initializes neuron of a type 'Type'
%
% @param: Type  : string containing 'rsn' or 'msn' neuron type
% @param: T     : time [ms] duration of simulation
% @return neuron: 1x1 struct
function neuron = initNeuron(Type)
neuron.T = 3000; neuron.v = -60 * ones(1,neuron.T); neuron.u = 0 * ones(1,neuron.T);
neuron.post = zeros(1,neuron.T); neuron.alpha = ((1:250)/30).*exp((30-(1:250))/30);

if strcmp('rsn',Type)
    neuron.d = 100; neuron.c = 100; neuron.v_r = -60; neuron.v_t = -40;
    neuron.k = 0.7; neuron.E = 0; neuron.a = -0.06; neuron.b = 0.03;
    neuron.v_peak = 35; neuron.v_reset = -50; neuron.neuronType = Type;
elseif strcmp('msn',Type)
    neuron.d = 150; neuron.c = 50; neuron.v_r = -80; neuron.v_t = -25;
    neuron.k = 1.0;   neuron.E = 70; neuron.a = -0.20; neuron.b = 0.01;
    neuron.v_peak = 40; neuron.v_reset = -55; neuron.neuronType = Type;  
else
    error('Incorrect neuron type. Available neurons: rsn, msn');
end
end



% compEuler: compute Euler's method for a neuron at time 't', given current 'current'
%
% @param neuron : neuron [struct] containing neuron characteristics
% @param current: current injection at time t
% @param t      : current time instance
% @return neuron: neuron [struct] with modified characteristics
function neuron = compEuler(neuron, current, t)
neuron.v(t+1) = neuron.v(t) + (current + normrnd(0,200) + neuron.E + (neuron.k * ...
    (neuron.v(t) - neuron.v_r) * (neuron.v(t) - neuron.v_t)) - neuron.u(t)) / neuron.c;
neuron.u(t+1) = neuron.u(t) + neuron.a * (neuron.v(t) - neuron.v_r) - neuron.b * neuron.u(t);
neuron = spikeCheck(neuron, t);
end



% spikeCheck: check for action potential and reset
%
% @param neuron: neuron [struct] containing neuron characteristics
% @param t     : time instance
% @return neuron: neuron [struct] with modified characteristics
function neuron = spikeCheck(neuron, t)
if neuron.v(t+1) >= neuron.v_peak
    neuron.v(t) = neuron.v_peak; neuron.v(t+1) = neuron.v_reset;
    neuron.u(t+1) = neuron.u(t) + neuron.d;
    if t < neuron.T-251
        tempa = [zeros(1,t-1),neuron.alpha,zeros(1,neuron.T-249-t)];
        neuron.post = neuron.post + tempa;
    end
end
end



