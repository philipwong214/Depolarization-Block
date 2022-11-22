function model = modelBC(model,param)

global k_agar k_plastic sat_agar sat_plastic;

%Extract Parameters
D_air = param(1);
D_drop = param(2);
c_air = param(3);
c_drop = param(4);
k_agar = param(5);
k_plastic = param(6);
sat_agar = param(7);
sat_plastic = param(8);
q_gen = param(9);
delay = param(10);

%Assign Diffusion Coefficient to Air 
specifyCoefficients(model,'Cell',1,'m',0,'d',1,'c',D_air,'a',0,'f',0);

%Assign Diffusion Coefficient to Droplet 
specifyCoefficients(model,'Cell',2,'m',0,'d',1,'c',D_drop,'a',0,'f',q_gen);

%Set initial conditions
setInitialConditions(model,c_air,'Cell',1);
setInitialConditions(model,c_drop,'Cell',2);

%Group boundaries for each type of surface
bound_agar = 4;
bound_plastic = [1 2 3 5 6];
bound_droplet = 7;

%Air-Agarose boundary
applyBoundaryCondition(model,'neumann','Face',bound_agar,'q',@myqafun,'g',@mygafun);

%Air-Plastic boundary
applyBoundaryCondition(model,'neumann','Face',bound_plastic,'q',@myqpfun,'g',@mygpfun);

%Top of Droplet
applyBoundaryCondition(model,'neumann','Face',bound_droplet,'q',0,'g',0);

%Define Boundary Conditions
    function bcMatrix  = myqafun(location,state)
        bcMatrix = state.u;
        bcMatrix(bcMatrix < sat_agar) = 0;
        bcMatrix(bcMatrix >= sat_agar) = k_agar;
    end

    function bcMatrix  = mygafun(location,state)
        bcMatrix = state.u;
        bcMatrix(bcMatrix < sat_agar) = 0;
        bcMatrix(bcMatrix >= sat_agar) = k_agar*sat_agar;
    end

    function bcMatrix  = myqpfun(location,state)
        bcMatrix = state.u;
        bcMatrix(bcMatrix < sat_plastic) = 0;
        bcMatrix(bcMatrix >= sat_plastic) = k_plastic;
    end

    function bcMatrix  = mygpfun(location,state)
        bcMatrix = state.u;
        bcMatrix(bcMatrix < sat_plastic) = 0;
        bcMatrix(bcMatrix >= sat_plastic) = k_plastic*sat_plastic;
    end
end