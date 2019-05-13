#-*- coding: utf-8 -*-
import tinify
import os

class TinyPNG:

    def __init__(self, app_key):
        tinify.key = app_key

    def compress(self,source, destination):
        source = tinify.from_file(source)
        source.to_file(destination)

    def compressDir(self, dir):
        for fpathe, _ , fs in os.walk(dir):
            for f in fs:
                filePath = os.path.join(fpathe,f)
                self.compressFile(filePath)

    def compressFile(self,filePath):
        _, ext = os.path.splitext(filePath)
        if ext in ['.png', '.jpg', '.JPEG', '.PNG', '.jpeg']:
            self.compress(source = filePath, destination = filePath)
        else:
            print('💥💥💥Unsupported Image Format!!!!')

    def process(self, path):
        print(path)
        try:
            # Use the Tinify API client.
            if os.path.exists(path):
                if os.path.isdir(path):
                    self.compressDir(path)
                else:
                    self.compressFile(path)
                print('👍👍👍Completed!!!!')
            else:
                print('💥💥💥Not Exist!!!!')

        except tinify.AccountError, e:
            # Verify your API key and account limit.
            print("The error message is: %s" % e.message)
        except tinify.ClientError, e:
            # Check your source image and request options.
            print("The error message is: %s" % e.message)
        except tinify.ServerError, e:
            # Temporary issue with the Tinify API.
            print("The error message is: %s" % e.message)
            pass
        except tinify.ConnectionError, e:
            # A network connection error occurred.
            print("The error message is: %s" % e.message)
        except Exception, e:
            # Something else went wrong, unrelated to the Tinify API.
            print("The error message is: %s" % e.message)