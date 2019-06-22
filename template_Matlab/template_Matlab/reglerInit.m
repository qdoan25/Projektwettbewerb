%% Initialisierung des Reglers

alpha_sStart = 0.5; % Startposition (Winkel) des Roboters
% Systemmatrizen
A = [0 1 0 0 0 0;...
    9.84 -0.33 -6.9 0.08 -10.85 0;...
    0 0 0 1 0 0;...
    -115.14 -0.01 -0.28 -0.83 108.56 0;...
    0 0 0 0 0 1;...
    -770.27 1e-16 2*10^-15 -5.55 792.07 0];

B = [0;...
    -42.95;...
    0;...
    429.59;...
    0;...
    2931.20];

C = [0 0 1 0 0 0;...
    0 0 0 0 0 1];



% Gewichtungsmatrizen
Q = diag([1 1 1 1 1 1]);
%Q = diag([0.1 0.1 100 0.1 0.1 0.1]);
R = 1;

% Reglerentwurf
K_LQR = lqr(A,B,Q,R);

% Pole ausrechnen
Pole = eig(A-B*K_LQR)

%Wunsch-Pole für Beobachter 
%(sollten links von den Polen des Sys liegen)
%Pole = eig(A-E*K_LQR);

Pole_Beobachter = Pole + [-3;-3;-3;-3;-3;-3;]

% Pole platzieren
E = place(A',C',Pole_Beobachter);
