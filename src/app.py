#-*- coding: utf-8 -*-
from __future__ import print_function
from .TinyPNG import TinyPNG
import sys
import os
import getopt

def main():
    app_key = 'MWmX23aKKpW6wsJjVC3gW1YUhh6CDOID'
    try:
        opts, args = getopt.getopt(sys.argv[1:], 'hk:', ["help", "app_key="])
        for opt, value in opts:
            if opt in ['-h', '--help']:
                usage()
                exit(0)
            elif opt in ['-k', '--app_key']:
                app_key = value
            else:
                pass

        if len(sys.argv) > 1:
            tinyPNG = TinyPNG(app_key = app_key)
            args = sys.argv[1:]
            for path in args:
                tinyPNG.process(path)
        else:
            usage()
    except Exception as e:
        print('❗️❗️❗️ ', end='')
        print(e)
    finally:
        pass

                
    
def usage():
    help_msg = '''
NAME
    tiny - a tools for compressing image of PNG/JPEG

USAGE
    tiny [options] path

OPTIONS
    -h, --help              show help information
    -k, --app_key           use TinyPNG API with your own APP_KEY Registered on site: https://tinypng.com/developers

DESCRIPTION
    tiny can compress images or all images under a directory. It replace the original image file with result.

EXAMPLE

    1. compress an image file:

        $ tiny wz_flight_go.jpg 
        wz_flight_go.jpg
        👍👍👍Completed!!!!

    2. compress multiple image files:

        $ tiny *.jpg
        IMG_0325.jpg
        👍👍👍Completed!!!!
        IMG_0326.jpg
        👍👍👍Completed!!!!
        wz_flight_back.jpg
        👍👍👍Completed!!!!
        wz_flight_go.jpg
        👍👍👍Completed!!!!

    3. compress all images under a directory called test:

        $ tiny test/
        test/
        👍👍👍Completed!!!!
        
    '''
    print(help_msg)