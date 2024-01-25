
A = 4;      %   Applied Torque in Nm
J = 1;      %   Inertia in kg*m^2      
B = 1;      %   Damping Coeff in Nm/(rad/s)
w_0 = 1;    %   Initial Angular Velo in rad/s

simout = sim('Simulink_Test.slx');      %   runs simulation

t = simout.tout;                        %   captures time variable
pos = simout.angular_position.Data;     %   captures position var
velo = simout.angular_velocity.Data;    %   captures velocity var
acc = simout.angular_acceleration.Data; %   captures acceleration var

hold on
plot(t,pos,"b")
plot(t,velo,"k")
plot(t,acc,"r")
hold off