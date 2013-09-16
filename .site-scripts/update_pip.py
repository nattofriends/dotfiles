#!/usr/bin/python2.7

import pip
from subprocess import call

LOCAL = "/usr/local/lib/python2.7/dist-packages"
candidates = []

for dist in pip.get_installed_distributions():
    if dist.location == LOCAL:
        candidates.append(dist.key)

call("pip install -U " + " ".join(candidates), shell=True)
