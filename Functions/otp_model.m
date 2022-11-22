%% Model for the odorant transduction process  

function [dydt,I,v] = otp_model(t,y,stimt,stim,mode,variability)

    stim = interp1(stimt,stim,t);
        
    br = 0.02; 
    dr = 10; 
    gamma = 1.5; 
    a1 = 29.3; 
    b1 = 14.7; 
    a2 = 146.1;
    b2 = 117.2;
    a3 = 8.508; 
    b3 = 0.296;
    kappa = 8841;
    c = 0.06546;
    
    if variability == 1
        Imax = 62.13*normrnd(1,0.1);
    else
        Imax = 62.13;    
    end
          
    if mode == 1        
        x1 = y(1);
        x2 = y(2);
        x3 = y(3);
        uh = y(4);
        duh = y(5);
    elseif mode == 2
        x1 = y(:,1);
        x2 = y(:,2);
        x3 = y(:,3);
        uh = y(:,4);
        duh = y(:,5); 
    end

    x1(x1<0) = 0;
    x2(x2<0) = 0;
    x3(x3<0) = 0;
    
    if t == 0
        v = 0;
        I = 0;
    else
        v = uh + gamma*duh;
        v = real(v);
        v(v<0) = 0;
        I = Imax*x2./(x2 + c^1);
    end
    
    %System of ODEs
    d_x1 = br*v.*(1-x1) - dr*x1;
    d_x2 = a2*x1.*(1-x2) - b2*x2 - kappa*((x2.*x3).^(2/3));
    d_x3 = a3*x2 - b3*x3;
    d_uh = duh;
    d_duh = -2*a1*b1.*duh + a1*a1*(stim-uh);    
    
    %Collect Equations
    dydt = [d_x1; d_x2; d_x3; d_uh; d_duh];      
end