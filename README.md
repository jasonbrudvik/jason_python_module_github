# Jason Python Module Github
This repository is made to be a simple example of how to create a python module

![maxiv](https://github.com/jasonbrudvik/jason_python_module_github/raw/main/screenshots/maxiv_purple_tint.jpg)

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
