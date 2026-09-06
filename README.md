# funcst

General-purpose academic Typst toolkit — the reusable, institution-agnostic
building blocks that used to live in [sdust](https://github.com/simo899t/sdust):

- **Theorem-style cards** — `theorem`, `definition`, `example`, `proof`,
  `corollary`, `block`, plus the `QED` tombstone.
- **Exercise cards** — `question`, `answer`.
- **Plotting** — `plot2d`, `plot3d`, and `formula` (evaluate a plain math
  string such as `"x^2 + sin(y)"` as a callable).
- **`tree`** — tidy proof / AST trees (via `tdtr`).
- **`pseudo`** — pseudocode blocks (via `lovelace`).
- **`graph`** — node/edge diagrams (via `fletcher`).
- **`tex`** — inline LaTeX math (via `mitex`).

Nothing here sets document-level styles or page layout — drop these into any
document, under any template. For SDU-branded document frontpages (thesis,
report, exam, project, …) use [sdust](https://github.com/simo899t/sdust).

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
git clone https://github.com/simo899t/funcst ~/GitHub/funcst
mkdir -p ~/Library/Application\ Support/typst/packages/local/funcst
ln -s ~/GitHub/funcst ~/Library/Application\ Support/typst/packages/local/funcst/0.1.0
```

## Usage

```typst
#import "@preview/funcst:0.1.0": *

#theorem(title: "Theorem 1")[For all $x$, $x = x$.]

#plot2d(f: "sin(x)", x: (0, 2 * calc.pi))
```
