% Program za odredjivanje kineticke energije i sila
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
m_sl = 11300; % [kg] masa na sletanju
d = 4.92; % [m] udaljenost NN po x od CG 
b = 0.44; % [m] udaljenost GN po x od CG 
i_y = 2.4; % [m] poluprecnik inercije za osu y
n_GN = 2; % [-] broj glavnih nogu stajnog trapa
n_tGN = 2; % [-] broj tockova glavne noge
n_tNN = 1; % [-] broj tockova nosne noge
V_z = 3; % [m/s] vertiklana komponenta brzine sletanja
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

g = 9.81; % [m/s^2] gravitaciono ubrzanje
m_r = m_sl/(1+(d/i_y)^2); % redukovana masa

% Apsorbovana energija
W_GN = 1/2*m_sl*V_z^2;
W_NN = 1/2*m_r*V_z^2;

% Staticke sile na GN i NN
G = m_sl*g;
F_GN = G*d/((b+d)*n_GN);
F_NN = G*b/(b+d);

% Staticke sile na jednom tocku GN i NN
F_tGN = F_GN/n_tGN;
F_tNN = F_NN/n_tNN;

% Ispisivanje rezultata
disp([' Redukovana masa: ' num2str(m_r,'%.3f') ' kg']);
disp([' Apsorbovana energija GN, W_GN: ' ...
    num2str(W_GN/10,'%.3f') ' daNm']);
disp([' Apsorbovana energija NN, W_NN: ' ...
    num2str(W_NN/10,'%.3f') ' daNm']);
disp([' Staticka sila na jednom tocku GN, F_GN: ' ...
    num2str(F_tGN/10,'%.3f') ' daN']);
disp([' Staticka sila na jednom tocku NN, F_NN: ' ...
    num2str(F_tNN/10,'%.3f') ' daN']);
disp(' ------------------------');