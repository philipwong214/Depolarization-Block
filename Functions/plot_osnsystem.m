%% Script for visualizing OSN simulation results (not used for manuscript figures)

% Set start time for plotting
t_start = 0;

%% Plot Figure

% Plot Odor Concentration
figure('Position',[10 10 1000 800]);
subplot(3,1,1)
plot(stim.t,stim.x,'r','Linewidth',2); xticks([]);
ylabel('Odor Concentration (uM)');
xlim([t_start stim.t(end)]);

%Plot Raster plot for simulation 
subplot(3,1,2)
xlim(1000*[t_start stim.t(end)]);
plotSpikeRaster(sim.spike_times,'PlotType','vertline','RelSpikeStartTime',0.01,'XLimForCell',[0 1000*stim.t(end)]);
ylabel('Trial')
set(gca,'XTick',[]);

%Plot PSTH for data and simulation
subplot(3,1,3)
hold on
plot(stim.t,stim.y,'Color',[0.3 0.3 0.3],'Linewidth',2);
plot(sim.yt,sim.y,'b','Linewidth',2); 
legend('Experiment','Simulation');

if max(sim.y) < 20
    ylim([0 20]);
else
    ylim([0 min(130,1.2*max(sim.y))]);
end
xlim([t_start stim.t(end)] + start_time);
xlabel('Time (s)');
ylabel('Firing Rate (Hz)');

%% Save Figure and Data

saveas(gcf,strcat(name,'.jpg')); 
save(strcat(name,'.mat'),'stim','sim');