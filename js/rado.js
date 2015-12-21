// Working graph
var G = new graph();
G.addEdge(G.addVertex(), G.addVertex());
var state = new State(G);

// D3 globals
var edge,   // selection of all svg line objects
    vertex, // selection of all svg "g" objects (containing vertex, text)
    force,  // force layout object
    drag;   // drag handler object

// D3 graph layout dynamics 
function tick() {
   edge.attr("x1", function(d) { return d.source.x; })
       .attr("y1", function(d) { return d.source.y; })
       .attr("x2", function(d) { return d.target.x; })
       .attr("y2", function(d) { return d.target.y; });

   vertex.attr("transform", function(d) { 
      return "translate(" + d.x + "," + d.y + ")"; 
   });
}

function dblclick(d) {
   d3.select(this).classed("fixed", d.fixed = false);
}

function dragstart(d) {
   d3.select(this).classed("fixed", d.fixed = true);
}


function initialize() {
   var width=1600,
       height=1000;

   force = d3.layout.force()
       .size([width, height])
       .charge(-400)
       .linkDistance(40) // make this an option eventually
       .on("tick", tick);

   drag = force.drag()
       .on("dragstart", dragstart);

   d3.select("body").append("svg")
       .attr("width", width)
       .attr("height", height);

   updateD3();
}

// Call this function any time the underlying graph data changes
function updateD3() {
   force.nodes(state.currentGraph.vertices)
        .links(state.currentGraph.edges)
        .start();

   vertex = d3.select("svg").selectAll(".vertex");
   edge = d3.select("svg").selectAll(".edge");

   // data join returns update selections (common to DOM and data object)
   vertex = vertex.data(state.currentGraph.vertices, function(d) {return d.name;});
   edge = edge.data(state.currentGraph.edges);
   
   // enter, append new vertices/edges
   edge.enter().insert("line", ":first-child")
       .attr("class", "edge");

   vertexEnter = vertex.enter().append("g")
                       .attr("class", "vertex")
                       .on("dblclick", dblclick)
                       .call(drag);

   vertexEnter.append("circle")
              .attr("r", 12);

   vertexEnter.append("text")
              .attr("dy", ".35em")
              .text(function(d) {return d.name;});

   // exit, remove deleted vertices/edges
   vertex.exit().remove();
   edge.exit().remove();
}

initialize();

$("body").keypress(function(e) { 
   state.update(e);
   updateD3();
});
