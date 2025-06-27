%% Valve Lift Profile Plotting (Compatible with older MATLAB versions)
clc; clear; close all;
% Valve timing parameters (in degrees)
% Intake valve
intake_open = 10;       % IVO (Intake Valve Open)
intake_close = 230;     % IVC (Intake Valve Close)
intake_duration = intake_close -intake_open;

 
% Exhaust valve
exhaust_open = 470;     % EVO (Exhaust Valve Open) 
exhaust_close = 710;    % EVC (Exhaust Valve Close)
exhaust_duration = exhaust_close -exhaust_open;
 
% Maximum valve lift (mm)
max_lift = 10;
 
% Crankshaft angle range (0-720° for 4-stroke cycle)
theta = linspace(0, 720, 1000);
 
% Initialize lift arrays
intake_lift = zeros(size(theta));
exhaust_lift = zeros(size(theta));
 
% Calculate valve lifts using sinusoidal profile
for i = 1:length(theta)
    % Wrap angle to 0-720 range
    current_angle = mod(theta(i), 720);
    
    % Intake valve profile
    if current_angle >=intake_open && current_angle <= intake_close
       intake_lift(i) = (max_lift/2)*(1 - cos(2*pi*(current_angle -intake_open)/intake_duration));
    end
    
    % Exhaust valve profile
    if current_angle >= (exhaust_open-720) && current_angle <= (exhaust_close-720)
       exhaust_lift(i) = (max_lift/2)*(1 - cos(2*pi*(current_angle - (exhaust_open-720))/exhaust_duration));
    elseif current_angle>= exhaust_open && current_angle <= exhaust_close
       exhaust_lift(i) = (max_lift/2)*(1 - cos(2*pi*(current_angle -exhaust_open)/exhaust_duration));
    end
end
 
%% Plotting
figure('Position', [100, 100, 900, 500]);
plot(theta, intake_lift, 'b-', 'LineWidth', 2);
hold on;
plot(theta, exhaust_lift, 'r-', 'LineWidth', 2);
 
% Add TDC and BDC markers
line([0 720], [0 0], 'Color', 'k', 'LineWidth', 0.5); % Baseline
line([360 360], [0 max_lift+1], 'Color', 'k', 'LineStyle', ':', 'LineWidth', 1);
line([180 180], [0 max_lift+1], 'Color', 'k', 'LineStyle', ':', 'LineWidth', 1);
line([540 540], [0 max_lift+1], 'Color', 'k', 'LineStyle', ':', 'LineWidth', 1);
 
% Label engine cycles
text(90, max_lift+0.5, 'Intake', 'HorizontalAlignment', 'center');
text(270, max_lift+0.5, 'Compression', 'HorizontalAlignment', 'center');
text(450, max_lift+0.5, 'Power', 'HorizontalAlignment', 'center');
text(630, max_lift+0.5, 'Exhaust', 'HorizontalAlignment', 'center');
 
% Label TDC/BDC
text(0, -0.5, 'TDC', 'HorizontalAlignment', 'center');
text(180, -0.5, 'BDC', 'HorizontalAlignment', 'center');
text(360, -0.5, 'TDC', 'HorizontalAlignment', 'center');
text(540, -0.5, 'BDC', 'HorizontalAlignment', 'center');
text(720, -0.5, 'TDC', 'HorizontalAlignment', 'center');
 
% Format plot
title('Valve Lift vsCrankshaft Angle (4-Stroke Cycle)', 'FontSize', 14);
xlabel('Crankshaft Angle(degrees)', 'FontSize', 12);
ylabel('Valve Lift (mm)', 'FontSize', 12);
legend('Intake Valve', 'Exhaust Valve', 'Location', 'northeast');
grid on;
xlim([0 720]);
ylim([-1 max_lift+4]);
set(gca, 'FontSize', 12, 'XTick', 0:90:720); % Replaced xticks with set(gca,'XTick')
 
% Highlight valve overlap period
overlap_start = intake_open;
overlap_end = exhaust_close-720;
patch([overlap_startoverlap_start overlap_end overlap_end],[0 max_lift+1 max_lift+1 0], 'y', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
%text(mean([overlap_start, overlap_end]), max_lift+0.2,...
     %'Valve Overlap', 'HorizontalAlignment'