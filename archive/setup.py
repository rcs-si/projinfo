'''
following a template here so not
rly sure what info to put for 
some things LOL
'''

from setuptools import setup, find_packages

#load in readme_contents for the long_description later
with open("README.md", "r", encoding="utf-8") as readme_file:
    readme_contents = readme_file.read()

setup(
    name="projinfo",
    version="1.0.0",
    author="Ting Liu",
    author_email="tinglliu@bu.edu",
    description="A command line tool for the RCS Apps team to quickly access project and PI information",
    long_description="readme_contents",
    long_description_content_type="text/markdown",
    url="https://github.com/rcs-si/projinfo",
    packages=find_packages(),
    install_requires=[
        "pandas",
        "argparse",
    ],
    classifiers=[
        "Programming Language :: Python :: 3",
        "License ::", #i dont know what license to put i think people usually use the MIT one but idk since this isnt a personal thing im distributing
        "Operating System :: OS Independent",
    ],
    entry_points={
        "console_scripts": [
            "function = func.func:main",
        ]
    }
)