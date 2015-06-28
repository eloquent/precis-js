# Contributing

**PRECIS-JS** is open source software; contributions from the community are
encouraged. Please take a moment to read these guidelines before submitting
changes.

## Tests

- Run the tests with `bin/test path/to/tests`, or simply `bin/test` to run the
  entire suite.
- Generate a coverage report with `bin/coverage` The coverage report will be
  created at `coverage/lcov-report/index.html`.

## Code style

Running the test suite will also check for code style. If you are submitting a
pull request, please make sure no errors or warnings are produced.

Yes, I use 4 spaces for CoffeeScript. Yes, I know that's non-standard.

## Branching and pull requests

As a guideline, please follow this process:

1. [Fork the repository].
2. Create a topic branch for the change, branching from **master**
(`git checkout -b branch-name master`).
3. Make the relevant changes.
4. [Squash] commits if necessary (`git rebase -i master`).
5. Submit a pull request to the **master** branch.

[Fork the repository]: https://help.github.com/articles/fork-a-repo
[Squash]: http://git-scm.com/book/en/v2/Git-Tools-Rewriting-History#Changing-Multiple-Commit-Messages
