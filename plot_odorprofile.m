%% Plot simulated odor profiles and experimentally measured odor profiles for ethyl butyrate (Figure S10C, S10D)

%% Initialize

clearvars
close all 
maindir = mfilename('fullpath');
[maindir,name,ext] = fileparts(maindir);
cd(maindir);
addpath(genpath(maindir));

exp_conditions = {'EtB1mM'; 'EtB10mM'; 'EtB100mM'; 'EtB250mM'};
exp = cell(1,length(exp_conditions));

sim_conditions = {'EtB100uM'; 'EtB1mM'; 'EtB10mM'; 'EtB25mM'; 'EtB50mM'; 'EtB100mM'; 'EtB250mM'; 'EtB500mM'};
sim = cell(1,length(sim_conditions));
sim_full = cell(1,length(sim_conditions));

fig_dir = fullfile(maindir,'Figures');
cd(fig_dir)

%% Import Experimental Data

temp1 = load('EtB Data.txt');

for i = 1:length(exp)
    exp{i} = [temp1(:,1) temp1(:,i+1)];    
end

data{1} = importdata('EB_025M.txt');
data{2} = importdata('EB_05M.txt');
time = cell(1,length(data));
position = 4:10;

for i = 1:length(data)
    time{i} = data{i}(:,1);
    data{i} = data{i}(:,2:end);
end

%% Import Simulations

x_sample = linspace(0,8.5,50);
y_sample = 7;
[x,y,z] = meshgrid(x_sample,y_sample,0.1);
x = x(:);
y = y(:);
z = z(:);
t = 30:1:330;

for i = 1:length(sim)
    filename = strcat(sim_conditions{i},'.mat');
    load(filename);
    sim{i} = interpolateSolution(result,x,y,z,t);
    sim{i} = sim{i}*1000*10^6;
    [~,index] = sortrows(y);
    sim{i} = sim{i}(index,:);
    sim_full = sim{i};
    sim{i} = reshape(sim{i},length(x_sample),length(y_sample),length(t));
    sim{i} = nanmean(sim{i},1);
    sim{i} = squeeze(sim{i});
end

load('odorprofile.mat')

%% Plot Figure S10D

t = t-30; 

figure();
hold on
plot(exp{1}(:,1),exp{1}(:,2),'c--');
plot(exp{2}(:,1),exp{2}(:,2),'g--');
plot(exp{3}(:,1),exp{3}(:,2),'m--');
plot(exp{4}(:,1),exp{4}(:,2),'r--');
plot(t,sim{2},'c')
plot(t,sim{3},'g')
plot(t,sim{6},'m')
plot(t,sim{7},'r')
xlabel('Time (s)'); ylabel('Odor Concentration (uM/L)')
set(gca,'YScale','log'); ylim([0.01 30]);
legend(exp_conditions{1},exp_conditions{2},exp_conditions{3},exp_conditions{4},'Location','EastOutside');
saveas(gcf,'FigureS10D.svg');

%% Plot Figure S10C

start = 2;
interval = 2;
test = 2;
figure();
colors = colormap(parula);
colors = colors(round(linspace(1,length(colors),length(time{test}))),:);
subplot(2,1,1);
hold on

for i = start:interval:length(time{test})
    xi = linspace(position(1),position(end),100);
    yi = interp1(position,data{test}(i,:),xi,'spline');
    plot(xi,yi,'color',colors(i,:),'LineStyle','--');
end

xlabel('Position (cm)'); ylabel('Concentration (uM)'); ylim([0 40]); title('Data');
legend('60s','120s','180s','240s','300s','Location','eastoutside');
subplot(2,1,2);
hold on

for i = start:interval:length(time{test})
    xi = linspace(position(1),position(end),100);
    yi = interp1(position,conc{test}(i,:),xi,'spline');    
    plot(xi,yi,'color',colors(i,:),'LineStyle','-');
end

xlabel('Position (cm)'); ylabel('Concentration (uM)'); ylim([0 40]); title('Simulation');
legend('60s','120s','180s','240s','300s','Location','eastoutside');
saveas(gcf,'FigureS10C.svg');
