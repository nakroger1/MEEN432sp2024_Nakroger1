p_0 = 0;            %initial angular position [rad]
W_0 = [10,0];       %initial angular velocity [rad/s]
J1 = [100,0.01] ;   %rotational inertia [kg-m^2]
B = [10,0.1];       %damping coefficient [N-m-s/rad]
AT = [0,100];       %constant applied torque [N-m]
dT = [0.001,0.1,1]; %time step for fixed solvers [s]


for v = 1:length(dT)
    figure;
    time_step = dT(v);
    plot_num = 1;
    tic

    for z = 1:length(W_0) % iterate through values of initial ang velo
        w_0 = W_0(z);

        for y = 1:length(J1) % iterate through values of inertia 
            j = J1(y);
        
            for x = 1:length(B) % iterate through values of damping
                b = B(x);

                for w = 1:length(AT)
                    T = AT(w);
                
                    simout = sim("project1_demo.slx","Solver","ode1","FixedStep",string(time_step));
                    time = simout.tout;
                    ang_velo = simout.ang_velo.Data;
                    subplot(4,4,plot_num);
                    
                    hold on
                    plot(time,ang_velo);
                    %plot(time,time)
                    hold off
                    title(['T=',num2str(T),' B=',num2str(b),' J=',num2str(j),' w_0=',num2str(w_0)]);

                    plot_num = plot_num+1;
                end
            end
        end
    end
    cpu_time = toc;
    sgtitle(['Euler: step = ',num2str(time_step)," CPU Time = ", num2str(cpu_time)])
end
      
%Here down is just a copy to make sure the iterations work, focus on whats
%above this point

figure;
plot_num = 1;
for z = 1:length(W_0) % iterate through values of initial ang velo
    w_0 = W_0(z);

    for y = 1:length(J1) % iterate through values of inertia 
        j = J1(y);
        
        for x = 1:length(B) % iterate through values of damping
            b = B(x);

            for w = 1:length(AT)
                T = AT(w);

                simout = sim("project1_demo.slx");
                time = simout.tout;
                ang_velo = simout.ang_velo.Data;
                subplot(4,4,plot_num);
                %hold on
                plot(time,ang_velo);
                plot(time,time)
                hold off
                title(['T=',num2str(T),' B=',num2str(b),' J=',num2str(j),' w_0=',num2str(w_0)]);

                plot_num = plot_num+1;
        
            
            end
        end
    end
end
      
sgtitle('idc');