function lab07
    % pkg install -forge statistics
    pkg load statistics % normrnd

    % pkg install -forge control
    % pkg install -forge signal
    pkg load signal % filtfilt
	% Входные параметры
	A = 1.0;
	sigma1 = 1.0;
	sigma2 = 2.0;

	% ОДЗ
	t_max = 6;
	dt = 0.01;
	t = -t_max:dt:t_max;

	% Генерация сигнала Гаусса
	u1 = gaussian(t, A, sigma1);
	u2 = gaussian(t, A, sigma2);

	v1 = fft(u1);
	v2 = fft(u2);

	% Генерация помех
	NS = 0.05;
	n1 = unifrnd(-NS, NS, 1, length(t));
	n2 = unifrnd(-NS, NS, 1, length(t));

	x1 = u1 + n1;
	x2 = u2 + n2;

	delta = std(n1);
	epsilon = std(n2);

	figure(1);
	plot(t, x1, t, x2, t, abs(ifft(fft(x2) .* tikhonfilt(v1, v2, dt, 2 * t_max, delta, epsilon))));
	legend('U_1', 'U_2', 'Фильтр сигнала');
end

% Gaussian pulse generation
function y = gaussian(x, A, sigma)
	y = A * exp(-(x / sigma) .^ 2);
end

function h = tikhonfilt(u1, u2, dt, T, d, e)
	m = 0:length(u1)-1;
	t_max = dt / length(u1);
	squ = 1 + (2 * pi * m / T).^2;
	func = @(x) rhofunc(x, u1, u2, dt, T, d, e);
	alpha = fzero(func, [0, 1]);
	h = 0:length(u1)-1;
	for k = 1:length(h)
		h(k) = t_max * sum(exp(2 * pi * 1i * k .* m / length(u1)) .* u1 .* conj(u2) ./ (abs(u2).^2 .* dt^2 + alpha * squ), 2);
	end
end

function y = rhofunc(x, u1, u2, step, T, d, e)
	m = 0:length(u1)-1;
	mult = step / length(u1);
	squ = 1 + (2 * pi * m / T).^2;
	beta = mult * sum(x.^2 * squ .* abs(u1).^2 ./ (abs(u2).^2 * step^2 + x .* squ).^2, 2);
	gamma = mult * sum(abs(u2).^2 * step^2 .* abs(u1).^2 .* squ ./ (abs(u2).^2 * step^2 + x * (1 + 2 * pi * m / T).^2).^2, 2);
	y = beta - (d + e * sqrt(gamma))^2;
end
