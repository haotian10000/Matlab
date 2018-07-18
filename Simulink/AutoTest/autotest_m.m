clc;
clear all;
%{
model setting
%}
step_size = 0.01;
stop_time = 0.16;
%{
autotest script
%}
t = (0:step_size:stop_time)'; 
u(:,1) = ones(length(t), 1);
u(:,2) = [zeros(size(t))];
simout = sim(gcs,'SolverType', 'Fixed-step', ...
    'Solver', 'ode4', ...
    'FixedStep', num2str(step_size),...
    'StopTime', num2str(stop_time),...
    'LoadExternalInput', 'on');

%{
plot figure    
%}
polt_line = 4;
subplot(polt_line,1,1);
stairs(get(simout, 'tout'), u(:,1));
xlabel('time(s)');
ylabel('Enable');
subplot(polt_line,1,2);
stairs(get(simout, 'tout'), u(:,2));
xlabel('time(s)');
ylabel('Reset');
subplot(polt_line,1,3);
yout = simout.get('yout');
stairs(get(simout, 'tout'), yout(:,1));
xlabel('time(s)');
ylabel('Count1');
subplot(polt_line,1,4);
yout = simout.get('yout');
stairs(get(simout, 'tout'), yout(:,2));
xlabel('time(s)');
ylabel('Count2');