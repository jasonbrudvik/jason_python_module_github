#!/usr/bin/env python
import argparse
import json
import sys

from .hello import print_hello
from .utils import NC, RED


def main():
    """The main function - usage and help, argument parsing"""

    # Setup arguments
    parser = argparse.ArgumentParser(
        description="Say hello to one or more people"
    )
    parser.add_argument(
        "names",
        nargs="*",
        help="The input names"
    )

    # Optional argumentas
    parser.add_argument(
        "-d", "--debug",
        action="store_true",
        help="Debug output"
    )
    parser.add_argument(
        "-s", "--svenska",
        action="store_true",
        help="Prata Svneska"
    )

    # Action arguments - one or more required
    action_arguments = parser.add_argument_group(
        "action arguments - one or more are required"
    )
    action_arguments.add_argument(
        "--hello",
        action="store_true",
        help="Execute hello function"
    )

    # Parse the input arguments
    args = parser.parse_args()
    args.debug and print("\nInput arguments:",
                         json.dumps(vars(args), indent=4), "\n")

    # Print help if no input names or command given
    if not args.hello:
        if not args.svenska:
            print(RED, "\nNo hello command given\n", NC)
        else:
            print(RED, "\nIngen hej commando givet\n", NC)
        args = parser.parse_args(["-h"])
        sys.exit()

    if args.names == []:
        if not args.svenska:
            print(RED, "\nNo names given\n", NC)
        else:
            print(RED, "\nInget namn givet\n", NC)
        args = parser.parse_args(["-h"])
        sys.exit()

    if args.hello:
        for name in args.names:
            print_hello(name, args.svenska, args.debug)


#######################
# RUN THE APPLICATION #
#######################

if __name__ == "__main__":
    main()
