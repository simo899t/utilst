// funcst — general-purpose academic Typst toolkit.
//
// Theorem-style cards, exercise cards, function plotting, proof/AST trees,
// pseudocode, node graphs, and inline LaTeX math. Institution-agnostic and
// document-style-agnostic: drop these into any document, under any template.
//
// For SDU-branded document frontpages (thesis, report, exam, project, …)
// see the `sdust` package.

// ══════════════════════════════════════════════════════
// IMPORTS
// ══════════════════════════════════════════════════════

#import "@preview/plotsy-3d:0.2.1": plot-3d-surface
#import "@preview/cetz-plot:0.1.1": plot as cetz-plot
#import "@preview/lovelace:0.3.0": *
#import "@preview/tdtr:0.5.2": *
#import "@preview/h-graph:0.1.0": *
#import "@preview/cetz:0.3.4": canvas, draw
#import "@preview/curryst:0.6.0": rule, prooftree
#import "@preview/fletcher:0.5.7" as fletcher: diagram, node, edge
#import "@preview/mitex:0.2.7": mitex

// ══════════════════════════════════════════════════════
// GRAPHS / DIAGRAMS
// ══════════════════════════════════════════════════════

// simple node/edge graph, e.g.
// #graph(
//   nodes: ((pos: (0,0), label: $1$), (pos: (1,1), label: $2$)),
//   edges: (((0,0), (1,1)),),
// )
#let graph(nodes: (), edges: (), spacing: 3em, radius: 1.2em, arrow: "-", caption: none) = figure(
  diagram(
    node-stroke: 1pt,
    edge-stroke: 1pt,
    spacing: spacing,
    ..nodes.map(n => node(n.pos, n.label, radius: radius)),
    ..edges.map(e => edge(e.at(0), e.at(1), e.at(2, default: arrow))),
  ),
  caption: caption,
)

// renders raw LaTeX math directly — pass a raw block, e.g.
// #tex(`\int_a^b f(x)\,dx = F(b) - F(a)`)
#let tex(body) = mitex(body)

// proof tree (curryst), e.g.
// #prooftree(rule(
//   label: [Label],
//   name: [Rule name],
//   [Premise 1],
//   [Premise 2],
//   [Conclusion],
// ))

// ══════════════════════════════════════════════════════
// PSEUDOCODE
// ══════════════════════════════════════════════════════

// pseudocode block, e.g.
// #pseudo(pseudocode(
//   [*if* $x > 0$],
//   ind, [return $x$], ded,
//   [*else*],
//   ind, [return $-x$],
// ))
#let pseudo(body) = {
  show math.equation.where(block: true): eq => block(width: 100%, align(center, eq))
  pseudocode-list(body)
}

// ══════════════════════════════════════════════════════
// TREES  (tidy)
// ══════════════════════════════════════════════════════
// `edges`: "straight" (default) draws direct diagonal arrows between nodes.
//          "square" / "orthogonal" / "elbow" draws right-angled connector
//          lines (horizontal-then-vertical) like a classic file/AST tree.
// `draw-edge`: pass a custom tdtr draw-edge function to override `edges`.
#let tree(body, reverse: false, shape: "circle", edges: "straight", draw-node: none, draw-edge: none, ..args) = {
  let shape-draw-node = if shape == "circle" or shape == "circ" {
    tidy-tree-draws.circle-draw-node
  } else if shape == "rect" or shape == "rectangle" {
    ((name, label, pos)) => (pos: (pos.x, pos.y), label: [#label], name: name, shape: rect)
  } else if shape == "square" {
    ((name, label, pos)) => (pos: (pos.x, pos.y), label: [#label], name: name, shape: rect, width: 1.6em, height: 1.6em)
  } else if shape == none {
    tidy-tree-draws.hidden-draw-node
  } else {
    tidy-tree-draws.circle-draw-node
  }
  let effective-draw-node = if draw-node != none { draw-node } else { shape-draw-node }
  let draw-nodes = if reverse {
    (effective-draw-node, ((name, label, pos)) => (pos: (pos.x, -pos.y)))
  } else {
    effective-draw-node
  }
  let effective-draw-edge = if draw-edge != none {
    draw-edge
  } else if edges == "square" or edges == "orthogonal" or edges == "elbow" {
    tidy-tree-draws.horizontal-vertical-draw-edge
  } else {
    tidy-tree-draws.default-draw-edge
  }
  tidy-tree-graph(body, draw-node: draw-nodes, draw-edge: effective-draw-edge, ..args)
}

// ══════════════════════════════════════════════════════
// UTILITIES
// ══════════════════════════════════════════════════════

#let group-by-pairs(elements) = {
  let lefts = elements
    .enumerate()
    .filter(((index, _)) => calc.rem(index, 2) == 0)
    .map(((_, element)) => element)
  let rights = elements
    .enumerate()
    .filter(((index, _)) => calc.rem(index, 2) == 1)
    .map(((_, element)) => element)
  lefts.zip(rights)
}

// ══════════════════════════════════════════════════════
// PLOTTING
// ══════════════════════════════════════════════════════

// ── formula parser ──────────────────────────────────────
// Lets plot2d/plot3d accept a plain math string ("x^2 + sin(y)") instead
// of a Typst closure. Typst's eval(mode: "math") only typesets a formula,
// it doesn't compute a number from it, so there's no built-in/package way
// to do this — this is a small hand-rolled precedence-climbing parser.

#let _formula-tokenize(s) = {
  let re = regex("[0-9]+\.?[0-9]*|[a-zA-Z_][a-zA-Z0-9_]*|\S")
  s.matches(re).map(m => m.text)
}

#let _formula-const(name) = {
  if name == "pi" { calc.pi } else if name == "e" { calc.e } else { none }
}

