% Program za fitovanje funkcije
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
N = 1001; % broj tacaka za interpolaciju
fj = 3; % redni broj dijagrama
p = 1; % broj cvorova
hgmax = 70; % [mm] maksimalni hod gume
file = 'krive.mat'; % sacuvan .mat fajl nakon digitalizacije
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

load(file);
h = figure(fj);
hold on; box on; grid on;
x = krive{1}(:,1); y = krive{1}(:,2);
f = splinefit(x,y,p);
xf = linspace(x(1),x(end),N); yf = ppval(f,xf);
Ftmax = ppval(f,hgmax);

plot(xf,yf,'LineWidth',3);  
stem(hgmax,Ftmax,'LineWidth',2,'MarkerFaceColor',[1,1,1],'MarkerSize',10);
title('Zavisnost udarne sile od hoda gume')
xlabel('h_g [mm]'); ylabel('F_t [kN]');
ylim([0 inf])
int_f = ppint(f);
Wg = ppval(int_f,hgmax)-ppval(f,0);
disp([' Rad gume: ' num2str(Wg,'%.2f') ' kNm']); 
disp(' --------------------');