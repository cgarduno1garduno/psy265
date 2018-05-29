This code is used to complete Greg's hw 5 for comp neuro.

The `Neuron.m` file contains a class of functions that essentially gives you the ability to initialize/create a neuron of a specified type, and simulate activity of the neuron by specifying an injected current. 

A class consists of properties (attributes) and methods (functions). The default constructor (below) is called whenever a new Neuron object is created. 
```matlab    
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
```

The remaining methods are used for numerical simulation using Euler's method (`eulerIzhikevich`) and to check whether an action potential has occurred (`spikeCheck`).

### Usage
You can initialize a `Neuron` object of type `rsn` called `exampleRSN` in the following way: 
```matlab
exampleRSN = Neuron('rsn');
```
To simulate actvity upon injecting a current `I` into `exampleRSN` we do the following. *Note that the following two lines mean the same thing. You can call a member function of an object either way.*: 
```matlab
eulerIzhikevich(RSN, I);
RSN.eulerIzhikevich(I);
```

To access a property of a `Neuron` object you use `object.property` as follows. *Here we access the voltage of an RSN neuron stored in property `v`*: 
```matlab
RSN.v
```

See `hw5_update.m` for further examples. 
