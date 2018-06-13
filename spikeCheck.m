% spikeCheck: check for action potential and reset
%
% @param neuron: neuron [struct] containing neuron characteristics
% @param t     : time instance
% @return neuron: neuron [struct] with modified characteristics
function neuron = spikeCheck(neuron, t, varargin)
if neuron.v(t+1) >= neuron.v_peak
    neuron.v(t) = neuron.v_peak; neuron.v(t+1) = neuron.v_reset;
    neuron.u(t+1) = neuron.u(t) + neuron.d;
    if t < neuron.T-251
        tempa = [zeros(1,t-1),neuron.alpha,zeros(1,neuron.T-249-t)];
        neuron.post = neuron.post + tempa;
        if nargin == 3
        	if neuron.post(t) > 1.7 && neuron.responseTime == 0
        		neuron.responseTime = t;
        	end
        end
    end
end
end