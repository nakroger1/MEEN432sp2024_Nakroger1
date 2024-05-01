test_position = [];
test_speed = [];

for x = -200:1100
    if x >= 90 && x <= 810
        test_speed = [test_speed, 600];
    else
        test_speed = [test_speed,20];
    end
    test_position = [test_position, x];
end


% Parameters
radius = 200;           % Radius of curved sections
straight_length = 900;  % Length of straightaways
track_width = 7.5;       % Width of the track
car_width = 20;    % Width of the rectangle
car_height = 10;   % Height of the rectangle

x_straight1 = [];
y_straight1 = [];
x_curve1 = [];
y_curve1 = [];
x_straight2 = [];
y_straight2 = [];
x_curve2 = [];
y_curve2 = [];


% generate straights for track 
for a = 0:straight_length/8
    x_straight1 = [x_straight1,8*a];
    y_straight1 = [y_straight1,0];

    x_straight2 = [x_straight2, straight_length - 8*a];
    y_straight2 = [y_straight2, 2*radius];
end

% generate curves for track
for b = 0:180
    x_curve1 = [x_curve1,radius*cosd(b-90) + straight_length];
    y_curve1 = [y_curve1,radius*sind(b-90) + radius];

    x_curve2 = [x_curve2,radius*cosd(b+90)];
    y_curve2 = [y_curve2,radius*sind(b+90) + radius];
end

% Combine all coordinates to form the complete race track
x_track = [x_straight1, x_curve1, x_straight2, x_curve2];
y_track = [y_straight1, y_curve1, y_straight2, y_curve2];


% Plot the race track
figure;
hold on
plot(x_track, y_track, 'LineWidth', track_width,'Color','k');
hold off
axis equal;
xlabel('X-axis (meters)');
ylabel('Y-axis (meters)');
title('Race Track');
grid on;

%create patch for car
car_vertices = [-car_width/2, -car_height/2; car_width/2, -car_height/2; car_width/2, car_height/2; -car_width/2, car_height/2];
car = patch('Vertices', car_vertices, 'Faces', [1 2 3 4], 'EdgeColor', 'k', 'FaceColor', 'g');

% start animation of line 
animate1 = animatedline('Color','r','LineWidth',1.1);
animate2 = animatedline('Color','r','LineWidth',1.1);

%start simulation
simResult = sim("Proj4_simulink.slx", "StopTime","3600");

time = simResult.tout;
X_driven = simResult.X_driven.Data;
Y_driven = simResult.Y_driven.Data;
Psi_driven = simResult.Psi_driven.Data;


% starts iterating at each track point
for d = 1:length(X_driven)

    vehicle_x = X_driven(d); % x position of patch
    vehicle_y = Y_driven(d); % y position of patch
    vehicle_angle = -Psi_driven(d);

    rotation_matrix = [cos(vehicle_angle), -sin(vehicle_angle); sin(vehicle_angle), cos(vehicle_angle)];
    rotated_vertices = car_vertices * rotation_matrix;

    % Update the position and rotation of the car
    set(car, 'Vertices', rotated_vertices + [vehicle_x, vehicle_y]);


    if ishandle(car)
        set(car, 'Vertices', rotated_vertices + [vehicle_x, vehicle_y]);
    else
        disp('Car object handle is invalid or deleted.');
    end


    % animates tracer lines on rear vertices of car
    trace_x1 = rotated_vertices(1, 1) + vehicle_x;
    trace_y1 = rotated_vertices(1, 2) + vehicle_y;
    trace_x2 = rotated_vertices(4, 1) + vehicle_x;
    trace_y2 = rotated_vertices(4, 2) + vehicle_y;
    addpoints(animate1,trace_x1,trace_y1)
    addpoints(animate2,trace_x2,trace_y2)
    drawnow
end


path.width = track_width;
path.l_st = straight_length;
path.radius = radius;

race = raceStat(X_driven, Y_driven, time, path, simResult);
disp(race)












