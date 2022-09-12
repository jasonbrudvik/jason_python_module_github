from jason_python_module_github.hello import print_hello


def test_print_hello():
    """Execute hello with good input"""

    errors = print_hello("Jason", False, False)
    if not (errors == [] or errors is None):
        raise AssertionError
