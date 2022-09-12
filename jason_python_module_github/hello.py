from .utils import LIGHTPURPLE, NC


def print_hello(name, svenska, debug):
    """ Print Hello to given names """

    if debug:
        print("name:  ", name)

    errors = []

    print("")
    print(LIGHTPURPLE, "*".center(80, "*"), NC)

    if not svenska:
        print("  Executing Hello:")
        print("  Hello", name, "!")
    else:
        print("  Exekvering hej:")
        print("  Hej", name, "!")

    print(LIGHTPURPLE, "*".center(80, "*"), NC)
    print("")

    return errors
