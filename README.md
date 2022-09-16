# Jason Python Module Github
This repository is meant to be a simple example of how to create a python
module, which can then be imported into your python script, or use directly
from the terminal.

The idea is that you can download and play with this repository on your own
computer, and also use the files as a template for creating your own module.

![example_terminal_output](https://github.com/jasonbrudvik/jason_python_module_github/raw/main/screenshots/example_terminal_output.png)

## REPOSITORY FILE STRUCTURE
Here is a list of all the files and directories in this repository (other than
the .git directory):

```bash
├── CHANGELOG.md
├── CONTRIBUTING.md
├── development/
│   └── venv-requirements.yml
├── .github/
│   └── workflows/
│       └── publish-to-test-pypi.yml
├── .gitignore
├── jason_python_module_github/
│   ├── hello.py
│   ├── __init__.py
│   ├── __main__.py
│   └── utils.py
├── LICENSE
├── Makefile
├── README.md
├── screenshots/
│   └── example_terminal_output.png
├── setup.cfg
├── setup.py
├── tests/
│   ├── example_usage_hello.py
│   └── test_hello.py
└── tox.ini
```

The following sections will discuss the different files and what they do.

### PTYHON CODE
All your python code used for your application should go into a directory that
is named the same as the repository itself, so in the case of this example,
the python files are placed here:
```bash
└── jason_python_module_github/
    ├── hello.py
    ├── __init__.py
    ├── __main__.py
    └── utils.py
```

In this example, the heart of my module is the **hello.py** file - it contains
the primary function used in this simple application. One could also have
additional such files.

The **__init__.py** file is an empty file that is required when making a python
module.

The **__main__.py** file contains terminal command argument handling.  It's
only needed if you want to run your application from the terminal.  In this
example, terminal commands can be run like:
```bash
jason_python_module_github --hello Jason
```

The **utils.py** file contains some extra utilites that can be used by other
files.


## USING THIS MODULE
If you want to make use of this module, install it via pip into your virtual
environment.

If you don't have a virtual environment, you can make one with either pip
or conda.  I prefer conda:
```bash
wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
sh Miniconda3-py39_4.12.0-Linux-x86_64.sh -s -p venv -b
rm Miniconda3-py39_4.12.0-Linux-x86_64.sh
```

This will download  a small version conda (miniconda) and install it into
the directory venv/.

Now activate the environment:
```bash
source venv/bin/activate
```

And install jason_python_module_github via pip:
```bash
pip install -i https://test.pypi.org/simple/ jason-python-module-github
```

Note:  if this were installed on the real PyPi and not TestPyPi, then the
command would be the simpler and more familiar looking:
```bash
pip install jason_python_module_github
```

Now execute the "hello" function using the arguments "Jason" and "Florian":
```bash
jason_python_module_github --hello Jason Florian
```


## DEVELOPMENT WORK
If you would like to work on the code in this repository (modify it, fix
something, etc.) please see:

[CONTRIBUTING.md](CONTRIBUTING.md)