#let _formula-call(fname, a) = {
  if fname == "sin" { calc.sin(a.at(0)) }
  else if fname == "cos" { calc.cos(a.at(0)) }
  else if fname == "tan" { calc.tan(a.at(0)) }
  else if fname == "sqrt" { calc.sqrt(a.at(0)) }
  else if fname == "exp" { calc.exp(a.at(0)) }
  else if fname == "ln" { calc.ln(a.at(0)) }
  else if fname == "log" { calc.log(a.at(0)) }
  else if fname == "abs" { calc.abs(a.at(0)) }
  else if fname == "max" { calc.max(..a) }
  else if fname == "min" { calc.min(..a) }
  else { panic("plot formula: unknown function \"" + fname + "\"") }
}

#let _formula-eval(node, vars) = {
  let op = node.op
  if op == "num" { node.val }
  else if op == "var" {
    if node.name in vars { vars.at(node.name) } else {
      let c = _formula-const(node.name)
      if c != none { c } else { panic("plot formula: unknown variable \"" + node.name + "\"") }
    }
  }
  else if op == "neg" { -_formula-eval(node.a, vars) }
  else if op == "add" { _formula-eval(node.a, vars) + _formula-eval(node.b, vars) }
  else if op == "sub" { _formula-eval(node.a, vars) - _formula-eval(node.b, vars) }
  else if op == "mul" { _formula-eval(node.a, vars) * _formula-eval(node.b, vars) }
  else if op == "div" { _formula-eval(node.a, vars) / _formula-eval(node.b, vars) }
  else if op == "pow" { calc.pow(_formula-eval(node.a, vars), _formula-eval(node.b, vars)) }
  else if op == "call" { _formula-call(node.name, node.args.map(n => _formula-eval(n, vars))) }
}

#let _formula-prec(op) = (
  if op == "+" or op == "-" { 1 }
  else if op == "*" or op == "/" { 2 }
  else if op == "^" { 3 }
  else { -1 }
)

