%% Initialize Workspace

%Clear Workspace
clearvars

%Close Windows
close all

%Set Main Directory
code_dir = fileparts(mfilename('fullpath'));
cd(code_dir)
addpath(genpath(code_dir));

%Set Figure Directory
fig_dir = fullfile(code_dir,'Figures');
cd(fig_dir)

%% Plot Bifurcation Diagram

fig = openfig('Bifurcation Diagram.fig');
set(gca,'FontSize',20);
set(gca,'box','off','color','none')
set(gca,'TickDir','out');
xlim([-0.5 5]); ylim([-80 60]);
xticks([0 2 4]); yticks([-50 0 50]);
xlabel('Transduction Current I (µA/cm^2)'); ylabel('Membrane Potential V (mV)');

%% Save Figure

saveas(gcf,'Bifurcation Diagram.svg');