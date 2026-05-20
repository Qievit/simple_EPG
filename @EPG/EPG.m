%% EPG for constant CPMG timing
% Sequence with 1 excitation pulse (at the start) and multiple refocussing
% pulses. Implementation of decoupled phase matrix and k-values (but that doesnt add anything atm).
% 
% Based on:  Weigel, 2014.  DOI 10.1002/jmri.24619
% Uses full F-(k) domain
%% Input
%
%   flip_angles : [deg] vector of flip angles of RF-pulses after excitation
%   rf_duration : [s] duration of RF pulse, same for every pulse
%   phases      : [rad] vector of phases of RF-pulses after excitation
%   tau         : [s] time between pulses
%   TR          : [s] repetition time, determines starting population
%   relaxation  : 0 or 1 - if relaxation will be modelled
%   movement    : 0 or 1 - if movement will be modelled
%   medium      : what magnetic properties(T1/T2/cond). Currently implemented:
%                 "grey matter" "white matter" "blood" "water" 
%   plotting    : 0 or 1 - plot or not
%
%% Output
%s
%   echos               : vector with F0 populations   
%   SAR                 : [W/kg] estimated SAR 
%   time_est            : [s] estimated time taken using tau and # pulses
%   state_evolution_F   : State evolution of statesXechos before next pulse 
%   state_evolution_Z   : State evolution of statesXechos before next pulse 
classdef EPG < matlab.mixin.SetGet
    properties
        flip_angles
        rf_duration
        flip_phases
        tau
        displacement
        TR
        medium
        state_matrix
        F_states
        Z_states
        T1
        T2
        conductivity
        M0
        gamma
        dt
        dephasing
        
    end
    methods 
        function obj = EPG(a,b,c)
            if nargin == 0
                obj.TR          = 9000e-3;
                obj.rf_duration = 3e-3;
                obj.medium      = "blood"; 
            else
                obj.TR          = a;
                obj.rf_duration = b;
                obj.medium      = c;
            end

            if strcmp(obj.medium,"grey matter") % GM at 37 cels Stanisz et al 2005 DOI 10.1002/mrm.20605
                obj.T2              = 99e-3; % [s] 
                obj.T1              = 1820e-3; % [s] 
                obj.conductivity    = 0.47; % [S/m] McCann et al 2019 doi: 10.1007/s10548-019-00710-2
            elseif strcmp(obj.medium,"white matter") % WM at 37 cels Stanisz et al 2005 DOI 10.1002/mrm.20605
                obj.T2              = 69e-3;% [s]
                obj.T1              = 275e-3; % [s] O'Reilly & Webb 2021  doi:10.1002/mrm.29009
                obj.conductivity    = 0.2167; % [S/m] McCann et al 2019 doi: 10.1007/s10548-019-00710-2
            elseif strcmp(obj.medium,"blood") % blood at 37 cels Stanisz et al 2005 DOI 10.1002/mrm.20605
                obj.T2              = 275e-3; % [s]
                obj.T1              = 1932e-3; % [s]
                obj.conductivity    = 0.5737; % [S/m] McCann et al 2019 doi: 10.1007/s10548-019-00710-2
            elseif strcmp(obj.medium,"water") % degassed, pure water at 25 cels
                obj.T2              = 1500e-3; % [s] O'Reilly & Webb 2021  doi:10.1002/mrm.29009 (CSF)
                obj.T1              = 4000e-3; % [s] at 1.5T https://mri-q.com/why-is-t1--t2.html
                obj.conductivity    = 1.2e-6; % [S/m] Francis 2008 https://doi.org/10.1021/jp8037686
            elseif strcmp(obj.medium,"air") % try to remove signal to approach actual situation
                obj.T2              = 1e-3; % make Mt decay immediately
                obj.T1              = 1e6; % make Mz never recover
                obj.conductivity    = 3.77e-7; % [-] https://www.researchgate.net/publication/264983603_Magnetic_field_impact_on_the_high_and_low_Reynolds_number_flows
            elseif strcmp(obj.medium,"fat") % estimated w subcutaneous fat https://radiopaedia.org/articles/bone-marrow
                obj.T2              = 70e-3; %[s] at 1.5T https://mri-q.com/why-is-t1--t2.html
                obj.T1              = 250e-3; %[s] at 1.5T https://mri-q.com/why-is-t1--t2.html
                obj.conductivity    = 0.12; % [S/m] Kangasmaa et al  2025 https://doi.org/10.1002/bem.22541
            else
                warning(obj.medium +" has not been implemented, using dummy")
                obj.T2              = 10000e-3; % [s] at 1.5T https://mri-q.com/why-is-t1--t2.html
                obj.T1              = 10000e-3; % [s] at 1.5T https://mri-q.com/why-is-t1--t2.html
                obj.conductivity    = 1.2e-6; % [S/m] Francis 2008 https://doi.org/10.1021/jp8037686
            end

            obj.M0           = 1*(1-exp(-obj.TR/obj.T1));

            % Medium information
            obj.gamma = 42.58e6/(2*pi) * 3; % [Hz] at 3T

            obj.state_matrix = [0 0; 0 0; obj.M0 0];
            obj.F_states     = [flipud(obj.state_matrix(1,:)');obj.state_matrix(2,2:end)'];
            obj.Z_states     = [flipud(obj.state_matrix(3,:)');conj(obj.state_matrix(3,2:end))'];
        end

        function [] = report(obj)
            % checking EPG
            disp(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>")
            fprintf('Maximum population F: %f \n',max(abs(obj.F_states),[],'all'))
            fprintf('Maximum population Z: %f \n',max(abs(obj.Z_states),[],'all'))

            fprintf('Final population F0: %f \n',obj.state_matrix(1,1))
            
            % fprintf('Total time taken           : %4.2f [s] \n',time_est)
            % fprintf('Duty cycle D               : %2.1g [%%] \n',((n_echos+1)*rf_duration) / (tau*(n_echos+1)))
            % fprintf('rough SAR (square pulse)   : %2.2g [W/kg]\n', SAR) 
            disp("<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<")
           
        end

        shifting(obj,n)
        [T1, T2, cond] = material_parameters(obj,medium)

        rf_flip(obj,angle,phase)

        plot_states(obj)
        plot_population(obj)
        minimize(obj)
        record(obj)
    end
end