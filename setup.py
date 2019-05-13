import setuptools

with open("README.md", "r") as fh:
    long_description = fh.read()

setuptools.setup(
    name="OrzTinyPNG",
    version="0.0.2",
    author="wangzhizhou",
    author_email="824219521@qq.com",
    description="A tool for compress image such as png and jpg using TinyPNG API",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/OrzGeeker/OrzTinyPNG",
    packages=setuptools.find_packages(),
    # all classifiers: https://pypi.org/classifiers/
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: OS Independent",
    ],
    python_requires='>=2.7, <4',
    install_requires=[
        'twine',
        'tinify'
    ],
    entry_points = {
        'console_scripts': [
            'tiny = src:main'
        ]
    }
)
