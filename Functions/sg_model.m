%% Model for the spike generation process

function dydt = sg_model(t,y,It,I)

   I = interp1(It,I,t);
   
   scale = 125; 
   g_k = 3; 
   g_na = 20.6; 

   e_na = 60; 
   e_k = -85; 
   e_l = -83; 
   g_l = 0.013; 

   v = y(1);
   h = y(2);
   hs = y(3);
      
   a0 = 0.8158;
   a1 = -3.8768;
   a2 = 6.8838;
   a3 = -4.2079;
   n = a0 + a1*h + a2*h^2 + a3*h^3;
   
   if n<0
       n = 0;
   elseif n>1
       n = 1;
   end
   
   m_inf = 1 / (1 + exp(-(v + 30.0907) / 9.7264));
   m = m_inf;

   leak_current = g_l * (v - e_l);
   sodium_current = g_na * (v - e_na) * m^3 * h * hs;
   potassium_current = g_k * n^3 * (v - e_k);

   total_current = -leak_current - sodium_current - potassium_current;

   h_inf = 1 / (1 + exp(-(v + 54.0289) / (-10.7665)));

   a = 0.00050754 * exp(-0.063213 * v);
   b = 9.7529 * exp(0.13442 * v);
   tau_h = 0.4 + 1 / (a + b);

   hs_inf = 1 / (1 + exp(-(v + 55.8) / (-4.8)));
   tau_hs = 20 + 160 / (1 + exp((v + 47.2) / 1));
   
   %System of ODEs   
   dv = I + total_current;
   dh = -(h - h_inf) / tau_h;
   dhs = -(hs - hs_inf) / (tau_hs * scale);
   
   %Collect Equations  
   dydt = [dv;dh;dhs]; 
end