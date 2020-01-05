#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

"""Print a random number."""

from sys import argv
from random import randint


def rando(low, high):
    """Print a random number between low and high."""
    if high > low >= 0:
        print(randint(low, high))


if __name__ == "__main__":
    if len(argv) == 3:
        rando(int(argv[1]), int(argv[2]))
