#!/usr/bin/env python3
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.ticker import FuncFormatter


def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        ax.annotate(str(round(float(height), 1)),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 1),
                    textcoords="offset points",
                    ha='center', va='bottom')


titles = {
    "results/zplug-inst.txt": "zplug",
    "results/zgen-inst.txt": "zgen",
    "results/zi-light-inst.txt": "zi light",
    "results/zi-load-inst.txt": "zi load",
    "results/zi-turbo-inst.txt": "zi (Turbo) load",

    "results/zplug.txt": "zplug",
    "results/zgen.txt": "zgen",
    "results/zi-light.txt": "zi light",
    "results/zi-load.txt": "zi load",
    "results/zi-turbo.txt": "zi (Turbo) load",
}

files_inst = [
    "results/zplug-inst.txt",
    "results/zgen-inst.txt",
    "results/zi-light-inst.txt",
    "results/zi-load-inst.txt",
    "results/zi-turbo-inst.txt",
]

files_startup = [
    "results/zplug.txt",
    "results/zgen.txt",
    "results/zi-light.txt",
    "results/zi-load.txt",
    "results/zi-turbo.txt",
]

#
# Installation-times plot
#

data = {}
for fname in files_inst:
    odd = 0

    file = open(fname, "r")
    lines = file.readlines()
    file.close()

    idata = []
    for line in lines:
        if fname == "results/zplug-inst.txt" or fname == "results/zi-turbo-inst.txt":
            odd = 1 - odd
            if not odd:
                fields = line.split()
                idata.append(float(fields[-2]) / 1000.0)
        else:
            fields = line.split()
            idata.append(float(fields[-2]) / 1000.0)

    mean = np.mean(idata)
    data[titles[fname]] = mean

group_data = list(data.values())
group_names = list(data.keys())

fig, ax = plt.subplots(figsize=(8.2, 5))
rects = ax.bar(group_names, group_data)

# Add a vertical line, here we set the style in the function call
#ax.axhline(mean, ls='--', color='r')

# Now we'll move our title up since it's getting a little cramped
ax.title.set(y=1.05)

autolabel(rects)

# fig.tight_layout()

plt.title("Installation time, in seconds")

fig.savefig('plots/installation-times.png',
            transparent=False, dpi=140, bbox_inches="tight")

plt.show()

#
# Startup-times plot
#

data = {}
for fname in files_startup:
    odd = 0

    file = open(fname, "r")
    lines = file.readlines()
    file.close()

    idata = []
    for line in lines:
        if fname == "results/zi.txt":
            odd = 1 - odd
            if not odd:
                fields = line.split()
                idata.append(float(fields[-2]))
        else:
            fields = line.split()
            idata.append(float(fields[-2]))

    mean = np.mean(idata)
    data[titles[fname]] = mean

group_data = list(data.values())
group_names = list(data.keys())

fig, ax = plt.subplots(figsize=(8.2, 5))
rects = ax.bar(group_names, group_data)

autolabel(rects)

# fig.tight_layout()

# Add a vertical line, here we set the style in the function call
#ax.axhline(mean, ls='--', color='r')

# Now we'll move our title up since it's getting a little cramped
ax.title.set(y=1.05)

plt.title("Startup time, in milliseconds")

fig.savefig('plots/startup-times.png', transparent=False,
            dpi=140, bbox_inches="tight")

plt.show()
