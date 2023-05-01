function lab05
    % pkg install -forge statistics
    pkg load statistics % normrnd

    % pkg install -forge control
    % pkg install -forge signal
    pkg load signal % filtfilt

	% Входные параметры
	sigma = 0.5;

	% ОДЗ
	t_max = 5;
	dt = 0.01;
	t = -t_max:dt:t_max;

	% Генерация сигнала Гаусса
	x0 = gaussian(t, sigma);

	% Генерация Гауссовых помех
	NA = 0;
	NS = 0.05;
	n1 = normrnd(NA, NS, [1 length(x0)]);
	x1 = x0 + n1;

	% Генерация импульсных помех
	count = 7;
	M = 0.4;
	n2 = impulse_noise(length(x0), count, M);
	x2 = x0 + n2;

	% Фильтрация
	G = gaussian_filter_high(4, 20);
	B = butterworth_filter_high(6, 20);

	figure(3);

	plot_figure(1, t, x0, x1, x2, 'Исходные сигналы')
	plot_figure(2, t, x0, x1 - filtfilt(G, 1, x1), x2 - filtfilt(G, 1, x2), 'Фильтр Гаусса')
	plot_figure(3, t, x0, x1 - filtfilt(B, 1, x1), x2 - filtfilt(B, 1, x2), 'Фильтр Баттеруорта')
	end

	function plot_figure(i, t, x0, x1, x2, tit)
		subplot(3, 1, i);
		plot(t, x0, t, x1, t, x2);
		title(tit);
		legend('Без помех', 'Гауссовы помехи', 'Импульсные помехи');
	end

	% Gaussian pulse generation
	function y = gaussian(x, sigma)
		y = exp(-(x / sigma) .^ 2);
	end

	% Impulsive noise generation
	function y = impulse_noise(size, N, mult)
		step = floor(size / N);
		y = zeros(1, size);
		for i = 1:floor(N / 2)
			y(round(size / 2) + i * step) = mult * (0.5 + rand);
			y(round(size / 2) - i * step) = mult * (0.5 + rand);
		end
	end

	function y = butterworth_filter_high(D, size)
		x = linspace(-size / 2, size / 2, size);
		y = 1 ./ (1 + (D ./ x).^4);
		y = y / sum(y);
	end

	function y = gaussian_filter_high(sigma, size)
		x = linspace(-size / 2, size / 2, size);
		y = 1 - exp(-x.^2 / (2 * sigma^2));
		y = y / sum(y);
	end
