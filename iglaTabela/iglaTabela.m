% Program za formiranje datoteke sa koordinatama
% za 3D model igle, za tabelarni proracun
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
dat = 'proracun.xlsx'; % naziv fajla sa proracunom
izlaz = 'igla.xlsx'; % naziv izlaznog fajla
sheetnum = 3; % broj sheet-a
h_am_kolona = 81:95; % kolona hod amortizera
R_kolona = 81:95; % kolona precnik igle
deltaR = 4; % [mm] razlika precnika za vezu igle
L_i = 8.8; % [mm] duzina dela za vezu igle
N = 1001; % [-] broj tacaka
% ------------------------

disp([' ----- ' mfilename ' ----- ']);
addpath([pwd '\CalcLink']); % folder sa CalcLink

% Pokretanje LibreOffice Calc aplikacije
clApp = CalcApplication(1); 
clApp.Open([pwd '\' dat]); % Otvaranje postojeceg dokumenta

% Ucitavanje koordinata
h_ami_r = clApp.read(sheetnum,2*ones(1,length(h_am_kolona)),h_am_kolona);
R_i_r = clApp.read(sheetnum,7*ones(1,length(R_kolona)),R_kolona);
for i = 1:length(h_ami_r)
  h_ami(i) =  h_ami_r{i}.Value*10;
end
for i = 1:length(R_i_r)
  R_i(i) =  R_i_r{i}.Value*10/2;
end
clApp.Close;

% Sredjivanje vrednosti
i1 = min(find(R_i))-1;
t = [R_i(end)-deltaR,h_ami(end);...
    R_i(end)-deltaR,h_ami(end)+L_i;...
    0,h_ami(end)+L_i;...
    0,h_ami(i1)];
h_amsi = linspace(h_ami(i1),h_ami(end),N);
R_i(end) = R_i(end-1);
R_si = interp1(h_ami,R_i,h_amsi,'spline'); % spline interpolacija
t = [[R_si',h_amsi'];t];

% Crtanje grafika za proveru
h = figure(1);
hold on; box on; grid on;
plot(h_ami,R_i,'o',h_amsi,R_si,'.');
xlim([0 h_ami(end)]);
title('Zavisnost poluprecnika igle od h_{am}');
xlabel('h_{am} [mm]'); ylabel('R_{i} [mm]');
figime = 'iglaoblikxls';
print(figime,'-dpng','-F:18'); % Rasterski
print(figime,'-dsvg','-FCMU Serif:18'); % Vektorski za Inkscape

% Upisivanje LibreOffice Calc tabele
clApp.New; % Otvaranje novog dokumenta
N = length(t);
for i = 1:2
  for j = 1:N
    t_str{(i-1)*N+j} = num2str(t(j,i),'=%f');
  end
end
clApp.write(1,[1*ones(1,N),2*ones(1,N)],[1:N,1:N],t_str);
clApp.SaveAs([pwd '\' izlaz]) % Cuvanje dokumenta
clApp.Close;
disp(' ------------------------');