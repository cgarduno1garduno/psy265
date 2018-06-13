% ~~~~~Cristopher Garduno Luna~~~~~
% PSY 265 (UCSB)       Spring2018
% Homework 6           Problem 4

% clean workspace and close plots
close all; clear all;

% initialize weights, trial number, empty currents
We11 = 275; We12 = 275; We21 = 275; We22 = 275; Wi = -30;
trials = 100; I_rsn1 = zeros(1,3000); I_rsn2 = I_rsn1;

% initialize accuracy, response time, dopamine levels, and probability vector
accuracy = zeros(1,trials);  RTs = zeros(1, trials);
DA = zeros(1, trials);       p = ones(1,trials)*0.5;

% run trials
for n = 1:trials
	% initialize neurons
	RSN1 = initNeuron('rsn');
	RSN2 = initNeuron('rsn');
	MSN1 = initNeuron('msn');
	MSN2 = initNeuron('msn');

	% present stimulus
	stimulus = randi(2);

	% inject current based on stimulus
	if stimulus == 1
		I_rsn1 = [zeros(1,100), 100 * ones(1,RSN1.T-100)];
	else
		I_rsn2 = [zeros(1,100), 100 * ones(1,RSN1.T-100)];
	end

	% run simulation
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
        
        % assign reponse values and times
        if     MSN1.responseTime > 0
            response = 1; 
            RTs(n) = MSN1.responseTime;
        elseif MSN2.responseTime > 0
            response = 2; 
            RTs(n) = MSN2.responseTime;
        elseif t > 2000 % check if no MSN response after 2000ms
            response = randi(2); % random integer between 1 and 2
            RTs(n) = 2000;
        end
    end

    % compute reward/accuracy
    if response == stimulus
    	accuracy(n) = 1;
    end

    % compute reward prediction error and update expected reward (p)
    RPE = accuracy(n) - p(n);
    p(n+1) = p(n) + 0.5*(accuracy(n)-p(n));

    % compute dopamine level
    if RPE > 1
    	DA(n) = 1;
    elseif RPE > -0.25
    	DA(n) = 0.8 * RPE + 0.2;
    else
    	DA(n) = 0;
    end

    % compute S1, R1, S2, R2, and update weights
    if stimulus == 1
    	S1 = 1; S2 = 0;
    else
    	S1 = 0; S2 = 1;
    end
    if response == 1
    	R1 = 1; R2 = 0;
    else
    	R1 = 0; R2 = 1;
    end

    if accuracy(n) == 1
    	We11 = We11 + 20*S1*R1*(-0.2+DA(n));
    	We12 = We12 + 20*S1*R2*(-0.2+DA(n));
    	We21 = We21 + 20*S2*R1*(-0.2+DA(n));
    	We22 = We22 + 20*S2*R2*(-0.2+DA(n));
    else
    	We11 = We11 - 20*S1*R1*(0.2-DA(n));
    	We12 = We12 - 20*S1*R2*(0.2-DA(n));
    	We21 = We21 - 20*S2*R1*(0.2-DA(n));
    	We22 = We22 - 20*S2*R2*(0.2-DA(n));
    end

end