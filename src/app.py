
from .TinyPNG import TinyPNG
import sys
import os

def main():
    dir = sys.argv[1] if len(sys.argv) > 1 else os.getcwd()
    tinyPNG = TinyPNG()
    for fpathe, _ , fs in os.walk(dir):
        for f in fs:
            print(f)
            filePath = os.path.join(fpathe,f)
            _, ext = os.path.splitext(filePath)
            if ext in ['.png', '.jpg', '.JPEG', '.PNG']:
                tinyPNG.compress(source = filePath, destination = filePath)
            else:
                print('Error Image Format!!!!')