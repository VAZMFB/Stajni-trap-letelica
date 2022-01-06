% Program za formiranje datoteke sa koordinatama
% za 3D model igle 
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
dat = 'igladat'; % naziv fajla sa koordinatam za iglu
izlaz = 'igla.dat'; % naziv izlaznog fajla
delta_R = 4; % [mm] razlika precnika za vezu igle
L_i = 8.8; % [mm] duzina dela za vezu igle
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

% Ucitavanje koordinata
load(dat);

% Sredjivanje vrednosti
h_ami = h_ami*10; % [mm]
R_i = D_i*10/2; % [mm]
i1 = min(find(R_i))-1;
t = [R_i(end)-delta_R,h_ami(end);...
    R_i(end)-delta_R,h_ami(end)+L_i;...
    0,h_ami(end)+L_i;...
    0,h_ami(i1)];
R_i(end) = R_i(end-1);
t = [[R_i',h_ami'];t];

% Ispisivanje koordinata
fid = fopen('igla.dat','w');
for i = i1:size(t,1)
    fprintf(fid,'%.3f,%.3f\n',t(i,1),t(i,2));
end
fclose(fid);
disp(' ------------------------');