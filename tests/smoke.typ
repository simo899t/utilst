#import "@local/funcst:0.1.0": *

= funcst smoke test

#theorem(title: "Theorem 1")[For all $x$, $x = x$.]
#definition(title: "Definition")[A set with an operation.]
#example[Let $x = 2$.]
#corollary[Follows.]
#proof[By induction on $n$.]
#block(title: "Note")[Body.]

#question(title: "Exercise 1")[Solve for $x$.]
#answer[$x = 2$.]

#plot2d(f: "sin(x)", x: (0, 6.28))
#plot3d(f: "x^2 + y^2", x: (-2, 2), y: (-2, 2))

#pseudo(pseudocode-list[
  + *if* $x > 0$
    + return $x$
])

#tree[
  - Root
    - A
    - B
]

#graph(
  nodes: ((pos: (0,0), label: $1$), (pos: (1,1), label: $2$)),
  edges: (((0,0), (1,1)),),
)

#tex(`\int_a^b f(x)\,dx = F(b) - F(a)`)
#prooftree(rule(name: "R", [$A$], [$B$]))
