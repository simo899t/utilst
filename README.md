# utilst

General-purpose academic Typst toolkit — institution-agnostic building
blocks for visualising functions and computation:

- **Plotting** — `plot2d`, `plot3d`, and `formula` (evaluate a plain math
  string such as `"x^2 + sin(y)"` as a callable).
- **`tree`** — tidy proof / AST trees (via `tdtr`).
- **`pseudo`** — pseudocode blocks (via `lovelace`).
- **`graph`** — node/edge diagrams (via `fletcher`).
- **`tex`** — inline LaTeX math (via `mitex`).
- **`code-style`** / **`simple-code`** — fancy code-block styling (via
  `codly`): `#show: code-style` for a language-coloured tab, icon, zebra
  striping and rounded block; wrap a region in `#simple-code[...]` to opt out.
- Re-exports `rule` / `prooftree` (curryst) and all of `h-graph`.

Everything except `code-style` is a drop-in element — no document-level
styles or page layout. SDU-branded frontpages and theorem-style cards live
in [sdust](https://github.com/simo899t/sdust).

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


### graphing function
```typst
#import "@preview/utilst:0.1.0": *

#figure(
  plot2d(f: "sin(x)", x: (0, 6.28)),
  caption: [This is a graph example using utilst],
)
```
<img width="365" height="259" alt="sin(x)" src="https://github.com/user-attachments/assets/50fd34b5-7998-4173-be9f-b48dac1e3586" />


### graphing nodes and edges
```typst
#import "@preview/utilst:0.1.0": *

#figure(
  graph(
  nodes: ((pos: (0,0), label: $1$), (pos: (1,1), label: $2$)),
  edges: (((0,0), (1,1)),),
),
  caption: [This is a graph],
)
```
<img width="365" height="150" alt="undirrectedgraph" src="https://github.com/user-attachments/assets/75c6ca38-e698-4d8a-9a64-4a82f35170af" />

### proof trees
```typst
#import "@preview/utilst:0.1.0": *

#figure(
  prooftree(rule(
  label: [],
  name: [Barbara],

  [#prooftree(rule(
    label: [],
    name: [Barbara],

    [All $M$ are $P$],
    [All $S$ are $M$],
    [All $S$ are $P$],
  ))],

  [All $P$ are $Q$],
  [All $S$ are $Q$],
))
  ,
  gap: 2em,
  caption: [This is a prooftree example],
)
```
<img width="365" height="99" alt="currysttree" src="https://github.com/user-attachments/assets/cc41b0ce-8ee8-4269-b3e4-be7208c75012" />

### regular trees
```typst
#import "@preview/utilst:0.1.0": *

#figure(
  scale(200%)[
    #tree(
  shape: "rect",
  edges: "square",
)[
  - Root
    - A
    - B
]], 
  gap: 4em,
  caption: [This is a scaled tree graph],
)
```
<img width="365" height="134" alt="Skærmbillede 2026-09-07 kl  11 50 35" src="https://github.com/user-attachments/assets/ead785f4-5f44-479e-b6a9-13a52da91574" />




