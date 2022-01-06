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
N = 1001; % [-] broj tacaka
epsd = 10^-6; % [-] dozvoljena greska rada
% AMORTIZER
m_sl = 11300; % [kg] masa aviona na sletanju
W_am = 1547.423; % [daNm] potrebni rad amortizera
eta = 0.73; % [-] efikasnost amortizera
n_a = 2; % [-] broj amortizera
n_t = 2; % [-] broj tockova
beta = 7; % [deg] ugao koji osa amortizera zaklapa sa z
n_st = 3; % [-] dozvoljeni koeficijent opterecenja stajnog trapa
n_st0 = 0.6; % [-] staticki koeficijent opterecenja stajnog trapa
mi = 0.1; % [-] koeficijent trenja
D_cu = 14.14; % [cm] unutrasnji precnik cevi cilindra
D_ku = 10.94; % [cm] unutrasnji precnik cevi klipnjace
L = 60; % [cm] rastojanje BD
L1 = 15; % [cm] rastojanje CD-h_am
kapaeksp = 1.35; % [-] eksponent adijabate
mi_ist = 0.85; % [-] koeficijent isticanja ulja
ro_u = 900; % [kg/m^3] gustina ulja
p_a = 10132.5; % [daN/m^2] atmosferski pritisak
% GUMA
F_t = 2543.828; % [daN] sila na gumi
W_g = 497.539; % [daNm] rad gume
D = 80; % [cm] precnik gume
b = 26; % [cm] sirina gume
P_0 = 4.5; % [10^5 Pa] pritisak u gumi
ksi =  1.022; % [-] koeficijent koji zavisi od P_0
psi = 3.947; % [-] koeficijent koji zavisi od fi
kapa = 0.478; % [-] koeficijent koji zavisi od fi
s = 1.1; % [-] povecanje y ose
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

%% Korekcija maksimalnog hoda amortizera
Q_am0 = n_t*n_st0*F_t*cosd(beta); % [daN] minimalna sila amortizera
Q_ammax = n_t*n_st*F_t*cosd(beta); % [daN] maksimalna sila amortizera
h_ammax = W_am/(eta*Q_ammax/100); % [cm] maksimalni hod amorizera

eps = 1; % pocetna vrednost
while(abs(eps) > epsd)
    % Koeficijenti parabole
    A = (Q_am0-Q_ammax)/h_ammax^2;
    B = -2*(Q_am0-Q_ammax)/h_ammax;
    C = Q_am0;
    Qf =  @(h_am) A*h_am.^2+B*h_am+C; % anonimna funkcija sile
    eps = W_am - integral(Qf,0,h_ammax)/100; % greska rada
    h_ammax = h_ammax+eps/(Q_ammax/100); % korekcija hoda
end

%% Zavisnost apsorbovane energije od h_am
h_ami = linspace(0,h_ammax,N); % hod amortizera
Q_ami =  A*h_ami.^2+B*h_ami+C; % sila amortizera

% Sila na gumi
F_ti = Q_ami/(n_t*cosd(beta)); 
F_tf = @(h_g) ksi*psi*b^2*...
  (P_0+(P_0+1)*kapa*(h_g/b).^2).*(h_g/b+0.03);
for i=1:length(h_ami)
    h_gi(i) = fzero(@(h_g) F_tf(h_g)-F_ti(i),0); % hod gume
    W_gi(i) = integral(F_tf,0,h_gi(i))/100; % rad gume
    W_ami(i) = integral(Qf,0,h_ami(i))/100; % rad amortizera
end

% Aposrbovana energija
Wu = W_am+W_g*n_t;
Wi = W_gi*n_t+W_ami; 

%% Odredjivanje brzina
% Brzina propadanja
V_zi = sqrt(2*(Wu-Wi)*10/(m_sl/n_a)); 

% Prirastaj h_g u odnosu na h_am
dh_gi = diff(h_gi);
dh_ami = diff(h_ami);
dh_gi_ami = dh_gi./dh_ami; 
dh_gi_ami(end+1) = 0;

% Brzina amortizera
V_ami = V_zi./(dh_gi_ami+cosd(beta)); 

%% Odredjivanje komponenti sile amortizera
% Sila trenja
Q_tr0 = mi*tand(beta)*Q_am0*(2*L-L1)/L1;
Q_trmax = mi*tand(beta)*Q_ammax*(2*L-(L1+h_ammax))/(L1+h_ammax);
Q_tri = mi*tand(beta)*Q_ami.*(2*L-(L1+h_ami))./(L1+h_ami);

