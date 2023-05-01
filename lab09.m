% function lab09()
%     pkg load image

%     image=double(imread('bimage5.bmp')) / 255;
%     cepstrum = get_cepstrum(image, 170)

%     figure;
%     imshow(mat2gray(1+abs(cepstrum)));

% end

% function cepstrum = get_cepstrum(image, brightness_const)
%     image_fft = fft(image)
%     cepstrum = brightness_const * log(1 + abs(power(image_fft, 2)))
% end

function lab09
    pkg load image
    pkg load signal

    I = imread('bimage5.bmp');

    figure(4);

    subplot(4,1,1);
    imshow(I);title('Изображение');

    spectrum = fftshift(fft2(I));

    W = spectrum .* spectrum;

    cepstrum = 1/5*log(1 + abs(W));

    subplot(4,1,2);
    imshow(mat2gray(1+abs(cepstrum)));title('Кепстр');

    [maxVal, maxIdx] = max(cepstrum(:));
    [maxRow, maxCol] = ind2sub(size(cepstrum), maxIdx);

    N = size(I);
    P = [maxCol - N(2)/2, N(1)/2 - maxRow];
    theta = atan2(P(2), P(1)) * 180/pi;

    central_row = cepstrum(maxRow,:);

    len = size(central_row);

    half_row = central_row(len(2)/2:end);

    [pks, locs] = findpeaks(half_row);

    c = 6;
    a = c * sind(abs(theta));
    b = sqrt(c * c - a * a);

    PSF = fspecial('motion', 5, -26);

    [output, kernel] = deconvlucy(I, PSF, 100);

    subplot(4,1,3);
    imshow(output);title('Результат');
end

