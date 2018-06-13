% compEuler: compute Euler's method for a neuron at time 't', given current 'current'
%
% @param neuron : neuron [struct] containing neuron characteristics
% @param current: current injection at time t
% @param t      : current time instance
% @return neuron: neuron [struct] with modified characteristics
function neuron = compEuler(neuron, current, t)
if strcmp(neuron.neuronType, 'msn')
    neuron.v(t+1) = neuron.v(t) + (current + normrnd(0,200) + neuron.E + (neuron.k * ...
        (neuron.v(t) - neuron.v_r) * (neuron.v(t) - neuron.v_t)) - neuron.u(t)) / neuron.c;
    neuron.u(t+1) = neuron.u(t) + neuron.a * (neuron.v(t) - neuron.v_r) - neuron.b * neuron.u(t);
    neuron = spikeCheck(neuron, t);
else
    neuron.v(t+1) = neuron.v(t) + (current + neuron.E + (neuron.k * ...
        (neuron.v(t) - neuron.v_r) * (neuron.v(t) - neuron.v_t)) - neuron.u(t)) / neuron.c;
    neuron.u(t+1) = neuron.u(t) + neuron.a * (neuron.v(t) - neuron.v_r) - neuron.b * neuron.u(t);
    neuron = spikeCheck(neuron, t);    
end
end