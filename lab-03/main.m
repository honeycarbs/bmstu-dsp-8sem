function main
	% Входные параметры
	c = 2.0;
	sigma = 1.0;

	% ОДЗ
	t_max = 5;
	dt = 0.05;
	t = -t_max:dt:t_max;

	% Генерация сигналов
	x1 = [rectangular(t, c) zeros(1, length(t))];
	x2 = [gaussian(t, sigma) zeros(1, length(t))];
	x3 = [rectangular(t, c/2) zeros(1, length(t))];
	x4 = [gaussian(t, sigma/2) zeros(1, length(t))];

	% Свертка
	% Фурье-образ взаимной свертки равен произведению Фурье-образов свертываемых функций.
	y1 = ifft(fft(x1) .* fft(x2)) * dt;
	y2 = ifft(fft(x1) .* fft(x3)) * dt;
	y3 = ifft(fft(x2) .* fft(x4)) * dt;

	% Нормализация свёртки
	start = fix((length(y1) - length(t)) / 2);	
	y1 = y1(start+1:start+length(t));
	y2 = y2(start+1:start+length(t));
	y3 = y3(start+1:start+length(t));

    figure(3);
	
	graph_figure(1, t, x1, x2, y1, 'R + G');
	graph_figure(2, t, x1, x3, y2, 'R + R');
	graph_figure(3, t, x2, x4, y3, 'G + G');

	% title('Реализация частотного алгоритма вычисления свертки');
end

function graph_figure(i, t, x1, x2, y, tit)
    subplot(3, 1, i);
	plot(t, x1(1:201), 'r', t, x2(1:201), 'b', t, y, 'k');
	set (gca, "xgrid", "on");
	title(['Свёртка ', tit]);
	legend('Сигнал 1', 'Сигнал 2', 'Свёртка');
end

% Rectangular pulse generation
function y = rectangular(x, c)
	y = zeros(size(x));
	y(abs(x) - c < 0) = 1;
	y(abs(x) == c) = 1/2;
end

% Gaussian pulse generation
function y = gaussian(x, sigma)
	y = exp(-(x / sigma) .^ 2);
end
