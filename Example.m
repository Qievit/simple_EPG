%% Spin echo test

se = EPG(); % initialize the simulation

se.rf_flip(90,90); % excitation pulse with a 90 degree phase shift

se.record(); % record the F and Z states at this moment

se.shifting(); % Dephasing

se.record();

% "Readout" with 20 refocussing pulses
for i = 1:20

    se.rf_flip(180,0);
    se.shifting();
    se.record();
    se.shifting();
    se.record();
end

% Visualization
se.plot_population
se.plot_states

%% Hyperecho test
clear;
hyper = EPG();

% Disregard 'steady state' assumption
hyper.state_matrix(3,1) = 1;
hyper.Z_states(2,1) = 1;

angles = [90 ones(1,50)*0 ones(1,50)*20 ones(1,20)*0 ones(1,50)*20 ones(1,20)*0 ones(1,50)*20 ones(1,20)*0 ones(1,50)*20 180 ones(1,50)*-20 ones(1,20)*0 ones(1,50)*-20 ones(1,20)*0 ones(1,50)*-20 ones(1,20)*0 ones(1,50)*-20 ones(1,50)*0];

for a = angles
    hyper.rf_flip(a,90)
    hyper.shifting();
    hyper.record();
end

hyper.plot_states
hyper.plot_population
% As can be seen, the hyperecho fully refocusses in the absence of
% relaxation

% Since the initial excitation pulse does not have the 90 degree phase
% shift, the echo is imaginary
