from matplotlib import pyplot as plt
import numpy as np
import scipy
import scipy.signal as sig

def show_plot(i, ethal, noised, ntext, ncolor, filtered, ftext, fcolor):
    axes = plt.subplot(2, 2, i)
    axes.plot(x, ethal, label="Идеальный сигнал", color="r", linewidth=.8)
    axes.plot(x, noised, label=ntext, color=ncolor, linewidth=.8)
    axes.plot(x, filtered, label=ftext, color=fcolor, linewidth=.8)
    axes.set_xlabel("t")
    axes.set_ylabel("Амплитуда")
    axes.grid(True)
    axes.legend()

x = np.linspace(-10, 10, num=500)
signal = np.exp(-x ** 2)

impulse = (np.random.random(x.size) > 0.99) * np.random.random(x.size) * max(signal) * 0.2
gauss = np.random.normal(0, 0.05, size=x.size)

inoised = signal + impulse
gnoised = signal + gauss

reject_impul = np.abs(scipy.fft.fft(inoised)) > 5.0 * np.abs(scipy.fft.fft(impulse))
reject_filtered_impul = np.abs(scipy.fft.ifft(scipy.fft.fft(inoised) * reject_impul))
wiener_filtered_impul = sig.wiener(inoised)

rejectored_gauss = np.abs(scipy.fft.fft(gnoised)) > 5.0 * np.abs(scipy.fft.fft(gauss))
reject_filtered_gauss = np.abs(scipy.fft.ifft(scipy.fft.fft(gnoised) * rejectored_gauss))
wiener_filtered_gauss = sig.wiener(gnoised)

show_plot(1, signal, inoised, "Зашумленный сигнал", "g", wiener_filtered_impul, "Фильтр Винера", "b")
show_plot(2, signal, inoised, "Зашумленный сигнал", "g", reject_filtered_impul, "Режекторный фильтр", "b")

show_plot(3, signal, gnoised, "Зашумленный сигнал", "g", wiener_filtered_gauss, "Фильтр Винера", "b")
show_plot(4, signal, gnoised, "Зашумленный сигнал", "g", reject_filtered_gauss, "Режекторный фильтр", "b")

plt.figtext(0.5,0.5, "Сигнал с гауссовыми помехами", ha="center", va="top")
plt.figtext(0.5,0.95, "Сигнал с импульсными помехами", ha="center", va="top")
plt.subplots_adjust(hspace = 0.3 )

plt.show()