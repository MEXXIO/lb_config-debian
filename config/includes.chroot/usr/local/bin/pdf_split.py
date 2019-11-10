#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

"""Use Ghostscript to split a pdf file into individual chapter files.

Accept a pdf file as input and split it into individual pdf files containing
each chapter, using page number boundaries defined by the user.

There must be a file with the same name as the source pdf file with the file
extension ".pages" in the same directory as the source file, eg: a source file
named Book.pdf needs a corresponding ".pages" file named Book.pdf.pages. The
".pages" file should contain the first and last pages of each chapter of the
book in the following format:

1, 20
21, 45
46, 75
"""


from os import system
from sys import argv

from numpy import genfromtxt


def pdf_split(pdf_source_file):
    """Use Ghostscript to split a pdf file into individual chapter files."""
    gs_options = "-sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -q"

    pages = genfromtxt(pdf_source_file + ".pages", dtype="int", delimiter=",")

    index = 0
    while index < len(pages):
        first_page = str(pages[index][0])
        last_page = str(pages[index][1])
        pdf_destination_file = "Chapter-" + str(index + 1) + ".pdf "
        index += 1

        gs_command = (
            "gs "
            + gs_options
            + " -dFirstPage="
            + first_page
            + " -dLastPage="
            + last_page
            + " -sOutputFile="
            + pdf_destination_file
            + pdf_source_file
            + " 2>/dev/null"
        )
        print(gs_command)
        system(gs_command)


if __name__ == "__main__":
    if len(argv) == 2:
        pdf_split(argv[1])
