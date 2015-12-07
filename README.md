# Rado.ly: a web tool for quickly building graph counterexamples

Rado.ly is a tool that runs entirely in your browser that allows
you to quickly build examples of graphs with vim-style commands.

Currently supported commands:

 - `v` adds a new vertex (with an automatically chosen integer identifier)
 - `ei,j<ENTER>` adds a new edge between vertices `i` and `j`, with a comma or
   space separating them in the command. 
 - To ease the process of adding many new edges, one can replace `<ENTER>` above
   with `e` to chain many new edge additions, e.g. `e1,7e1,8e1,9<ENTER>`. 
 - To further ease the process, the separator can be removed and the first
   vertex name will be greedily chosen from the beginning. i.e. `e117<ENTER>`
adds an edge from vertex `1` to vertex `17`, unless there is another vertex
called `11`, in which case it adds an edge from `11` to `7`.
 

### What's up with the name?

The Rado graph is a famous mathematical object. It is an infinite graph which
contains every finite graph (and every countably infinite graph) as a subgraph. 
This makes it "the" graph.