// Precedence-climbing parser — kept as a single self-recursive function
// since Typst #let functions can't forward-reference each other for
// mutual recursion.
#let _formula-parse(toks, pos, min-prec) = {
  let (lhs, p) = {
    let t = toks.at(pos)
    if t == "-" {
      let (a, p2) = _formula-parse(toks, pos + 1, 3)
      ((op: "neg", a: a), p2)
    } else if t == "(" {
      let (a, p2) = _formula-parse(toks, pos + 1, 0)
      (a, p2 + 1)
    } else if t.at(0) in "0123456789" {
      ((op: "num", val: float(t)), pos + 1)
    } else if pos + 1 < toks.len() and toks.at(pos + 1) == "(" {
      let args = ()
      let p2 = pos + 2
      if toks.at(p2) != ")" {
        while true {
          let (arg, p3) = _formula-parse(toks, p2, 0)
          args.push(arg)
          p2 = p3
          if toks.at(p2) == "," { p2 = p2 + 1 } else { break }
        }
      }
      ((op: "call", name: t, args: args), p2 + 1)
    } else {
      ((op: "var", name: t), pos + 1)
    }
  }

  let lhs = lhs
  let p = p
  while p < toks.len() and _formula-prec(toks.at(p)) >= min-prec and _formula-prec(toks.at(p)) > 0 {
    let op = toks.at(p)
    let prec = _formula-prec(op)
    let next-min = if op == "^" { prec } else { prec + 1 }
    let (rhs, p2) = _formula-parse(toks, p + 1, next-min)
    let node-op = if op == "+" { "add" } else if op == "-" { "sub" } else if op == "*" { "mul" } else if op == "/" { "div" } else { "pow" }
    lhs = (op: node-op, a: lhs, b: rhs)
    p = p2
  }
  (lhs, p)
}

// Parse a math string into a callable, e.g. formula("x^2 + sin(y)", vars: ("x","y")).
#let formula(expr, vars: ("x", "y")) = {
  let toks = _formula-tokenize(expr)
  let (ast, _) = _formula-parse(toks, 0, 0)
  (..args) => {
    let named = (:)
    for (i, name) in vars.enumerate() {
      named.insert(name, args.pos().at(i))
    }
    _formula-eval(ast, named)
  }
}

// Accept a function, a formula string, or an array of either.
#let _as-fn(f, vars) = if type(f) == str { formula(f, vars: vars) } else { f }

// 2D plot of y = f(x). f: is a closure or a formula string ("sin(x)"), or
// an array of either (each plotted as its own line). x: (min, max) domain.
// #plot2d(f: "sin(x)", x: (0, 2 * calc.pi))
// #plot2d(f: x => calc.sin(x), x: (0, 2 * calc.pi))
#let plot2d(
  f: none,
  x: (-5, 5),
  size: (8, 6),
  samples: 100,
  axis-style: "school-book",
  legend: none,
  ..style,
) = {
  let fns = if type(f) == array { f } else { (f,) }
  fns = fns.map(fn => _as-fn(fn, ("x",)))
  canvas(length: 1cm, {
    cetz-plot.plot(
      size: size,
      axis-style: axis-style,
      legend: legend,
      {
        for fn in fns {
          cetz-plot.add(fn, domain: x, samples: samples, ..style)
        }
      },
    )
  })
}

// 3D surface plot of z = f(x, y). f: is a closure or a formula string
// ("x^2 + y^2"). By default samples the function over the x/y domain to
// auto-scale the axes so the plot renders at a sane size — pass
// z: (min, max) to skip sampling and use an explicit z range, or override
// scale-dim/axis-step yourself for finer control.
// #plot3d(f: "x^2 + y^2", x: (-3, 3), y: (-3, 3))
// #plot3d(f: (x, y) => x*x + y*y, x: (-3, 3), y: (-3, 3))
#let plot3d(
  f: none,
  x: (-5, 5),
  y: (-5, 5),
  z: auto,
  grid: 12,
  k: 0.6,
  axis-label-offset: (0.06, 0.04, 0.03),
  ..args,
) = {
  let f = _as-fn(f, ("x", "y"))
  let (x-lo, x-hi) = x
  let (y-lo, y-hi) = y
  let (z-lo, z-hi) = if z != auto {
    z
  } else {
    let zs = ()
    for i in range(grid + 1) {
      let xv = x-lo + (x-hi - x-lo) * i / grid
      for j in range(grid + 1) {
        let yv = y-lo + (y-hi - y-lo) * j / grid
        zs.push(f(xv, yv))
      }
    }
    (calc.min(..zs), calc.max(..zs))
  }
  let x-range = calc.max(x-hi - x-lo, 1e-6)
  let y-range = calc.max(y-hi - y-lo, 1e-6)
  let z-range = calc.max(z-hi - z-lo, 1e-6)
  let default-scale-dim = (k / x-range, k / y-range, k / z-range)
  let default-axis-step = (
    calc.max(int(calc.round(x-range / 4)), 1),
    calc.max(int(calc.round(y-range / 4)), 1),
    calc.max(int(calc.round(z-range / 4)), 1),
  )
  plot-3d-surface(
    f,
    xdomain: x,
    ydomain: y,
    scale-dim: default-scale-dim,
    axis-step: default-axis-step,
    axis-label-offset: axis-label-offset,
    ..args,
  )
}

