function h = crtajDijag(j,X,Y,m,n,od,nl)
% Program za crtanje statickih dijagrama
% Knjiga: Stajni trap letelica
% Autori: Danilo Petrasinovic, Aleksandar Grbovic,
%         Mirko Dinulovic, Milos Petrasinovic
% Masinski fakultet, Univerzitet u Beogradu
% Beograd, 2020
% GNU Octave 5.1.0
% ------------------------
% --- ULAZNE PROMENLJIVE ---
% j - redni broj dijagrama
% X - koordinate
% Y - vrednost opterecenja
% m - tip opterecenja
%   m = 1 - sila
%   m = 2 - moment
% n - naslov dijagrama
% od - naziv osa dijagrama
% nl - broj linija
% --- IZLAZNE PROMENLJIVE ---
% h - objekat dijagrama
% ------------------------

Xi = linspace(X{1}(1),X{1}(end),nl);
h = figure(j);
subplot(3,1,1);
set(gcf,'units','points','position',[0,0,700,700])
boje = get(gca,'colororder');

for l = 1:3
    subplot(3,1,l)
    hold on, box on
    if(m{l} == 1)
        for i=1:length(Xi)
            k = 1;
            while(Xi(i) >= X{l}(k))
                if(k+1 > length(X{l}))
                    break
                else 
                    k = k+1;
                end
            end
            Yi(i) = Y{l}(k);
        end
    else
        for i=1:length(Xi)
            k = 1;
            while(Xi(i) >= X{l}(k))
                if(k+1 > length(X{l}))
                    break
                else 
                    k = k+1;
                end
            end
            Yi(i) = Y{l}(k-1)+(Y{l}(k)-Y{l}(k-1))*...
                (Xi(i)-X{l}(k-1))/(X{l}(k)-X{l}(k-1));
        end
        set(gca,'YDir','reverse')
    end
    
    h1 = area(X{l},Y{l},'EdgeColor',boje(m{l},1:3),...
        'LineWidth',2);
    h2 = stem(Xi,Yi,'Marker','none');
    h3 = plot([X{l}(1),X{l}(end)],[0,0],'Color',boje(m{l},1:3),...
        'LineWidth',2);
    set(h1,'FaceColor',[1,1,1]);
    set(h2,'Color',boje(m{l},1:3));
    xlabel(od{2*l-1}); ylabel(od{2*l});
    [Ymax,Xmaxi] = max(abs(Y{l}));
    if(Ymax ~= 0)
        axis([X{l}(1) X{l}(end) -Ymax*1.3 Ymax*1.3]);
    else
         axis([X{l}(1) X{l}(end) -1 1]);
    end
    Ymax = Y{l}(Xmaxi); Xmax = X{l}(Xmaxi);
    set(gca,'FontSize',20)
    set(gca,'Fontname','CMU Serif')
end
subplot(3,1,1);
title({[n],[' ']});
end
