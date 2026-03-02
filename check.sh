#!/bin/bash
set -e

rm -rf mutants/ # Clean up any existing mutation testing results so they don't interfere with other checks

# If any file other than fizzbuzz.py is changed, fail the check
changed_files=$(git diff --name-only)
if [[ -n "$changed_files" && "$changed_files" != "src/fizzbuzz/fizzbuzz.py" ]]; then
  echo "Error: Only src/fizzbuzz/fizzbuzz.py should be changed. Please revert any other changes. Changed files:"
  echo "$changed_files"
  exit 1
fi

# If fizzbuzz.py imports any modules, fail the check
if grep -q "import" src/fizzbuzz/fizzbuzz.py; then
  echo "Error: Imports are not allowed. Please remove any import statements."
  exit 1
fi

# If fizzbuzz.py calls side-effectful builtins, fail the check
if grep -Eq "open|print|input|help|breakpoint|eval|exec|__import__|setattr|delattr" src/fizzbuzz/fizzbuzz.py; then
  echo "Error: Calls to side-effectful builtins (open, print, input, help, breakpoint, eval, exec, __import__, setattr, delattr) are not allowed in fizzbuzz.py."
  exit 1
fi

# Linting. A different programming language may not need this check.
if grep -q "noqa" src/fizzbuzz/fizzbuzz.py; then
  echo "Error: Linting exclusions (noqa) are not allowed. Please remove any noqa comments."
  exit 1
fi
uv run ruff check

# Type-checking. A different programming language may not need this check.
if grep -q "type: ignore" src/fizzbuzz/fizzbuzz.py; then
  echo "Error: Type-checking exclusions (type: ignore) are not allowed. Please remove any type: ignore comments."
  exit 1
fi
uv run pytest

# Mutation testing
if grep -q "pragma: no mutate" src/fizzbuzz/fizzbuzz.py; then
  echo "Error: Mutation testing exclusions (pragma: no mutate) are not allowed. Please remove any pragma: no mutate comments."
  exit 1
fi
trap 'rm -rf mutants/' EXIT # Ensure mutation-testing results are cleaned up after the script finishes
uv run mutmut run
results=$(uv run mutmut results 2>&1)
if [[ -n "$results" ]]; then
  echo "Error: Mutation testing failed. To see the details, run 'uv run mutmut run' to generate mutants, then 'uv run mutmut results' to view the results."
  echo "$results"
  exit 1
fi

# Pass
echo "All checks passed."
