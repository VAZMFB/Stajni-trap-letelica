% Sila amortizera kao polinom treceg reda
% Knjiga: Stajni trap letelica
% Autori: Danilo Petrasinovic, Aleksandar Grbovic,
%         Mirko Dinulovic, Milos Petrasinovic
% Masinski fakultet, Univerzitet u Beogradu
% Beograd, 2020
% GNU Octave 5.1.0
% ------------------------
clear all, close all, clc
% --- ULAZNE PROMENLJIVE ---
N = 1001; % [-] broj tacaka
F_t = 2543.828; % [daN] sila na gumi
W_am = 1547.423; % [daNm] potrebni rad amortizera
eta = 0.8; % [-] efikasnost amortizera
n_t = 2; % [-] broj tockova
beta = 7; % [deg] ugao koji osa amortizera zaklapa sa vertikalom 
n_st = 3; % [-] dozvoljeni koeficijent opterecenja stajnog trapa
n_st0 = 0.6; % [-] staticki koeficijent opterecenja stajnog trapa
s = 1.1; % [-] povecanje y ose
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

Q_am0 = n_t*n_st0*F_t*cosd(beta); % [daN] minimalna sila amortizera
Q_ammax = n_t*n_st*F_t*cosd(beta); % [daN] maksimalna sila amortizera
h_ammax = W_am/(eta*Q_ammax/100); % [cm] maksimalni hod amorizera

% Koeficijenti polinoma
A = (12*eta*Q_ammax-4*Q_am0-8*Q_ammax)/h_ammax^3;
B = (Q_am0-Q_ammax)/h_ammax^2-2*h_ammax*A;
C = -3*h_ammax^2*A-2*h_ammax*B;
D = Q_am0;

h_ami = linspace(0,h_ammax,N); % hod amortizera
Qi = A*h_ami.^3+B*h_ami.^2+C*h_ami+D; % sila amortizera

% Crtanje grafika
figure(1);    
hold on; box on; grid on;
plot(h_ami,Qi,'LineWidth',3);
xlim([0,max(h_ami)]); ylim([0,max(Qi)*s]);
xlabel('h_{am} [cm]'); ylabel('Q_{am} [daN]');

print('kriva-p3.png','-dpng','-F:18'); % Rasterski
print('kriva-p3.svg','-dsvg','-FCMU Serif:18'); % Vektorski za Inkscape
disp(' ------------------------');