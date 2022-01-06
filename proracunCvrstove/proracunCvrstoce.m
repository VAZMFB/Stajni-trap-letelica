% Program za proracun amortizera
% Knjiga: Stajni trap letelica
% Autori: Danilo Petrasinovic, Aleksandar Grbovic,
%         Mirko Dinulovic, Milos Petrasinovic
% Masinski fakultet, Univerzitet u Beogradu
% Beograd, 2020
% GNU Octave 5.1.0
% ------------------------
%
% Copyright (C) 2021 Milos Petrasinovic <info@vazmfb.com>
%  
% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as 
% published by the Free Software Foundation, either version 3 of the 
% License, or (at your option) any later version.
%   
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%   
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.
%
% ------------------------
clear all, close all, clc
% --- ULAZNE PROMENLJIVE ---
beta = 7; % [deg] ugao koji osa amortizera zaklapa sa z
F_t = 2543.828; % [daN] sila na gumi
n_st = 3; % [-] dozvoljeni koeficijent opterecenja stajnog trapa
n_t = 2; % [-] broj tockova
sigma_doz = 4000; % [daN/cm^2] dozvoljeni normalni napon
tau_doz = 2400; % [daN/cm^2] dozvoljeni tangencijalni napon
D = 80; % [cm] precnik gume
b = 26; % [cm] sirina gume
h_gmax = 13.258; % [cm] maksimalni hod gume
h_ammax = 13.929; % [cm] maksimalni hod amortizera
Q_vmax = 14563.627; % [daN] maksimalna sila vazduha
% Dimenzije cevi
D_os = 11.43; % [cm] spoljasnji precnik osovine
delta_o = 0.8; % [cm] debljina zida osovine
D_ks = 12.7; % [cm] spoljasnji precnik kliupnjace
delta_k = 0.88; % [cm] debljina zida klipnjace
D_cs = 15.9; % [cm] spoljasnji precnik cilindra
delta_c = 0.88; % [cm] debljina zida cilindra
% Geometrija 
L = 60; % [cm] rastojanje BD
L1 = 15; % [cm] rastojanje CD-h_am
L_B1B = 10; % [cm] rastojanje B1B
L_DE = 15; % [cm] rastojanje DE
% ------------------------

disp([' ----- ' mfilename ' ----- ']);
warning('off', 'Octave:divide-by-zero');

%% Sile koje deluju
F_V =  n_t*n_st*F_t; % vertikalna sila
F_H = 0.25*F_V; % horirontalna sila za glavnu nogu
% F_H = 0.5*F_V; % horirontalna sila za nosnu nogu
F_B = 0.33*F_V; % bocna sila

%% Osovina tocka
D_ou = D_os-2*delta_o;
A_o = (D_os^2-D_ou^2)*pi/4;
S_x12o = (D_os^3-D_ou^3)/12;
I_o = (D_os^4-D_ou^4)*pi/64;
W_o = (D_os^4-D_ou^4)*pi/(32*D_os);

L_AB = b/2+L_B1B;
L_A1A = D/2-h_gmax;

% Ravan Oyz
N_B = F_B/2;
T_zB = F_V/2;
M_xA = F_B/2*L_A1A;
M_xB = M_xA+F_V/2*L_AB;

% Ravan Oxy
T_xB = F_H/2;
M_zB = F_H/2*L_AB;

% Rezultujuce opterecenje
M_B = sqrt(M_xB^2+M_zB^2);
T_B = sqrt(T_xB^2+T_zB^2);

% Provera cvrsotoce
sigma_B(1) = M_B/W_o+N_B/A_o;
sigma_B(2) = -M_B/W_o+N_B/A_o;
tau_B = T_B*S_x12o/(I_o*(D_os-D_ou));

[SM I] = max(abs(sigma_B));
if(sigma_B(I)> 0)
    sigma_eB(1) = sigma_B(I)/2+1/2*sqrt(sigma_B(I)^2+4*tau_B^2);
else
    sigma_eB(1) = sigma_B(I)/2-1/2*sqrt(sigma_B(I)^2+4*tau_B^2);
end
sigma_eB(2) = sqrt(sigma_B(I)^2+4*tau_B^2);
sigma_eBmax = max(sigma_eB);
 
%% Klipnjaca amortizera
D_ku = D_ks-2*delta_k;
A_k = (D_ks^2-D_ku^2)*pi/4;
S_x12k = (D_ks^3-D_ku^3)/12;
I_k = (D_ks^4-D_ku^4)*pi/64;
W_k = (D_ks^4-D_ku^4)*pi/(32*D_ks);

L_BC = L-L1-h_ammax;
L_BD = L;
L_CD = L_BD-L_BC;

% Ravan Ox1z1
X_B = F_H*cosd(beta)-F_V*sind(beta);
Z_B = F_H*sind(beta)+F_V*cosd(beta);

Z_C = Z_B;
X_C = X_B*L_BD/L_CD;
M_yC = X_B*L_BC;
X_D = X_C-X_B;

% Ravan Oyz1
Z_D = Z_B;
Y_B = F_B;
M_xBk = Y_B*L_A1A;

