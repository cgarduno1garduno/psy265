classdef Neuron < handle
	% Neuron class allows you to create Neuron objects with different
    %   initial parameters depending on `Type`.
    %   RSN = regular spiking neuron, specified by 'rsn'
    %   MSN = medium spiny neuron, specified by 'msn'
    properties
        % these params are set by the default constructor
        neuronType; c; v_r; v_t; k; E; a; b; v_peak; v_reset; d
        
        % eulerIzhikevich params
        T = 2000;             % simulation duration [ms]
        u = 0*ones(1,2000);   % recovery [pA]
        v = -60*ones(1,2000); % initial membrane potential (mV)
        
        % spikeCheck params
        post  = zeros(1,2000);
        alpha = ((1:250)/30).*exp((30-(1:250))/30);
    end % properties
    
    methods
        %~~~~~~~~~~~~~~~ Default constructor ~~~~~~~~~~~~~~~%
        % @object neuron: stores Neuron object
        % @param  Type  : specifies type of neuron
        function neuron = Neuron(Type)
            if strcmp('rsn',Type)
                neuron.d = 100;        neuron.c = 100;   neuron.v_r = -60;   
                neuron.v_t = -40;      neuron.k = 0.7;   neuron.E = 0; 
                neuron.a = -0.06;      neuron.b = 0.03;  neuron.v_peak = 35;             
                neuron.v_reset = -50;  neuron.neuronType = Type;
            elseif strcmp('msn',Type)
                neuron.d = 150;        neuron.c = 50;    neuron.v_r = -80; 
                neuron.v_t = -25;      neuron.k = 1.0;   neuron.E = 70; 
                neuron.a = -0.20;      neuron.b = 0.01;  neuron.v_peak = 40; 
                neuron.v_reset = -55;  neuron.neuronType = Type;
            else
                error('Incorrect neuron type. Available neurons: rsn, msn')
            end
        end
        
        % Euler's Method for Izhikevich Neuron Model
        % @param neuron: Neuron object
        % @param I     : injected current
        function eulerIzhikevich(neuron, I)
            for t = 1:(neuron.T-1)
                neuron.v(t+1) = neuron.v(t)+(I(t)+neuron.E+(neuron.k*...
                    (neuron.v(t)-neuron.v_r)*(neuron.v(t)-neuron.v_t))-...
                    neuron.u(t)) / neuron.c;
                neuron.u(t+1) = neuron.u(t)+neuron.a*(neuron.v(t)-...
                    neuron.v_r)-neuron.b*neuron.u(t);
                spikeCheck(neuron, t); % Call spikeCheck
            end
        end
        
        % Check for action potential and compute alpha
        % @param neuron: Neuron object
        % @param t     : time instance
        function spikeCheck(neuron, t)
            if neuron.v(t+1) >= neuron.v_peak
                neuron.v(t)   = neuron.v_peak;
                neuron.v(t+1) = neuron.v_reset;
                neuron.u(t+1) = neuron.u(t)+neuron.d;
                if t < neuron.T-251
                    tempa = [zeros(1,t-1),neuron.alpha,zeros(1,neuron.T-249-t)];
                    neuron.post = neuron.post + tempa;
                end
            end
        end

    end % methods
end
