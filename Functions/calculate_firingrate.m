%% Function for calculating the PSTH

function [t_psth,r_psth,t_out] = calculate_firingrate(t,v)

t_out = cell(length(v),1);

%Compute spike times 
for i = 1:length(v)
    temp = v{i}(:,1);
    [~,out1] = spike_times(temp,-8);
    t_out{i} = t{i}(out1);  
end

spiketimes = cell2mat(t_out);
t_max = t{1}(end);
binwidth = 100;

%Compute PSTH
r_psth = psth(spiketimes,binwidth,1000,length(v),t_max);
t_psth = 0.001*linspace(0,t_max,length(r_psth));
t_psth = t_psth + binwidth*0.001;

end