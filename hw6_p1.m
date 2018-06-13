% ~~~~~Cristopher Garduno Luna~~~~~
% PSY 265 (UCSB)       Spring2018
% Homework 6           Problem 1

% clean workspace and close plots
close all; clear all;

% initialize neurons
RSN1 = initNeuron('rsn');
RSN2 = initNeuron('rsn');
MSN1 = initNeuron('msn');
MSN2 = initNeuron('msn');

% initialize weights, first number is RSN number, second is MSN number
We11 = 275; We12 = 275; We21 = 275; We22 = 275; Wi = -30;

% initialize current injections (100pA on R1 after 100ms)
I_rsn1 = [zeros(1,100), 100 * ones(1,RSN1.T-100)];
I_rsn2 = [zeros(1,RSN1.T)];

% run simulation 
for t = 1:(RSN1.T-1)
    RSN1 = compEuler(RSN1, I_rsn1(t), t);
    RSN2 = compEuler(RSN2, I_rsn2(t), t);

    if t == 1  % no input from each MSN at t = 1
        MSN1 = compEuler(MSN1, RSN1.post(t)*We11+RSN2.post(t)*We21, t);
        MSN2 = compEuler(MSN2, RSN1.post(t)*We12+RSN2.post(t)*We22, t);
    else 
        MSN1 = compEuler(MSN1, RSN1.post(t)*We12+RSN2.post(t)*We21+MSN2.post(t-1)*Wi, t);
        MSN2 = compEuler(MSN2, RSN1.post(t)*We12+RSN2.post(t)*We22+MSN1.post(t-1)*Wi, t);
    end
end

% plot results
plotNeurons(RSN1, RSN2, MSN1, MSN2)