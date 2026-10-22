%% 
%% Gezgin Satici Problemi - Ege Bolgesi
clear; clc; close all;

% Sehirler ve Koordinatlar
sehirler = {'Izmir', 'Manisa', 'Aydin', 'Mugla', 'Denizli', 'Usak', 'Afyon', 'Kutahya'};

noktalar = [
    38.4189, 27.1287; % Izmir
    38.6146, 27.4287; % Manisa
    37.8444, 27.8458; % Aydin
    37.2155, 28.3637; % Mugla
    37.7745, 29.0945; % Denizli
    38.6823, 29.4082; % Usak
    38.7636, 30.5456; % Afyon
    39.4242, 29.9833  % Kutahya
];

N = 8; % Sehir sayisi

% Sehirler arasi mesafe
D = zeros(N, N);
for i = 1:N
    for j = 1:N
        dx = noktalar(i,1) - noktalar(j,1);
        dy = noktalar(i,2) - noktalar(j,2);
        D(i,j) = sqrt(dx^2 + dy^2);
    end
end

% Parametreler
pop_sayisi = 40;
nesil_sayisi = 120;
mutasyon_sansi = 0.05;

% Ilk populasyon
pop = zeros(pop_sayisi, N);
for i = 1:pop_sayisi
    pop(i,:) = randperm(N);
end

en_iyi_mesafe = 100000;
en_iyi_rota = [];

% Dongu
for nesil = 1:nesil_sayisi
    
    % Mesafe hesabi
    mesafeler = zeros(pop_sayisi, 1);
    for i = 1:pop_sayisi
        yol = pop(i,:);
        toplam = 0;
        for k = 1:N-1
            toplam = toplam + D(yol(k), yol(k+1));
        end
        toplam = toplam + D(yol(N), yol(1)); % basa donus
        mesafeler(i) = toplam;
        
        if toplam < en_iyi_mesafe
            en_iyi_mesafe = toplam;
            en_iyi_rota = yol;
        end
    end
    
    % En iyileri secme (Basit secim)
    [~, sira] = sort(mesafeler);
    pop = pop(sira, :); % Mesafesi kisa olanlar basa gecer
    
    % Caprazlama (Crossover)
    yeni_pop = pop;
    for i = 1:2:pop_sayisi-1
        p1 = pop(i,:);
        p2 = pop(i+1,:);
        
        kesim = randi([2, N-2]);
        c1 = [p1(1:kesim), setdiff(p2, p1(1:kesim), 'stable')];
        c2 = [p2(1:kesim), setdiff(p1, p2(1:kesim), 'stable')];
        
        yeni_pop(i,:) = c1;
        yeni_pop(i+1,:) = c2;
    end
    
    % Mutasyon (Iki sehri yer degistirme)
    for i = 1:pop_sayisi
        if rand < mutasyon_sansi
            s1 = randi(N);
            s2 = randi(N);
            gecici = yeni_pop(i, s1);
            yeni_pop(i, s1) = yeni_pop(i, s2);
            yeni_pop(i, s2) = gecici;
        end
    end
    
    pop = yeni_pop;
end

% Basit Cizim
figure;
son_rota = [en_iyi_rota, en_iyi_rota(1)];
plot(noktalar(son_rota, 2), noktalar(son_rota, 1), 'bo-');
grid on;
title(['En Kisa Yol: ', num2str(en_iyi_mesafe)]);
xlabel('Boylam');
ylabel('Enlem');

for i = 1:N
    text(noktalar(i,2), noktalar(i,1), sehirler{i});
end