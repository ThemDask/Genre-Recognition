#!/usr/bin/env python
"""
Sample script that uses the analysetopython module created using
MATLAB Compiler SDK.

Refer to the MATLAB Compiler SDK documentation for more information.
"""

from __future__ import print_function
import analysetopython
import matlab

my_analysetopython = analysetopython.initialize()

analysisOut = my_analysetopython.analyse()
print(analysisOut, sep='\n')

my_analysetopython.terminate()


# create function to return the genre value
def returngenre():
    return analysisOut
