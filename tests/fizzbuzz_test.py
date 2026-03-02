import time

from hypothesis import given
from hypothesis import strategies as st

from fizzbuzz.fizzbuzz import fizzbuzz

positive_integers = st.integers(min_value=1)


@given(n=positive_integers.map(lambda n: n * 3).filter(lambda n: n % 5 != 0))
def test_returns_fizz_for_multiples_of_3(n: int) -> None:
    assert fizzbuzz(n) == "Fizz"


@given(n=positive_integers.map(lambda n: n * 5).filter(lambda n: n % 3 != 0))
def test_returns_buzz_for_multiples_of_5(n: int) -> None:
    assert fizzbuzz(n) == "Buzz"


@given(n=positive_integers.map(lambda n: n * 3 * 5))
def test_returns_fizzbuzz_for_multiples_of_3_and_5(n: int) -> None:
    assert fizzbuzz(n) == "FizzBuzz"


@given(n=positive_integers.filter(lambda n: n % 3 != 0 and n % 5 != 0))
def test_returns_number_for_non_multiples_of_3_or_5(n: int) -> None:
    assert fizzbuzz(n) == str(n)


@given(n=positive_integers)
def test_does_not_raise_exception_for_valid_inputs(n: int) -> None:
    fizzbuzz(n)  # Does not raise an exception


@given(n=positive_integers)
def test_returns_within_1_ms(n: int) -> None:
    # Other approaches:
    # - Measure the time taken, then document it as part of the function's contract
    # - Treat runtime as a metric to minimize within the constraints of the other checks

    start_time = time.time()

    fizzbuzz(n)

    end_time = time.time()
    milliseconds = (end_time - start_time) * 1000
    assert milliseconds < 1, f"fizzbuzz({n}) took too long to return: {milliseconds} ms"
