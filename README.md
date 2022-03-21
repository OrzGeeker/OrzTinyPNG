# OrzTinyPNG

The Command Line Tool For Compress Image of JPG/PNG/WebP Format

There are two editions written by `Swift/Python` language separately

## Installation

### The Python Edition Installation

Run command line as follow to install python edition of OrzTinyPNG

```base
python3 -m pip install pip_search && python3 -m pip install OrzTinyPNG
```

#### Usage of Python Edition

check the python edition OrzTinyPNG help with running command as follow in terminal:

```bash
$ tiny
```

### The Swift Edition Installation on MacOS

1. Install `Homebrew` follow guide on the office website: <https://brew.sh/>

2. After Install `Homebrew` successfully. Run Commands as follow in Terminal:

```bash
brew tap orzgeeker/orzgeeker && brew install orztinypng
```

#### Usage of Swift Edition

1. compress an image in-place

```bash
$ tiny <image_file_path>
```

2. compress an image to other place

```bash
$ tiny <input_image_file_path> -o <output_image_file_path>
```

3. compress images in a directory recursively in-place

```bash
$ tiny <directory_path>
```

4. compress images in a directory recursively to other directory

```bash
$ tiny <directory_path> -o <dst_directory_path>
```

5. compress images in current directory recursively in-place

```bash
$ tiny .
```

# How to Write Markdown Documentation

[Github-flavored Markdown](https://guides.github.com/features/mastering-markdown/)
to write your content.

# Choose Your License

[Choose a License for your self](https://choosealicense.com)

# References

- [TinyPNG 官网](https://tinypng.com/)
- [TinyPNG API Key](https://tinypng.com/developers)
- [TinyPNG API Ref](https://tinypng.com/developers/reference)
- [TinyPNG Python API Doc](https://tinypng.com/developers/reference/python)
