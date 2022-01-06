% Program za proracun krutosti opruge
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
% --- IZBOR OPRUGE ---
% t = 1 - opruga sa savijenim zaravnatim krajevima
% t = 2 - opruga sa savijenim krajevima
% t = 3 - opruga sa slobodnim krajevima
% alfa = 1 - vodjena opruga (na cilindru)
% alfa = 0.5 - oslonjena opruga sa obe strane
% alfa = 0.707 - jedna strana oslonjena druga okacena
% alfa = 2 - jedna strana uhvacena druga slobodna
% --- ULAZNE PROMENLJIVE ---
t = 1; % tip opruge
alfa = 1; % stanje krajeva opruge 
hod = 40; % [mm] hod opruge
d = 4; % [mm] precnik zice
D = 50; % [mm] spoljasnji precnik opruge
na = 12; % [-] broj aktivnih namotaja
L = 100; % [mm] duzina slobodne opruge
E = 210; % [GPa] modul elasticnosti materijala
G = 80; % [GPa] modul klizanja materijala
sigma_max = 1350; % [MPa] maksimalni normalni napon
tau_sigma = 0.7; % [-] odnos tangencijalnog i normalnog napona
S = 2; % [-] stepen sigurnosti
% ------------------------

disp([' ----- ' mfilename ' ----- ']);

Ds = D-d; % srednji precnik
c = G*d^4/(8*na*Ds^3)*10^3; % koeficijent krutosti

switch t
    case 1 % Opruga sa savijenim zaravnatim krajevima
        nt = na+2; % ukupni broj namotaja
        P = (L-2*d)/na; % korak opruge
        Ls = d*nt; % minimalna visina opruge
	case 2 % Opruga sa savijenim krajevima
        nt = na+2;
        P = (L-3*d)/(na); 
        Ls = d*(nt+1);
    case 3 % Opruga sa slobodnim krajevima
        nt = na;
        P = (L-d)/na;
        Ls = d*(nt+1);
end

fi = atan(P/(pi*Ds)); % ugao namotaja
dx = L-Ls; % maksimalni hod
Fmax = c*dx; % maksimalna sila na kraju hoda
F = c*hod; % sila u zavisnosti od hoda
K = D/d; % index opruge
Kw = (4*K-1)/(4*K-4)+0.615/K; % Wahl faktor
tau = Kw*8*F*D/(pi*d^3); % tau napon u opruzi
taud = sigma_max*tau_sigma/S; % dozvoljeni tau napon
Lizv = pi*D/alfa*sqrt(2*(E-G)/(2*G+E)); % provera izvijanja

% Ispistivanje rezultata
disp([' Krutost opruge: ' sprintf('%.3f',c) ' N/mm.'])
disp([' Sila na kraju hoda: ' sprintf('%.2f',F) ' N.'])
disp([' Maksimalni hod: ' sprintf('%.2f',dx) ' mm.'])
disp([' Korak: ' sprintf('%.2f',P) ' mm.'])
disp([' Tangencijalni napon: ' sprintf('%.2f',tau) ' MPa.'])

if(Lizv > L)
	disp(' Ne dolazi do izvijanja opruge.')
else
	disp(' Dolazi do izvijanja opruge!')
end

if(tau < taud)
	disp(' Napon je u granicama dozvoljenog.')
else
	disp(' Napon je veci od dozvoljenog!')
end
disp(' --------------------');