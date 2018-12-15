#!/usr/bin/python

import numpy
import os
import sys

if len(sys.argv) == 2:
    src = sys.argv[1]
    opts = "-sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -q"

    pages = numpy.genfromtxt(src + ".pages", dtype="int", delimiter=",")

    for n in range(len(pages)):
        first = str(pages[n][0])
        last = str(pages[n][1])
        dest = ("Chapter-" + str(n + 1) + ".pdf ")

        cmd = ("gs " + opts + " -dFirstPage=" + first + " -dLastPage=" + last + " -sOutputFile=" + dest + src + " 2>/dev/null")
        print(cmd)
        os.system(cmd)
