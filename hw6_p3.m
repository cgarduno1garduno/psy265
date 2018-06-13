% ~~~~~Cristopher Garduno Luna~~~~~
% PSY 265 (UCSB)       Spring2018
% Homework 6           Problem 3

% clean workspace and close plots
close all; clear all;

% initialize weights, first number is RSN number, second is MSN number
We11 = 275; We12 = 275; We21 = 275; We22 = 275; Wi = -30;

% initialize current injections (100pA on R2 after 100ms)
I_rsn1 = [zeros(1,3000)];
I_rsn2 = [zeros(1,100), 100 * ones(1,3000-100)];


% run 10 simulations and store each response and response time (RT)
responses = zeros(1,10); RTs = zeros(1,10);
for trial = 1:10

	% initialize neurons
	RSN1 = initNeuron('rsn');
	RSN2 = initNeuron('rsn');
	MSN1 = initNeuron('msn');
	MSN2 = initNeuron('msn');

    response = 0; RT = 0;
    for t = 1:(RSN1.T-1)
        RSN1 = compEuler(RSN1, I_rsn1(t), t);
        RSN2 = compEuler(RSN2, I_rsn2(t), t);
        
        if t == 1  % no input from each MSN at t = 1
            MSN1 = compEuler(MSN1, RSN1.post(t)*We11+RSN2.post(t)*We21, t);
            MSN2 = compEuler(MSN2, RSN1.post(t)*We12+RSN2.post(t)*We22, t);
        else
            MSN1 = compEuler(MSN1, RSN1.post(t)*We11+RSN2.post(t)*We21+MSN2.post(t-1)*Wi, ...
                t, 'check');
            MSN2 = compEuler(MSN2, RSN1.post(t)*We12+RSN2.post(t)*We22+MSN1.post(t-1)*Wi, ...
                t, 'check');
        end
        
        % assign reponse value
        if     MSN1.responseTime > 0
            response = 1;
            RT = MSN1.responseTime; break;
        elseif MSN2.responseTime > 0
            response = 2;
            RT = MSN2.responseTime; break;
        elseif t > 2000 % check if no MSN response after 2000ms
            response = randi(2); % random integer between 1 and 2
            RT = 2000; break;
        end
    end
    
    responses(trial) = response;
    RTs(trial) = RT;
end
