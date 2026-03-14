# fizzbuzz-without-human-review

This repo is a companion piece to the essay "<a href="https://peterlavigne.com/writing/verifying-ai-generated-code">Toward automated verification of unreviewed AI-generated code</a>."

The repo provides quality checks, but no implementation, for the following simplified fizzbuzz problem:

```
Given a positive integer, N, return:
- "Fizz" if N is divisible by 3,
- "Buzz" if N is divisible by 5,
- "FizzBuzz" if N is divisible by both 3 and 5
- N as a string, if none of the above conditions are true
```

# Setup

1. [Install uv](https://docs.astral.sh/uv/getting-started/installation/)
2. Run `uv sync` to install dependencies
3. Run `./check.sh` to ensure checks are working. You should see an "Unused function argument" linter error.

# Usage

Familiarize yourself with the test code in [tests/fizzbuzz_test.py](tests/fizzbuzz_test.py) and the checks in [check.sh](check.sh).

Using your AI coding agent of choice, ask it to do the following:

```
Implement `src/fizzbuzz/fizzbuzz.py`, getting all checks in `check.sh` to pass. If you cannot get all checks to pass, instead explain why the requirements are unsatisfiable.
```

Allow it to finish. Do not review the output code.

Ensure `./check.sh` passes. If it does not, try again, possibly with a stronger coding agent.

Now, ask yourself: Without reviewing this code, do you trust it? Why or why not? You can run `uv run fizzbuzz <input>` to run the program.
