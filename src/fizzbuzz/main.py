import sys

from fizzbuzz.fizzbuzz import fizzbuzz


def main() -> None:
    print(fizzbuzz(int(sys.argv[1])))
