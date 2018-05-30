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
        % @param neuron  : Neuron object
        % @param varargin: currents, neuron types, and weights
        function eulerIzhikevich(neuron, varargin)
            switch nargin
                case 0
                    error('Not enough input arguments.');
                case 1
                    error('Not enough input arguments.');
                case 2 % varargin{1}: current
                    I = varargin{1};
                    for t = 1:(neuron.T-1)
                        neuron.v(t+1) = neuron.v(t)+(I(t)+neuron.E+(neuron.k*...
                            (neuron.v(t)-neuron.v_r)*(neuron.v(t)-neuron.v_t))-...
                            neuron.u(t)) / neuron.c;
                        neuron.u(t+1) = neuron.u(t)+neuron.a*(neuron.v(t)-...
                            neuron.v_r)-neuron.b*neuron.u(t);
                        spikeCheck(neuron, t); % Call spikeCheck
                    end
                case 4 % varargin{1}: current, varargin{2}: type, 
                    %       varargin{3}: weight for 2nd neuron
                    % initialize 2nd neuron, simulate 2nd neuron activity
                    % with current I and neuron activity with current I +
                    % neuron2.post * weight
                    neuron2 = Neuron(varargin{2});
                    for t = 1:(neuron.T-1)
                        I = varargin{1};
                        % Compute voltage at time t+1 for neuron2, this
                        % input current is already weighted in this case
                        neuron2.v(t+1) = neuron2.v(t)+(I(t)+neuron2.E+(neuron2.k*...
                            (neuron2.v(t)-neuron2.v_r)*(neuron2.v(t)-neuron2.v_t))-...
                            neuron2.u(t)) / neuron2.c;
                        neuron2.u(t+1) = neuron2.u(t)+neuron2.a*(neuron2.v(t)-...
                            neuron2.v_r)-neuron2.b*neuron2.u(t);
                        spikeCheck(neuron2, t); % Call spikeCheck
                        
                        % Compute voltage at time t+1 for neuron
                        % modify current: I + neuron2.post * weight(varargin{3})
                        neuron.v(t+1) = neuron.v(t)+(I(t)+neuron2.post(t)*varargin{3}...
                            +neuron.E+(neuron.k*(neuron.v(t)-neuron.v_r)*...
                            (neuron.v(t)-neuron.v_t))-neuron.u(t)) / neuron.c;
                        neuron.u(t+1) = neuron.u(t)+neuron.a*(neuron.v(t)-...
                            neuron.v_r)-neuron.b*neuron.u(t);
                        spikeCheck(neuron, t); % Call spikeCheck
                    end
                    % start for loop for time
                        % if t = 1, v = 0
                        
                        % compute neuron2.v
                            % input comes from RSN, so we can use the same
                            % one (I) that we will use for the 1 neuron
                            % case
                        
                        % compute neuron.v
                    
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
