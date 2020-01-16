#!/usr/bin/env python3
# -*- coding: UTF-8 -*-

"""Use Ghostscript to split a pdf file into individual sections.

This script assumes that you have python3, the python3-magic and python3-numpy
modules, and Ghostscript installed.

Accept a pdf file as input and split it into individual pdf files containing
each part, using section names and page number boundaries defined by the user.

There must be a file with the same name as the source pdf file with the file
extension ".pages" in the same directory as the source file, eg: a source file
named Book.pdf needs a corresponding ".pages" file named Book.pdf.pages. The
".pages" file should contain the name of each section with the first and last
pages of that section in the following format:

Chapter-1, 1, 20
Chapter-2, 21, 45
Chapter-3, 46, 75
Glossary, 76, 80
"""


from os import path, system
import sys

from magic import from_file
from numpy import genfromtxt


def pdf_split(pdf_source_file):
    """Use Ghostscript to split a pdf file into individual parts."""
    if not path.isfile(pdf_source_file):
        sys.exit(f"The pdf file {pdf_source_file} does not exist!")

    file_type = from_file(pdf_source_file)
    if "PDF document" not in file_type:
        sys.exit(f"The file {pdf_source_file} is not a valid pdf file!")

    pages_file = pdf_source_file + ".pages"
    if not path.isfile(pages_file):
        sys.exit(f"The pages file {pages_file} does not exist!")

    print(f"Splitting pdf file: {pdf_source_file}")

    try:
        pages = genfromtxt(pages_file, dtype="str", delimiter=", ")
    except ValueError as exception:
        print(f"The file {pages_file} is not a valid pages file!")
        sys.exit(exception)

    index = 0
    while index < len(pages):
        pdf_destination_file = pages[index][0] + ".pdf"
        first_page = pages[index][1]
        last_page = pages[index][2]
        index += 1

        if path.isfile(pdf_destination_file):
            print(f"The pdf file {pdf_destination_file} already exists.")
            continue

        print(
            "Splitting pages "
            + first_page
            + " to "
            + last_page
            + " into file: "
            + pdf_destination_file
        )

        system(
            "gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER -q"
            + " -dFirstPage="
            + first_page
            + " -dLastPage="
            + last_page
            + " -sOutputFile="
            + pdf_destination_file
            + " "
            + pdf_source_file
            + " 2>/dev/null"
        )


if __name__ == "__main__":
    if len(sys.argv) == 2:
        pdf_split(sys.argv[1])
