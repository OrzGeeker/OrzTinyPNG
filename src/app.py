
from .TinyPNG import TinyPNG
import sys
import os

#-*- coding: utf-8 -*-

def main():
    tinyPNG = TinyPNG()
    args = sys.argv[1:] if len(sys.argv) > 1 else os.getcwd()
    for path in args:
        tinyPNG.process(path)
                
    