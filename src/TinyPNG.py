
import tinify

class TinyPNG:

    def __init__(self, app_key = 'MWmX23aKKpW6wsJjVC3gW1YUhh6CDOID'):
        tinify.key = app_key

    def compress(self,source, destination):
        source = tinify.from_file(source)
        source.to_file(destination)