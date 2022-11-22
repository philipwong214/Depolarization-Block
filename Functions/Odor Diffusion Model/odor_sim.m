function output = odor_sim(model,condition,param,time)

%"Reference" Source Concentration
base_conc = 250;

params = param;

switch condition
    case 'EtB1uM'
        sim_conc = 0.001;
    case 'EtB5uM'
        sim_conc = 0.005;
    case 'EtB10uM'
        sim_conc = 0.01;      
    case 'EtB50uM'
        sim_conc = 0.05;        
    case 'EtB100uM'
        sim_conc = 0.1;
    case 'EtB1mM'
        sim_conc = 1;
    case 'EtB10mM'
        sim_conc = 10;
    case 'EtB25mM'
        sim_conc = 25;
    case 'EtB30mM'
        sim_conc = 30;
    case 'EtB50mM'
        sim_conc = 50;
    case 'EtB75mM'
        sim_conc = 75;        
    case 'EtB100mM'
        sim_conc = 100;
    case 'EtB125mM'
        sim_conc = 125;  
    case 'EtB250mM'
        sim_conc = 250;
    case 'EtB500mM'
        sim_conc = 500;
end

%Rescale Source Concentration to Simulated Condition
params(4) = params(4)*sim_conc/base_conc;
params(9) = params(9)*sim_conc/base_conc;

delay = params(10);
model = modelBC(model,params);
t_delay = [time (time(end)+1):(time(end)+delay)];
output = solvepde(model,t_delay);    
end
