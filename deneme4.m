% xte tıklandığında değiştiriyor.
% molanın son 3 snsi 3 2 1 geri sayıyor

% süresi sıkıntılı
% O gösterilirken ki tıklamaları saymıyor
[r1, r2] = performance_vigilance_test();

function [results1, results2] = performance_vigilance_test()
    % Test süreleri
    test_duration = 10; % (saniye) 3 dakika
    break_duration = 10; % (saniye) 1 dakika

    % X işareti gösterim frekansı (saniye aralığı)
    min_frequency = 0.5; % minimum 5 saniye
    max_frequency = 5; % maksimum 20 saniye

    % Deney sonuçlarını saklamak için yapılar oluştur
    results1 = run_test(test_duration, min_frequency, max_frequency);
    display_break(break_duration);
    results2 = run_test(test_duration, min_frequency, max_frequency);

    % Sonuçları analiz et ve göster
    analyze_results(results1, results2, test_duration);
end

function results = run_test(test_duration, min_frequency, max_frequency)
    % Ekranı hazırla
    figure('Name', 'Performance Vigilance Test', 'NumberTitle', 'off');
    axis off;
    hold on;

    % O işaretini göster ve test süresini başlat
    text(0.5, 0.5, 'O', 'FontSize', 96, 'HorizontalAlignment', 'center');
    drawnow;
    test_start = tic

    % Reaksiyon zamanlarını kaydetmek için boş vektörler
    o_times = [];
    x_times = [];
    click_times = [];
    reaction_times = [];

    % O işaretini gösterme zamanı kaydet (BUNA GEREK YOK)
    o_time = toc(test_start);
    o_times(end+1) = o_time;

    % Test süresi boyunca devam et
    while toc(test_start) < test_duration
        % X işareti gösterme zamanı belirle
        x_delay = min_frequency + (max_frequency - min_frequency) * rand;

        % Kalan süreyi kontrol et
        remaining_time = test_duration - toc(test_start);
        if remaining_time < x_delay
            x_delay = x_delay - remaining_time;    
        end

        pause(x_delay);
        x_time = toc(test_start);

        % X işaretini göster
        cla;
        text(0.5, 0.5, 'X', 'Color', 'r', 'FontSize', 96, 'HorizontalAlignment', 'center');
        drawnow;

        % Tıklamayı bekle ve zamanı kaydet
        click_time = NaN;
        waitforbuttonpress; % tıklamayı bekle
        click_time = toc(test_start);

        % Verileri kaydet
        x_times(end+1) = x_time;
        if ~isnan(click_time)
            click_times(end+1) = click_time;
            reaction_times(end+1) = click_time - x_time;
        end

        % O işaretini geri getir
        cla;
        text(0.5, 0.5, 'O', 'FontSize', 96, 'HorizontalAlignment', 'center');
        drawnow;
    end

    % Sonuçları kaydet
    results.o_times = o_times;
    results.x_times = x_times;
    results.click_times = click_times;
    results.reaction_times = reaction_times;
    % 
    % % Pencereyi kapat
    % close;
end

function display_break(break_duration)
    % Mola süresi boyunca ekranda "MOLA" yazısını göster
    figure('Name', 'Break', 'NumberTitle', 'off');
    axis off;
    hold on;

    break_start = tic;
    while toc(break_start) < break_duration - 3
        cla;
        text(0.5, 0.5, 'MOLA', 'FontSize', 96, 'HorizontalAlignment', 'center');
        drawnow;
        pause(0.1); % Kısa bir süre bekle
    end

    % Son üç saniye geri sayım yap
    for countdown = 3:-1:1
        cla;
        text(0.5, 0.5, num2str(countdown), 'FontSize', 96, 'HorizontalAlignment', 'center');
        drawnow;
        pause(1); % 1 saniye bekle
    end

    close;
end

function analyze_results(results1, results2, test_duration)
    % Ortalama reaksiyon sürelerini hesapla
    avg_reaction_time1 = mean(results1.reaction_times);
    avg_reaction_time2 = mean(results2.reaction_times);
    
    fprintf('1. Test Ort. Reaksiyon Süresi: %.3f saniye\n', avg_reaction_time1);
    fprintf('2. Test Ort. Reaksiyon Süresi: %.3f saniye\n', avg_reaction_time2);

    % Grafik oluştur
    figure;
    
    % 1. Test grafiği
    subplot(2, 1, 1);
    hold on;
    stem(results1.x_times, ones(size(results1.x_times)), 'r', 'filled');
    stem(results1.click_times, ones(size(results1.click_times)) * 2, 'b', 'filled');
    title('1. Test Zaman Grafiği');
    xlabel('Zaman (s)');
    ylabel('Olaylar');
    legend('X İşareti', 'Tıklama');
    hold off;
    
    % 2. Test grafiği
    subplot(2, 1, 2);
    hold on;
    stem(results2.x_times, ones(size(results2.x_times)), 'r', 'filled');
    stem(results2.click_times, ones(size(results2.click_times)) * 2, 'b', 'filled');
    title('2. Test Zaman Grafiği');
    xlabel('Zaman (s)');
    ylabel('Olaylar');
    legend('X İşareti', 'Tıklama');
    hold off;
end