% Sila vazduha
S_cu = D_cu^2*pi/4;
Q_v0 = Q_am0-Q_tr0;
Q_vmax = Q_ammax-Q_trmax;
v_0 = (S_cu*h_ammax)/(1-((Q_v0+p_a*10^(-4)*S_cu)/...
    (Q_vmax+p_a*10^(-4)*S_cu))^(1/kapaeksp));
L_v = v_0/S_cu;
Q_vi = (Q_v0+p_a*10^(-4)*S_cu)*...
    (v_0./(v_0-S_cu*h_ami)).^kapaeksp-p_a*10^(-4)*S_cu;

% Sila ulja
Q_ui = Q_ami-Q_vi-Q_tri;

%% Odredjivanje potrebnog precnika igle
S_ku = D_ku^2*pi/4;
D_omax = h_ammax*0.15;
S_omax = D_omax^2*pi/4;
S_oi = V_ami(1:end-1)./sqrt(Q_ui(1:end-1)*10)/mi_ist.*...
    sqrt(ro_u/2*(S_ku*10^(-4))^3)*10^4;
S_oi(S_oi>S_omax) = S_omax;
S_oi = [S_oi,0];
D_i = sqrt(4/pi*(S_omax-S_oi));
save('igladat','h_ami','D_i');

%% Crtanje dijagrama
boje = get(gca,'colororder');
h(1) = figure(1);
hold on; box on; grid on;
p{1}{1} = plot(h_ami,Q_ami,...
    'LineWidth',3,'Color',boje(1,:));
xlabel('h_{am} [cm]'); ylabel('Q_{am} [daN]');
figime{1} = 'silaamort';

h(2) = figure(2);
hold on; box on; grid on;
p{2}{1} = plot(h_ami,h_gi,'LineWidth',3,'Color',boje(2,:));
xlabel('h_{am} [cm]'); ylabel('h_g [cm]');
figime{2} = 'hodamgume';

h(3) = figure(3);
hold on; box on; grid on;
p{3}{1} = plot(h_ami,dh_gi_ami,'LineWidth',3,'Color',boje(3,:));
xlabel('h_{am} [cm]'); ylabel('dh_g/dh_{am} [-]');
figime{3} = 'prirastaj';

h(4) = figure(4);
hold on; box on; grid on;
p{4}{1} = plot(h_ami,V_ami,'LineWidth',3,'Color',boje(4,:));
xlabel('h_{am} [cm]'); ylabel('V_{am} [m/s]');
figime{4} = 'brzinaamort';

h(5) = figure(5);
hold on; box on; grid on;
p{5}{1} = plot(h_ami,Q_ami,'LineWidth',3,'Color',boje(1,:));
p{5}{2} = plot(h_ami,Q_tri+Q_vi,'LineWidth',3,'Color',boje(2,:));
p{5}{3} = plot(h_ami,Q_vi,'LineWidth',3,'Color',boje(3,:));
legend({'Q','Q_v+Q_{tr}','Q_v'},'Location','northwest');
xlabel('h_{am} [cm]'); ylabel('Q_{am} [daN]');
figime{5} = 'kompamort';

h(6) = figure(6);
hold on; box on; grid on;
p{6}{1} = plot(h_ami,D_i,'LineWidth',3,'Color',boje(1,:));
xlabel('h_{am} [cm]'); ylabel('D_i [cm]');
figime{6} = 'precigle';

%% Ispisivanje rezultata
disp([' Maksimalni sila na gum, F_gmax: '...
    num2str(n_st*F_t,'%.3f') ' daN.']);
disp([' Maksimalni hod gume, h_gmax: '...
    num2str(h_gi(end),'%.3f') ' cm.']);
disp([' Maksimalni hod amortizera, h_ammax: '...
    num2str(h_ammax,'%.3f') ' cm.']);
disp([' Rad gume, W_g: '...
    num2str(W_g,'%.3f') ' daNm.']);
disp([' Rad amortizera, W_am: '...
    num2str(W_am(end),'%.3f') ' daNm.']);
disp([' Maksimalni sila amortizera, Q_am,max: '...
    num2str(Q_ammax,'%.3f') ' daN.']);
disp([' Pocetna sila amortizera, Q_am,0: '...
    num2str(Q_am0,'%.3f') ' daN.']);
disp([' Maksimalna sila vazduha, Q_vmax: '...
    num2str(Q_vmax,'%.3f') ' daN.']);

%% Cuvanje dijagrama
for i = 1:length(h)
    figure(i)
    for j = 1:length(p{i})
      xdat = get(p{i}{j},'XData');
      xmax(j) = max(xdat);
      xmin(j) = min(xdat);
    end
    xlim([min(xmin),max(xmax)]);
    print(figime{i},'-dpng','-F:18'); % Rasterski
    print(figime{i},'-dsvg','-FCMU Serif:18'); % Vektorski za Inkscape
end
disp(' --------------------');