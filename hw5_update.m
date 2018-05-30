%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
% Homework 5
% @author Cristopher Garduno Luna [3970217]
% @date   Spring 2018, PSY265: Computational Neuroscience
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~%
%% Problem (1)
clear; close all;

% Current injection setup, let T = 2000
% W: network input weights  Wi: MSN-MSN inhibition weights
% We1: RSN --> MSN1 weights We2: RSN --> MSN2 weights
W = 125; We1 = 250; We2 = 200; Wi = -30; onset = 10;
I = [zeros(1,onset),W*ones(1,2000-onset)];

% Initialize RSN and project onto MSN
RSN  = Neuron('rsn'); eulerIzhikevich(RSN, I); 
MSN1 = Neuron('msn'); eulerIzhikevich(MSN1,RSN.post*We1);

%% Plot Results for (1)
subplot(3,1,1); plot(1:1000, RSN.v(1:1000)); xlabel('Time (ms)'); % plot 1
ylabel('Voltage (mV)'); title('RSN: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2); 
subplot(3,1,2); plot(1:1000, MSN1.v(1:1000)); xlabel('Time (ms)'); % plot 2
ylabel('Voltage (mV)'); title('MSN1: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
subplot(3,1,3); plot(1:1000, RSN.post(1:1000)); xlabel('Time (ms)'); % plot 3
ylabel('PSP (mV)'); title('Integrated Alpha Function');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

%% Problem (2)
clear; close all; % see code description in setup for (1)
W = 125; We1 = 250; We2 = 200; Wi = -30; onset = 10;
I = [zeros(1,onset),W*ones(1,2000-onset)];
RSN  = Neuron('rsn'); eulerIzhikevich(RSN, I); 
MSN1 = Neuron('msn'); eulerIzhikevich(MSN1,RSN.post*We1);
MSN2 = Neuron('msn'); eulerIzhikevich(MSN2,RSN.post*We2);

%% Plot Results for (2)
subplot(3,1,1);
plot(1:1000, RSN.v(1:1000));
xlabel('Time (ms)'); ylabel('Voltage (mV)');
title('RSN: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
subplot(3,1,2);
plot(1:1000, MSN1.v(1:1000));
xlabel('Time (ms)'); ylabel('Voltage (mV)');
title('MSN1: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
subplot(3,1,3);
plot(1:1000, MSN2.v(1:1000));
xlabel('Time (ms)'); ylabel('Voltage (mV)');
title('MSN2: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);

%% Problem (3)
clc; clear; close all; % see code description in setup for (1)
W = 125; We1 = 250; We2 = 200; Wi = -30; onset = 10;
I = [zeros(1,onset),W*ones(1,2000-onset)];
RSN  = Neuron('rsn'); RSN.eulerIzhikevich(I); 
MSN1 = Neuron('msn'); 
MSN2 = Neuron('msn'); 

% simulate activity on MSN neurons
% params: first current, 2nd neuron type, 2nd neuron weight
MSN1.eulerIzhikevich(RSN.post*We1, 'msn', Wi);
MSN2.eulerIzhikevich(RSN.post*We2, 'msn', Wi);

%% Plot Results for (3)
subplot(3,1,1);
plot(1:1000, RSN.v(1:1000));
xlabel('Time (ms)'); ylabel('Voltage (mV)');
title('RSN: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
subplot(3,1,2);
plot(1:1000, MSN1.v(1:1000));
xlabel('Time (ms)'); ylabel('Voltage (mV)');
title('MSN1: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);
subplot(3,1,3);
plot(1:1000, MSN2.v(1:1000));
xlabel('Time (ms)'); ylabel('Voltage (mV)');
title('MSN2: Voltage across Time');
set(findall(gca, 'Type', 'Line'),'LineWidth',2);