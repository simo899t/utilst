# Changelog

All notable changes to `funcst` are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/);
this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-09-06

### Added
- Initial release, split out of `sdust`:
  - Theorem-style cards: `theorem`, `definition`, `example`, `proof`,
    `corollary`, `block`, and the `QED` tombstone.
  - Exercise cards: `question`, `answer`.
  - Plotting: `plot2d`, `plot3d`, and `formula` (evaluate a plain math
    string like `"x^2 + sin(y)"` as a callable).
  - `tree` (tidy proof/AST trees), `pseudo` (pseudocode), `graph`
    (node/edge diagrams), `tex` (inline LaTeX math).
  - `group-by-pairs` helper.
- Re-exports `rule` / `prooftree` (curryst) and all of `h-graph`.
