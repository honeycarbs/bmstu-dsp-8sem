import numpy as np
import matplotlib.pyplot as plt

def lab08():
    t_max = 3
    dt = 0.05
    x = np.arange(-t_max, t_max+dt, dt)
    yx = gaussian(x)
    uxbase = gaussian(x)
    ux = gaussian(x)
    N = len(yx)

    a = 0.25
    epsv = 0.05

    px = a * np.random.rand(20)

    pos = [25, 35, 40, 54, 67, 75, 95]
    pxx = len(pos)

    for i in range(pxx):
        ux[pos[i]] += px[i]
        uxbase[pos[i]] += px[i]

    for i in range(N):
        smthm = mean(ux, i)
        if abs(ux[i] - smthm) > epsv:
            ux[i] = smthm

    plt.figure(2)

    plot_figure(1, x, uxbase, ux, 'Mean')

    uxbase = gaussian(x)
    ux = gaussian(x)

    for i in range(pxx):
        ux[pos[i]] += px[i]
        uxbase[pos[i]] += px[i]

    for i in range(N):
        smthm = med(uxbase, i)
        if abs(ux[i] - smthm) > epsv:
            ux[i] = smthm

    plot_figure(2, x, uxbase, ux, 'Med')

    plt.show()

def med(ux, i):
    imin = i - 1
    imax = i + 1
    if imin < 0:
        return ux[imax]
    else:
        if imax >= len(ux):
            return ux[imin]
        else:
            return min(ux[imin], ux[imax])
    # elif imax >= len(ux):
    #     return ux[imin]
    # else:
    #     return min(ux[imin], ux[imax])

def mean(ux, i):
    r = 0
    imin = i - 2
    imax = i + 2
    for j in range(imin, imax + 1):
        if j >= 0 and j < (len(ux)):
            r = r + ux[j]
    r = r / 5
    y = r
    return y

def gaussian(x):
    A = 1.0
    sigma = 1.0
    y = A * np.exp(-x**2 / sigma**2)
    return y

def plot_figure(i, x, y, u, tit):
    plt.subplot(2, 1, i)
    plt.plot(x, y, x, u)
    plt.title(tit)
    plt.legend(['Исходный сигнал', 'Сглаженный сигнал'])


lab08()