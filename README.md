# test prs with branch filter on circle ci
Branch filtering appears to prevent CircleCi from running tests. For example,
- https://github.com/sdolenc/circle_ci_experiments/pull/4 and
- https://github.com/sdolenc/circle_ci_experiments/pull/5

say "Waiting for status to be reported"

This is a simple workaround for these types of issues. It checks if either the head branch or base branch are in the list of filtered branches before running test. Branches that are NOT in the filter will "no-op" and fast exit.

Feel free to borrow concepts, fork, open issues, and contribute as you see fit.