Y_C = M_xBk/L_CD+Y_B*L_BD/L_CD;
M_xC = M_xBk+Y_B*L_BC;
Y_D = Y_C-Y_B;

% Rezultujuce opterecenje
T_xC = max(abs([X_B,X_D]));
T_yC = max(abs([Y_B,Y_D]));
M_C = sqrt(M_xC^2+M_yC^2);
T_C = sqrt(T_xC^2+T_yC^2);
N_C = Z_C;

% Provera cvrsotoce
sigma_C(1) = M_C/W_k+N_C/A_k;
sigma_C(2) = -M_C/W_k+N_C/A_k;
tau_C = T_C*S_x12k/(I_k*(D_ks-D_ku));

[SM I] = max(abs(sigma_C));
if(sigma_C(I)> 0)
    sigma_eC(1) = sigma_C(I)/2+1/2*sqrt(sigma_C(I)^2+4*tau_C^2);
else
    sigma_eC(1) = sigma_C(I)/2-1/2*sqrt(sigma_C(I)^2+4*tau_C^2);
end
sigma_eC(2) = sqrt(sigma_C(I)^2+4*tau_C^2);
sigma_eCmax = max(sigma_eC);

%% Cilindar amortizera
D_cu = D_cs-2*delta_c;
A_c = (D_cs^2-D_cu^2)*pi/4;
S_x12c = (D_cs^3-D_cu^3)/12;
I_c = (D_cs^4-D_cu^4)*pi/64;
W_c = (D_cs^4-D_cu^4)*pi/(32*D_cs);

L_CE = L_CD+L_DE;

% Ravan Ox1z1
T_xE = X_C-X_D;
N_E = Q_vmax;
M_yD = X_C*L_CD;
M_yE = X_C*L_CE-X_D*L_DE;

% Ravan Oyz1
T_yE = Y_C-Y_D;
M_xD = Y_C*L_CD;
M_xE = Y_C*L_CE-Y_D*L_DE;

% Rezultujuce opterecenje
M_E = sqrt(M_xE^2+M_yE^2);
T_E = sqrt(T_xE^2+T_yE^2);

% Provera cvrsotoce
sigma_E(1) = M_E/W_c+N_E/A_c;
sigma_E(2) = -M_E/W_c+N_E/A_c;
sigma_p = D_cu/(2*delta_c)*Q_vmax/(D_cu^2*pi/4);
tau_E = T_E*S_x12c/(I_c*(D_cs-D_cu));

[SM I] = max(abs(sigma_E));
sigma_Emax = sigma_E(I);


if(tau_E^2 >= sigma_Emax*sigma_p)
    sigma_eEmax = sqrt((sigma_Emax-sigma_p)^2+4*tau_E^2);
else
    sigma_eEmax =  abs(sigma_Emax+sigma_p)/2+...
        1/2*sqrt((sigma_Emax-sigma_p)^2+4*tau_E^2);
end

%% Crtanje statickih dijagrama
% Osovina tocka
figime{1} = 'O_Oyz';
% Aksijalna sila N
X{1} = [0,b/2,b/2,b/2+L_AB,b/2+L_AB];
Y{1} = [0,0,F_B,F_B,0];
od{1} = 'y [cm]'; od{2} = 'N [daN]'; m{1} = 1;
% Transverzalna sila T_z
X{2} = [0,b/2,b/2,b/2+L_AB,b/2+L_AB];
Y{2} = [0,0,F_V,F_V,0];
od{3} = 'y [cm]'; od{4} = 'T_z [daN]'; m{2} = 1;
% Moment savijanja M_x
X{3} = [0,b/2,b/2,b/2+L_AB,b/2+L_AB];
Y{3} = [0,0,M_xA,M_xB,0];
od{5} = 'y [cm]'; od{6} = 'M_x [daNcm]'; m{3} = 2;
n = 'Ravan Oyz';
h(1) = crtajDijag(1,X,Y,m,n,od,50);

figime{2} = 'O_Oyx';
% Transverzalna sila T_x
X{1} = [0,b/2,b/2,b/2+L_AB,b/2+L_AB];
Y{1} = [0,0,F_H,F_H,0];
od{1} = 'y [cm]'; od{2} = 'T_x [daN]'; m{1} = 1;
% Moment savijanja M_z
X{2} = [0,b/2,b/2+L_AB,b/2+L_AB];
Y{2} = [0,0,M_zB,0];
od{3} = 'y [cm]'; od{4} = 'M_z [daNcm ]'; m{2} = 2;
% Moment uvijanja M_y
X{3} = [0,b/2+L_AB];
Y{3} = [0,0];
od{5} = 'y [cm]'; od{6} = 'M_y [daNcm]'; m{3} = 2;
n = 'Ravan Oyx';
h(2) = crtajDijag(2,X,Y,m,n,od,50);

