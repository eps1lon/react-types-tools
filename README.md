# React Types Tools

## diff-react-dt-fork.sh

Ensures the forks for TypeScript before and after 5.0 do not get out of sync beyond what's accepted.

Usage:

```bash
$ cd path-to-dt-clone
$ ~/path-to-clone-of-this-report/diff-react-dt-fork.sh
# Either accept new diff baseline by committing changes to `diff-baseline.diff` or update the ts5.0 fork
```

## createReact18TypesFork.sh

Prepares React 19 types by forking current types into v18 and bumping version number.
Applies to `react`, `react-dom` and `react-is`

Usage:

```bash
$ cd path-to-dt-clone
$ ~/path-to-clone-of-this-report/createReact18TypesFork.sh
```
