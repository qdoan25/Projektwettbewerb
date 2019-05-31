%Aufagabe 4.4.1.1

G_z5 = tf([55.55],[1 0 -65.4]);      %Winkel Segway
G_z3 = tf([27.97],[1 0 0.07]);       %=y1=x Position auf der Wippe

close all;
%% Nyquist-Diagramm von (17)

nyquist(G);


%% Bode-Diagramm von (17)
figure();
bode(G);

