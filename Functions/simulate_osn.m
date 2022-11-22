%% Script for simulating OSN

%This script contains the OSN model, which predicts the Or42b OSN firing rate in response to stimulus by
%ethyl butyrate. 

%Start time of simulation
start_time = 0;    

%Set condition to simulate
switch group 
    case 1
        %Stimulus Pattern (1-3)
        name = test.pattern{condition};
        stim.t = data.pattern{condition}(:,1);
        stim.x = data.pattern{condition}(:,2);
        stim.y = data.pattern{condition}(:,3);
        
    case 2
        %Step Function (1-12)
        name = test.step{condition};
        
        end_time = 30;       
        if data.step{condition}(end,1) < end_time 
            idx_end = length(data.step{condition});
        else
            [~,idx_end] = min(abs((data.step{condition}(:,1) - end_time)));
        end
            
        stim.t = data.step{condition}(1:idx_end,1);
        stim.x = data.step{condition}(1:idx_end,2);
        stim.y = data.step{condition}(1:idx_end,3);
        
        stim.x(stim.x < 0.3*max(stim.x)) = 0; %Remove small pressure values
               
    case 3
        %Hysteresis Pattern (1-3)
        name = test.hysteresis{condition};
        stim.t = data.hysteresis{condition}(:,1);
        stim.x = data.hysteresis{condition}(:,2);
        stim.y = data.hysteresis{condition}(:,3);
                           
        stim.x = stim.x - stim.x(1);
        interval = stim.t(2) - stim.t(1);
        pad_length = 1e5;
        
        stim.t = [interval*(1:pad_length-1)'; (stim.t + interval*pad_length)];
        stim.x = [zeros(pad_length-1,1); stim.x];
        stim.y = [zeros(pad_length-1,1); stim.y];        
                                               
    case 4
        %Pick Trajectory Replay
        name = test.trajectory{condition};
        stim.t = data.trajectory{condition}(:,1);
        stim.x = data.trajectory{condition}(:,2);
        stim.y = data.trajectory{condition}(:,3);

        end_time = 90;  
        
        [~,idx_start] = min(abs(stim.t - start_time));
        [~,idx_end] = min(abs(stim.t - end_time));
                
        stim.t = stim.t(idx_start:idx_end);
        stim.x = stim.x(idx_start:idx_end);
        stim.y = stim.y(idx_start:idx_end);
        
        %Add padding to stimulus (to allow time for OSN to acclimate to odor concentration, as in actual experiments)
        interval = stim.t(2) - stim.t(1);
        pad_length = 1e5;
        pad_intensity = mean(stim.x(1:pad_length));
        
        stim.t = [interval*(1:pad_length-1)'; (stim.t + interval*pad_length)];
        stim.x = [0.05*pad_intensity*ones(pad_length-1,1); stim.x];
        stim.y = [zeros(pad_length-1,1); stim.y];               
end

%Downsample data (to speed up simulation)
samplerate = 200;
new_stim.t = downsample(stim.t,samplerate);
new_stim.x = downsample(stim.x,samplerate);
new_stim.y = downsample(stim.y,samplerate);

%Initialize variables
conc = cell(1,n_trials);
sim.V = cell(1,n_trials);
sim.Vt = cell(1,n_trials);
sim.I = cell(1,n_trials);
sim.It = cell(1,n_trials);

%Find timespan for data
tspan_otp = [stim.t(1),stim.t(end)];

%Apply liquid to air conversion
stim_ppm = new_stim.x*29.18; %Liquid -> Air -> ppm : 116160ppm/M * 1M/10^6uM * 1/3.38978 = 29.18

%Simulate n trials
for j = 1:n_trials
    
    %Simulate odorant transduction process
    y0 = [0 0 0 0 0]; %Initial conditions
    [t_otp,Y] = ode15s(@(t,y) otp_model(t,y,new_stim.t,stim_ppm,1,variability),tspan_otp,y0);
    [~,sim.I{j},v] = otp_model(t_otp,Y,new_stim.t,stim_ppm,2,variability);
    
    %Convert Units and resample signal
    tspan_osn = 1000*tspan_otp;
    It = 1000*t_otp;    
    sim.It{j} = 1000*new_stim.t;
    sim.I{j} = interp1(It,sim.I{j},sim.It{j});
    
    %Add noise to transduction current
    sim.I{j} = sim.I{j} + normrnd(0,0.33,size(sim.I{j})); 
    sim.I{j}(sim.I{j}<0) = 0;
    
    %Simulate spike generation process
    y0 = [-60;0;0.4]; %Initial conditions
    [sim.Vt{j},sim.V{j}] = ode45(@(t,y) sg_model(t,y,sim.It{j},sim.I{j}),tspan_osn,y0);
end

%Calculate PSTH 
[t_psth,sim.y,sim.spike_times] = calculate_firingrate(sim.Vt(:),sim.V(:));
sim.yt = t_psth + start_time;
sim.spike_times = cellfun(@transpose,sim.spike_times,'UniformOutput',false);