// ══════════════════════════════════════════════════════
// EXERCISE CARDS
// ══════════════════════════════════════════════════════

// prompt block, e.g. #question(title: "Exercise 1")[Solve for $x$.]
#let question(title: none, body) = block(
  width: 100%,
  inset: 10pt,
  radius: 4pt,
  fill: luma(245),
  [
    #if title != none {
      strong(title)
      h(0.5em)
    }
    #body
  ],
)

// indented answer body under a #question, e.g. #answer[$x = 2$.]
#let answer(body) = block(
  width: 100%,
  inset: (left: 10pt, right: 10pt, top: 4pt, bottom: 10pt),
  stroke: (left: 1pt + luma(180)),
  body,
)

// ══════════════════════════════════════════════════════
// CARD COMPONENTS
// ══════════════════════════════════════════════════════

// Internal base: coloured header bar + tinted body.
#let _titled-card(
  title: none,
  width: 100%,
  header-fill: rgb("#334155"),
  body-fill: rgb("#f8fafc"),
  border: rgb("#d8dde6"),
  body-text-fill: rgb("#1c1e26"),
  body-font: auto,
  body-size: 10.5pt,
  body-leading: 0.65em,
  content,
) = std.block(
  width: width,
  stroke: 0.5pt + border,
  radius: 2pt,
  clip: true,
  {
    if title != none {
      std.block(
        width: 100%,
        above: 0pt,
        below: 0pt,
        fill: header-fill,
        inset: (left: 14pt, right: 14pt, top: 8pt, bottom: 8pt),
        text(fill: white, weight: "bold", size: 10.5pt, title),
      )
    }
    std.block(
      width: 100%,
      above: 0pt,
      below: 0pt,
      fill: body-fill,
      inset: (left: 14pt, right: 14pt, top: 10pt, bottom: 10pt),
      {
        set par(leading: body-leading)
        set text(fill: body-text-fill, size: body-size, ..(if body-font == auto { (:) } else { (font: body-font) }))
        content
      },
    )
  },
)

// gray default block, e.g. #block(title: "Note")[Body text.]
#let block(title: none, width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#6b7280"), body-fill: rgb("#f3f4f6"),
  border: rgb("#d1d5db"), body-text-fill: rgb("#1f2937"),
  content,
)

// blue theorem, e.g. #theorem(title: "Theorem 1")[For all $x$, ...]
#let theorem(title: "Theorem", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#1565c0"), body-fill: rgb("#ecf3fc"),
  border: rgb("#b3cdeb"), body-text-fill: rgb("#0d2e57"),
  content,
)

// purple corollary, e.g. #corollary[Follows directly from Theorem 1.]
#let corollary(title: "Corollary", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#6d28d9"), body-fill: rgb("#f3ecfd"),
  border: rgb("#d8b9f2"), body-text-fill: rgb("#3b1257"),
  content,
)

// green definition, e.g. #definition(title: "Definition (Group)")[A set $G$ with ...]
#let definition(title: "Definition", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#2e7d32"), body-fill: rgb("#ecfdf5"),
  border: rgb("#a7f3d0"), body-text-fill: rgb("#14532d"),
  content,
)

// red example, e.g. #example[Let $x = 2$, then ...]
#let example(title: "Example", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#c62828"), body-fill: rgb("#fdeced"),
  border: rgb("#f2b9bc"), body-text-fill: rgb("#5a1212"),
  content,
)

// end-of-proof tombstone symbol
#let QED = h(1fr) + box(width: 0.6em, height: 0.6em, stroke: 0.8pt + black)

// white/neutral proof — same shape as example, plain color, ends with QED,
// e.g. #proof[By induction on $n$. ...]
#let proof(title: "Proof", width: 100%, content) = _titled-card(
  title: title, width: width,
  header-fill: rgb("#4b5563"), body-fill: white,
  border: rgb("#d1d5db"), body-text-fill: rgb("#1f2937"),
  [#content #QED],
)
