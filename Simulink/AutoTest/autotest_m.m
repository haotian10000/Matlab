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
t = [0:step_size:stop_time]';
u(:,1) = ones(length(t), 1);
u(:,2) = [zeros(8,1);ones(5,1);zeros(length(t)-13, 1)];
simout = sim(gcs,'SolverType', 'Fixed-step', ...
    'Solver', 'ode4', ...
    'FixedStep', num2str(step_size),...
    'StopTime', num2str(stop_time),...
    'LoadExternalInput', 'on');

%{
plot figure    
%}
subplot(3,1,1);
stairs(get(simout, 'tout'), u(:,1));
xlabel('time(s)');
ylabel('Enable');
subplot(3,1,2);
stairs(get(simout, 'tout'), u(:,2));
xlabel('time(s)');
ylabel('Reset');
subplot(3,1,3);
yout = simout.get('yout');
stairs(get(simout, 'tout'), get(simout, 'yout'));
xlabel('time(s)');
ylabel('Count');
