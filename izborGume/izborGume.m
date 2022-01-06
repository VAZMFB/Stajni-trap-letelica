% Program za proracun guma
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
% F_g = 2543.828; % [daN] sila na gumi
% F_gst = [2850,2800]; % [daN] staticko opterecenje gume
% --- ULAZNE PROMENLJIVE ---
W = 2543.5; % [daNm] kineticka energija koju treba asporbovati
n_t = 2; % [-] broj tockova
oznaka = {'KT28','K163-T'}; % oznaka gume
D = [66,80]; % [cm] precnik gume
b = [16,26]; % [cm] sirina gume
F_gmax = [8300,8900]; % [daN] maksimalno opterecenje gume
P_0 = [9.2,4.5]; % [10^5 Pa] pritisak u gumi
fi = [4.125,3.077]; % [-] odnos precnika i sirine gume
ksi =  [1.012,1.022]; % [-] koeficijent koji zavisi od P_0
psi = [4.596,3.947]; % [-] koeficijent koji zavisi od fi
kapa = [0.358,0.478]; % [-] koeficijent koji zavisi od fi
N = 1001; % [-] broj tacaka
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

h = figure(1);
boje = get(gca,'colororder');
hold on; box on; grid on;
for i=1:length(D)
  h_g{i} = linspace(0,0.7*b(i),N);
  F_tf{i} = @(lam) ksi(i)*psi(i)*b(i)^2*...
      (P_0(i)+(P_0(i)+1)*kapa(i)*lam.^2).*(lam+0.03);
  lam_max(i) = fzero(@(lam) F_tf{i}(lam)-F_gmax(i),0);
  h_gmax(i) = lam_max(i)*b(i);
  W_g(i) = integral(F_tf{i},0,lam_max(i))*b(i)/100;
  h(i) = plot(h_g{i},F_tf{i}(h_g{i}/b(i)),...
      'LineWidth',3,'Color',boje(i,:));
  plot(h_gmax(i),F_tf{i}(h_gmax(i)/b(i)),'o',...
      'MarkerSize',8,'MarkerEdgeColor',boje(i,:),...
      'LineWidth',3,'MarkerFaceColor',[1,1,1]);
end
xlabel('h_g [cm]'); ylabel('F_t [daN]');
legend(h,oznaka,'Location','southeast');

% Ispisivanje rezultata
for i = 1:length(D);
  disp(' ------------------------');
  disp([' Oznaka gume: ' oznaka{i}]);
  disp([' Maksimalni hod gume, h_gmax: '...
      num2str(h_gmax(i),'%.3f') ' cm.']);
  disp([' Rad gume, W_g: '...
      num2str(W_g(i),'%.3f') ' daNm.']);
  disp([' Potrebni rad amortizera, W_am: '...
      num2str(W-W_g(i)*n_t,'%.3f') ' daNm.']);
end

% Cuvanje dijagrama
print('izborgume.png','-dpng','-F:18'); % Rasterski
print('izborgume.svg','-dsvg','-FCMU Serif:18'); % Vektorski za Inkscape
disp(' ------------------------');