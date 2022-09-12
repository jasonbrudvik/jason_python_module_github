# CONTRIUBUTING

Please help develop this module if you are interested!


## INSTALL FOR DEVELOPMENT
Follow the steps in the section in order to work on the code in this repository
(modify it, fix something, etc.), installing it in a way that allows you to
modify and test new code:

First, clone the repository:
```bash
git clone ....
```

Second, create a virtual environment to work in using conda:
```bash
make venv
```

Now activate that environment:
```bash
source venv/bin/activate

Look at the usage information for this module by typing it's name in the
terminal:
```
```bash
jason_python_module_github
```

Now execute the "hello" function using the arguments "Jason" and "Florian":
```bash
jason_python_module_github --hello Jason Florian
```

## TESTING

Some simple testing examples have been configured using pytest and tox.
The configuration file is here:

[tox.ini](tox.ini)

To see a list of available tests:
```bash
tox -l

    lint
    py36-build-cli-tests
    py37-build-cli-tests
    py38-build-cli-tests
    py39-build-cli-tests
    py36-hello-tests
    py37-hello-tests
    py38-hello-tests
    py39-hello-tests
    py36-bye-tests
    py37-bye-tests
    py38-bye-tests
    py39-bye-tests
```

Then to execute one of them:
```bash
tox -e py39-build
```
This builds the python module using python version 3.9, and gives a report in
the end if it was successful or not.


```bash
tox -e py36-hello-tests
```
This test command installs python 3.6 and then executes the "hello" command,
via tests/test_hello.py:
```py
from jason_python_module_github.hello import print_hello


def test_print_hello():
    """Execute hello with good input"""

    errors = print_hello("Jason", False, False)
    if not (errors == [] or errors is None):
        raise AssertionError
```

Following these examples, you can set up tests of other functions using
various versions of python.

The Makfile contains shortcuts for running groups of these tests:



## LINTING

To check that code you have written meets certain python style guidelines
concerning things like number of spaces, empty lines, line length, etc. run
the following tests:

```bash
make tox-lint
```

This in turns run the following fomr the Makefile:

```bash
source $(VENV)/bin/activate
tox -r -e lint
```

Where the related tox command settings are set here:

[tox.ini](tox.ini)

```markdown
# flake8 configuration
[flake8]
exclude = .env,.venv,venv,.tox,.eggs,.git,__pycache__,
    docs/source/conf.py,old,build,dist
max-line-length = 80
max-complexity = 10

# Lint python code
[testenv:lint]
basepython = python3.9
skip_install = true
deps = flake8
commands = flake8
```

