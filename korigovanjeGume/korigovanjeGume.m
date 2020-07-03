% Program za korigovanje rada i hoda gume
% Knjiga: Stajni trap letelica
% Autori: Danilo Petrasinovic, Aleksandar Grbovic,
%         Mirko Dinulovic, Milos Petrasinovic
% Masinski fakultet, Univerzitet u Beogradu
% Beograd, 2020
% GNU Octave 5.1.0
% ------------------------
clear all, close all, clc
% --- ULAZNE PROMENLJIVE ---
F_t = 2543.828; % [daN] sila na gumi
n_st = 3; % [-] dozvoljeni koeficijent opterecenja stajnog trapa
W = 2542.5; % [daNm] kineticka energija koju treba asporbovati
n_t = 2; % [-] broj tockova
oznaka = 'K163-T'; % oznaka gume
b = 26; % [cm] sirina gume
P_0 = 4.5; % [10^5 Pa] pritisak u gumi
ksi =  1.022; % [-] koeficijent koji zavisi od P_0
psi = 3.947; % [-] koeficijent koji zavisi od fi
kapa = 0.478; % [-] koeficijent koji zavisi od fi
N = 1001; % [-] broj tacaka
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

F_tmax = n_st*F_t;
h_g = linspace(0,0.7*b,N);
F_tf = @(lam) ksi*psi*b^2*...
    (P_0+(P_0+1)*kapa*lam.^2).*(lam+0.03);
lam_max = fzero(@(lam) F_tf(lam)-F_tmax,0);
h_gmax = lam_max*b;
W_g = integral(F_tf,0,lam_max)*b/100;

h = figure(1);
boje = get(gca,'colororder');
hold on; box on; grid on;
plot(h_g,F_tf(h_g/b),...
    'LineWidth',3,'Color',boje(1,:));
plot([h_gmax,h_gmax,0],[0,F_tmax,F_tmax],...
    'LineWidth',2,'Color',boje(2,:));  
plot(h_gmax,F_tmax,'o',...
    'MarkerSize',8,'MarkerEdgeColor',boje(1,:),...
    'LineWidth',3,'MarkerFaceColor',[1,1,1]);
xlabel('h_g [cm]'); ylabel('F_t [daN]');

% Ispisivanje rezultata
disp([' Oznaka gume: ' oznaka]);
disp([' Maksimalni hod gume, h_gmax: '...
    num2str(h_gmax,'%.3f') ' cm.']);
disp([' Rad gume, W_g: '...
    num2str(W_g,'%.3f') ' daNm.']);
disp([' Potrebni rad amortizera, W_am: '...
    num2str(W-W_g*n_t,'%.3f') ' daNm.']);

% Cuvanje dijagrama
print('korigovangume.png','-dpng','-F:18'); % Rasterski
print('korigovangume.svg','-dsvg','-FCMU Serif:18'); % Vektorski za Inkscape
disp(' ------------------------');