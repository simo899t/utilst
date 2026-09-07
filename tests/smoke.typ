#import "@local/utilst:0.1.0": *
#show: code-style

= utilst smoke test

Inline `code` and a block:
```py
print("hello")
```
#simple-code[
```py
print("plain")
```
]

#figure(
  plot2d(f: "sin(x)", x: (0, 6.28)),
  caption: [This is a graph example using utilst],
)




#plot3d(f: "x^2 + y^2", x: (-2, 2), y: (-2, 2))

#pseudo(pseudocode-list[
  + *if* $x > 0$
    + return $x$
])

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


#graph(
  nodes: ((pos: (0,0), label: $1$), (pos: (1,1), label: $2$)),
  edges: (((0,0), (1,1)),),
)

#tex(`\int_a^b f(x)\,dx = F(b) - F(a)`)


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
 




#figure(
  graph(
  nodes: ((pos: (0,0), label: $1$), (pos: (1,1), label: $2$)),
  edges: (((0,0), (1,1)),),
),
  caption: [This is a graph],
) <label>

