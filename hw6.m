close all; clear all; clc; 

test = initNeuron('rsn'); %init test neuron
test.PassStructByReference = true;
I = ones(1,test.T) * 125;

for t = 1:(test.T-1)
    test = compEuler(test, I, t);
end


%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FUNCTIONS ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%

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
% @param current: current injection
% @param t      : current time instance
% @return neuron: neuron [struct] with modified characteristics
function neuron = compEuler(neuron, current, t)
neuron.v(t+1) = neuron.v(t) + (current(t) + neuron.E + (neuron.k * ...
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