% Klipnjaca amortizera
figime{3} = 'K_Oz1x';
% Aksijalna sila N
X{1} = [0,0,L_BD,L_BD];
Y{1} = [0,-Z_B,-Z_B,0];
od{1} = 'z_1 [cm]'; od{2} = 'N [daN]'; m{1} = 1;
% Transverzalna sila T_x
X{2} = [0,0,L_BC,L_BC,L_BD,L_BD];
Y{2} = [0,X_B,X_B,X_B-X_C,X_B-X_C,0];
od{3} = 'z_1 [cm]'; od{4} = 'T_x [daN]'; m{2} = 1;
% Moment savijanja M_y
X{3} = [0,L_BC,L_BD];
Y{3} = [0,M_yC,0];
od{5} = 'z_1 [cm]'; od{6} = 'M_y [daNcm]'; m{3} = 2;
n = 'Ravan Oz_1x_1';
h(3) = crtajDijag(3,X,Y,m,n,od,50);

figime{4} = 'K_Oz1y';
% Transverzalna sila T_y
X{1} = [0,0,L_BC,L_BC,L_BD,L_BD];
Y{1} = [0,-Y_B,-Y_B,-Y_B+Y_C,-Y_B+Y_C,0];
od{1} = 'z_1 [cm]'; od{2} = 'T_y [daN]'; m{1} = 1;
% Moment savijanja M_x
X{2} = [0,0,L_BC,L_BD];
Y{2} = [0,-M_xB,-M_xC,0];
od{3} = 'z_1 [cm]'; od{4} = 'M_x [daNcm ]'; m{2} = 2;
% Moment uvijanja M_z
X{3} = [0,b/2+L_AB];
Y{3} = [0,0];
od{5} = 'z_1 [cm]'; od{6} = 'M_z [daNcm]'; m{3} = 2;
n = 'Ravan Oz_1y';
h(5) = crtajDijag(4,X,Y,m,n,od,50);

% Cilindar amortizera
figime{5} = 'C_Oz1x';
% Aksijalna sila N
X{1} = [L_BC,L_BC,L_BC+L_CE,L_BC+L_CE];
Y{1} = [0,N_E,N_E,0];
od{1} = 'z_1 [cm]'; od{2} = 'N [daN]'; m{1} = 1;
% Transverzalna sila T_x
X{2} = [L_BC,L_BC,L_BC+L_CD,L_BC+L_CD,L_BC+L_CE,L_BC+L_CE];
Y{2} = [0,X_C,X_C,T_xE,T_xE,0];
od{3} = 'z_1 [cm]'; od{4} = 'T_x [daN]'; m{2} = 1;
% Moment savijanja M_y
X{3} = [L_BC,L_BD,L_BC+L_CE,L_BC+L_CE];
Y{3} = [0,M_yD,M_yE,0];
od{5} = 'z_1 [cm]'; od{6} = 'M_y [daNcm]'; m{3} = 2;
n = 'Ravan Oz_1x_1';
h(5) = crtajDijag(5,X,Y,m,n,od,50);

figime{6} = 'C_Oz1y';
% Transverzalna sila T_y
X{1} = [L_BC,L_BC,L_BC+L_CD,L_BC+L_CD,L_BC+L_CE,L_BC+L_CE];
Y{1} = [0,-Y_C,-Y_C,-T_yE,-T_yE,0];
od{1} = 'z_1 [cm]'; od{2} = 'T_y [daN]'; m{1} = 1;
% Moment savijanja M_x
X{2} = [L_BC,L_BC+L_CD,L_BC+L_CE,L_BC+L_CE];
Y{2} = [0,-M_xD,-M_xE,0];
od{3} = 'z_1 [cm]'; od{4} = 'M_x [daNcm ]'; m{2} = 2;
% Moment uvijanja M_z
X{3} = [L_BC,L_BC+L_CE];
Y{3} = [0,0];
od{5} = 'z_1 [cm]'; od{6} = 'M_z [daNcm]'; m{3} = 2;
n = 'Ravan Oz_1y';
h(6) = crtajDijag(6,X,Y,m,n,od,50);

%% Ispisivanje rezultata
disp([' Ekvivalentni normalni napon osovine, sigma_eB: '...
    num2str(sigma_eBmax,'%.3f') ' daN/cm^2.']);
disp([' Tangencijalni napon osovine, tau_B: '...
    num2str(tau_B,'%.3f') ' daN/cm^2.']);
disp([' Ekvivalentni normalni napon klipnjace, sigma_eC: '...
    num2str(sigma_eCmax,'%.3f') ' daN/cm^2.']);
disp([' Tangencijalni napon klipnjace, tau_C: '...
    num2str(tau_C,'%.3f') ' daN/cm^2.']);
disp([' Ekvivalentni normalni napon cilindra, sigma_eE: '...
    num2str(sigma_eEmax,'%.3f') ' daN/cm^2.']);
disp([' Tangencijalni napon cilindra, tau_E: '...
    num2str(tau_E,'%.3f') ' daN/cm^2.']);

%% Cuvanje dijagrama
for i=1:length(h)
    figure(i)
    print(figime{i},'-dpng'); % Rasterski
    print(figime{i},'-dsvg'); % Vektorski za Inkscape
end
disp(' ------------------------');