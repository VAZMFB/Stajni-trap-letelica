% Program za digitalizaciju dijagrama
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

% Ispisivanje pocetka
disp([' ----- ' mfilename ' ----- ']);
disp(' Izaberite dijagram...')

% Pocetne vrednosti
s1 = 0;
s2 = 0;
i = 1;
j = 1;

% Ucitavanje dijagrama
[dijag, pathname] = ...
 uigetfile({'*.*'},'Izaberite dijagram...');
if(dijag)
dijagObj = imread([pathname dijag]);
    if ~isempty(dijagObj)
        figure(1);
        for i=1:size(dijagObj,3) 
            dijagObj(:,:,i) = flipud(dijagObj(:,:,i)); 
        end
        dijagFig = imshow(dijagObj);
        set(gca,'YDir','normal')
        boje = repmat(get(gca,'colororder'),10,1);
        set(dijagFig, 'AlphaData', 0.5);
        title('Unesite koordinate x0, y0, x1 i y1 u prozor...')
        disp(' Unesite koordinate x0, y0, x1 i y1 u prozor...')
    else
        error('Nije validan dijagram!');
    end
else
    error('Nije ucitan dijagram!');
end

% Tip osa
odg = questdlg('Da li je x linearna ili logaritamska?', ...
'X osa','Linearna','Logaritamska','Linearna');
if(strcmp(odg,'Linearna'))
    mx = 1;
else
    mx = 2;
end

odg = questdlg('Da li je y linearna ili logaritamska?', ...
'Y osa','Linearna','Logaritamska','Linearna');
if(strcmp(odg,'Linearna'))
    my = 1;
else
    my = 2;
end

% Unosenje koordinata za mapiranje
xyv = inputdlg({'Koordinata x0','Koordinata y0',...
'Koordinata x1','Koordinata y1'},...
      'Koordinate za mapiranje', 1, {'0','0','1','1'});
x0v = str2num(xyv{1});
y0v = str2num(xyv{2});
x1v = str2num(xyv{3});
y1v = str2num(xyv{4});
if ~isempty(xyv)
    figure(1);
    hold on;
    s1 = 1;
    for i=1:3
        switch i
            case 1
              title('Oznacite koordinatni pocetak [x0,y0]...')
              disp(' Oznacite koordinatni pocetak [x0,y0]...')
              color = 'r';
            case 2
              title('Oznacite tacku na koordinatnoj osi x [x1,y0]...')
              disp(' Oznacite tacku na koordinatnoj osi x [x1,y0]...')
              color = 'b';
            case 3
              title('Oznacite tacku na koordinatnoj osi y [x0,y1]...')
              disp(' Oznacite tacku na koordinatnoj osi y [x0,y1]...')
              color = 'b';
        end
        [x(i),y(i)] = ginput(1);
        if isempty(x(i))
            s1 = 0;
        else
            plot(x(i),y(i),'o','MarkerSize',10,'LineWidth',2,...
            'MarkerFaceColor',[1 1 1],'MarkerEdgeColor',color);
        end
    end
    
    if(s1)
        s2 = 1;
    else
        error('Nisu unete tacke!');
    end
else
   error('Nisu unete koordinate!');
end

% Unosenje tacaka krive
figure(1)
hold on; grid on; box on;
while s2
    title('Unesite tacke jedne krive i na kraju pritisnite ENTER...')
    disp(' Unesite tacke jedne krive i na kraju pritisnite ENTER...')
    krive{j} = [0,0]; 
    
    while 1
        [xt,yt,button] = ginput(1);
        if ~isempty(button)
            krive{j}(end+1,1:2) = [xt,yt];
            plot(krive{j}(2:end,1),krive{j}(2:end,2),...
                'LineWidth',2,'Color',boje(j,:))      
        else
            break; 
        end
    end
    odg = questdlg('Da li zelite da unesete jos jednu krivu?', ...
	'Nova kriva','Da','Ne','Ne');
    if(strcmp(odg,'Ne'))
        s2 = 0;
    else
        j = j+1;
        disp(' Uspesno uneta kriva!');
    end
end

% Preracunavanje vrednosti
for i=1:j
    N = size(krive{i}(:,1),1);
    Mm = [([x(2);y(2)]-[x(1);y(1)]) ([x(3);y(3)]-[x(1);y(1)])]^(-1);
    Xpmx0 = krive{i}' - x(1)*ones(2,N); 
    Xpmy0 = krive{i}' - y(1)*ones(2,N);
    T = Xpmx0'*Mm(1,:)';
    S = Xpmy0'*Mm(2,:)';
    if(mx == 1)
        srkrive{i}(:,1) = x0v+(x1v-x0v)*T;     
    else 
        srkrive{i}(:,1) = exp(log(x0v)+(log(x1v)-log(x0v))*T);
    end

    if(my == 1)        
        srkrive{i}(:,2) = y0v+(y1v - y0v)*S;
    else 
        srkrive{i}(:,2) = exp(log(y0v)+(log(y1v)-log(y0v))*S);
    end
    srkrive{i} = srkrive{i}(2:end,:);
end        
krive = srkrive;

% Cuvanje promenljivih
[file,path] = uiputfile('*.mat','Sacuvaj kao:');
save([path,file],'krive','x1v','y1v')

% Prikaz digitalizovanog dijagrama
figure(2)
hold on; grid on; box on;
for i=1:length(krive)
    plot(krive{i}(:,1),krive{i}(:,2),...
        'LineWidth',2,'Color',boje(i,:));
end

if(mx == 2)
    set(gca, 'XScale', 'log')    
end
if(my == 2)
    set(gca, 'YScale', 'log')  
end
    
% Pokretanje ponovo
odg = questdlg('Da li zelite da digitalizujete novi dijagram?', ...
'Novi dijagram','Da','Ne','Ne');
if(strcmp(odg,'Da'))
    digitDijag;
else 
    disp(' ------------------------');
end