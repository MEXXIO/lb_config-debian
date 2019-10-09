#!/usr/bin/python

import sys
from random import randint

if len(sys.argv) == 3:
    n = [int(sys.argv[1]), int(sys.argv[2])]
    if n[0] >= 0 and n[1] > n[0]:
        print randint(n[0], n[1])
