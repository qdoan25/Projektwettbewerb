% Simulationen fuer Projektwettbewerb ERT SS2019
% 
% Diese Datei dient als Template fuer die Wettbewerbsaufgabe.
% 
% Bitte Verwenden Sie in Ihrer Simulink-Datei keine Umlaute oder 
% Sonderzeichen. Ansonsten kann es bei der Abgabe Probleme mit dem
% Zeichencode geben.
clc
clear all
close all

%% Parameter 
% Herstellerdaten
g = 9.81;       %Erdanziehung in m/s^2

%Wippe
m_w = 10;       % Masse Wippe in kg 
k_w = 2;        % Federsteifigkeit in Nm/rad 
d_w = 0.4;      % Daempfung in Nm*s/rad
L = 1.2;        % Laenge Wippe in m
b = 0.02;       %Breite Wippe in m
J_w = 1/12*m_w*(b^2+L^2);   %Traegheitmoment Wippe 
alpha_wMax = pi/6;          %Maximaler Drehung der Wippe

%Segway
L_s = 0.15; % Hoehe Segway in m
m_s = 0.8; % Masse Segway in kg
Mmax=0.2; % Maximales Motordrehmoment in Nm
wMmax=17.8; % Maximale Motorumdrehungszahl in rad/s
Pmax=wMmax*Mmax; % Maximale elektrische Motor-Leistung (Watt)
umax=100; % Maximale Powerstufe des Motors in Prozent (gross)

%Rad
m_r = 0.048; % Masse beider Raeder in kg
f_r = 7.2e-3; %Rollwiderstandskoeffizient
r = 0.041; %Radradius in m
J_r = 1/2*m_r*r^2; %Traegheitsmoment Rad 

% Stoerung
Stoerung1 = 0 %.1; % .1 = Stoerung ein, 0 = aus
stoerungNoisePower = 1;
stoerungSeed_1 = round((1e4-1)*rand(1));

% Anfangsbedingungen
%Wippe 
alpha_wStart = -pi/6; % Startposition (Winkel) der Wippe
alpha_w_dotStart = 0; % Startgeschwindigkeit der Wippe

%Segway
alpha_s_dotStart =  0; % Startgeschwindigkeit (Winkel) der Wippe
xStart = 0.5; % Startposition des Roboters
x_dotStart = 0; % Startgeschwindigkeit des Roboters


%% Initialisierung des Reglers

reglerInit; %Regler

IC = [alpha_wStart alpha_w_dotStart xStart x_dotStart alpha_sStart alpha_s_dotStart]; %Vektor mit Anfangsbedingungen, alpha_sStart soll in reglerInit initialisiert werden
%% Simulation
tEnd = 60; %in Sekunden
tSim = [0 tEnd]; % Zeitintervall
tStep = 1e-4;    % Schrittweite des ODE-solvers

sim('roboTemplate',tSim);
disp('Simulation beendet')

%% ss
close all

alpha_wSim = yout(:,1);
alpha_wdotSim = yout(:,2);
xSim = yout(:,3);
xdotSim = yout(:,4);
alpha_sSim = yout(:,5); 
alpha_sdotSim = yout(:,6);
xsollSim = yout(:,7); 
xdiffSim = yout(:,8); 

figure('Name','Zustaende')
subplot(3,2,1)
hold all
plot(tout,180/pi*alpha_wSim)
title('Drehung Wippe in Grad')
xlabel('time in s')
subplot(3,2,2)
hold all
plot(tout,alpha_wdotSim)
title('Drehgeschwindigkeit Wippe in rad/s');
xlabel('time in s')
subplot(3,2,3)
hold all
plot(tout,xSim)
title('Position Segway in m');
xlabel('time in s')
subplot(3,2,4)
hold all
plot(tout,xdotSim)
title('Geschwindigkeit Segway in m/s');
xlabel('time in s')
subplot(3,2,5)
hold all
plot(tout,180/pi*alpha_sSim)
title('Drehung Segway in Grad')
xlabel('time in s')
subplot(3,2,6)
hold all
plot(tout,alpha_sdotSim)
title('Drehgeschwindigkeit Segway in rad/s')
xlabel('time in s')

figure('Name','Referenzposition')
hold all
grid on
plot(tout,xSim)
plot(tout,xsollSim)
legend('Position', 'Referenzposition')
title('Position Segway und Refernzpositions')
xlabel('time in s')
ylabel('in m')

figure('Name','Abweichung Position')
hold all
grid on
plot(tout,xdiffSim)
title('Differenz zur Referenzposition')
xlabel('time in s')
ylabel('Differenz in m')


J = xdiffSim'*xdiffSim;