Supplementary code and data for paper 

"Depolarization block of olfactory sensory neurons adds a new dimension to odor encoding" 
	by David Tadres, Philip H Wong, Thuc To, Jeff Moehlis and Matthieu Louis.

All code for simulations was written in MATLAB by Philip H Wong. 

The subfolder "Data" has a MAT file containing all the data used for simulations of the Or42b OSN in response to ethyl butyrate. 
The data is grouped into 4 categories, simulation of: (1) stimulus patterns used for fitting the OSN model, (2) step functions used to fit the OSN model and construct the dose response curve, 
(3) stimulus patterns used to demonstrate hysteresis, and (4) odor experiences recreated from behavioral replay of real larval trajectories.

The subfolder "Figures" is where the simulation results and figures are saved by default when running the scripts.

The subfolder "Functions" contains functions used to simulate different components of the OSN model. 
Functions for spike counting and for computing the PSTH were downloaded from MATLAB file exchange, with credit to the original authors (see license file). 

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Scripts:

main.m - This script will simulate each condition tested for the Or42b OSN.

plot_bifurcation.m - This script plots the bifurcation diagram shown in Figure 5B (originally generated using XPPAUT).

odor_simulation.m - This script simulates the odor profile for different source concentrations of ethyl butyrate in the arena, allowing us to infer the odor experience of larval trajectories. 

plot_odorprofile.m - This script plots the comparsion of simulated odor gradient with measurements in Figure S10.

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

Acknowledgements:

We thank Jordan Sorokin and Rune W Berg for code used for PSTH calculations and spike counting.









