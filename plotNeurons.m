% plotNeurons: plots voltage of neurons
%
% @params: each param is a neuron struct
function plotNeurons(RSN1, RSN2, MSN1, MSN2)
    subplot(4,1,1); plot(1:2000, RSN1.v(1:2000));
    xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('RSN1 Voltage');
    set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
    subplot(4,1,2); plot(1:2000, RSN2.v(1:2000));
    xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('RSN2 Voltage');
    set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
    subplot(4,1,3); plot(1:2000, MSN1.v(1:2000));
    xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('MSN1 Voltage');
    set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
    subplot(4,1,4); plot(1:2000, MSN2.v(1:2000));
    xlabel('Time (ms)'); ylabel('Voltage (mV)'); title('MSN2 Voltage');
    set(findall(gca, 'Type', 'Line'),'LineWidth',1.5);
end