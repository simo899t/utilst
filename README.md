# utilst

General-purpose academic Typst toolkit — institution-agnostic building
blocks for visualising functions and computation:

- **Plotting** — `plot2d`, `plot3d`, and `formula` (evaluate a plain math
  string such as `"x^2 + sin(y)"` as a callable).
- **`tree`** — tidy proof / AST trees (via `tdtr`).
- **`pseudo`** — pseudocode blocks (via `lovelace`).
- **`graph`** — node/edge diagrams (via `fletcher`).
- **`tex`** — inline LaTeX math (via `mitex`).
- Re-exports `rule` / `prooftree` (curryst) and all of `h-graph`.

Nothing here sets document-level styles or page layout — drop these into any
document, under any template. SDU-branded frontpages and theorem-style
cards live in [sdust](https://github.com/simo899t/sdust).

## Installation (local development)

Clone the repo, then symlink it into Typst's local package registry for
your OS:

| OS | Local package registry |
|---|---|
| macOS | `~/Library/Application Support/typst/packages/local` |
| Linux | `~/.local/share/typst/packages/local` (or `$XDG_DATA_HOME/typst/packages/local`) |
| Windows | `%APPDATA%\typst\packages\local` |

**macOS:**
```bash
git clone https://github.com/simo899t/utilst ~/GitHub/utilst
mkdir -p ~/Library/Application\ Support/typst/packages/local/utilst
ln -s ~/GitHub/utilst ~/Library/Application\ Support/typst/packages/local/utilst/0.1.0
```

## Usage

```typst
#import "@preview/utilst:0.1.0": *

#plot2d(f: "sin(x)", x: (0, 2 * calc.pi))
#tree[
  - Root
    - A
    - B
]
```
