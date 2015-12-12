import clone from 'clone';

// Working graph
var graph; 

// linked list of history
var history = [graph];
var current = 0;

function getVertexByName(name) {
   for (var i = 0; i < graph.vertices.length; i++) {
      if (graph.vertices[i].name == name) {
         return graph.vertices[i];
      }
   }
   
   return null;
}

function edgeInGraph(source, target) {
   for (var i = 0; i < graph.edges.length; i++) {
      var e = graph.edges[i];
      if ((e.source.name == source.name && e.target.name == target.name) || 
          (e.source.name == target.name && e.target.name == source.name)) {
         return true;
      }
   }
   
   return false;
}


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
       .linkDistance(40) // want to make this an option!
       .on("tick", tick);

   drag = force.drag()
       .on("dragstart", dragstart);

   d3.select("body").append("svg")
       .attr("width", width)
       .attr("height", height);

   graph = {numVertices:2,
            numEdges:1,
            vertices:
               [
                {id:0, name:"1"}, // name is always id + 1 
                {id:1, name:"2"}
               ],
            edges:
               [
                {source:0, target:1},
               ]
            };

   updateD3();
}

// Call this function any time the underlying graph data changes
function updateD3() {
   force.nodes(graph.vertices)
        .links(graph.edges)
        .start();

   vertex = d3.select("svg").selectAll(".vertex");
   edge = d3.select("svg").selectAll(".edge");

   // data join returns update selections (common to DOM and data object)
   vertex = vertex.data(graph.vertices, function(d) {return d.name;});
   edge = edge.data(graph.edges);

   // update
   // vertex.attr("class","vertex");
   // edge.attr("class","edge");
   
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


function addVertex(vertex) {
   graph.vertices.push({id:graph.numVertices, name:graph.numVertices+1});
   graph.numVertices += 1; 
}

function addEdge(source, target) {
   if (!edgeInGraph(source, target)) {
      graph.edges.push({source:source, target:target});
      graph.numEdges += 1; 
   }
}

function tryParseEdge(str) {
   var pieces = str.split(new RegExp("[ ,]+"), 2);
   var firstName, secondName;

   if (pieces.length == 2) {
      firstName = pieces[0];
      secondName = pieces[1]; 
   } else if (pieces.length == 1) {
      // greedily match any vertex name
      firstName = str.slice(0,-1); // the whole string cannot be a single vertex
      while (firstName.length > 0 && getVertexByName(firstName) == null) {
         firstName = firstName.slice(0,-1);         
      }
      
      secondName = str.slice(firstName.length, str.length); 
   }
   
   var firstVertex = getVertexByName(firstName),
       secondVertex = getVertexByName(secondName);

   if (firstVertex != null && secondVertex != null) {
      return [firstVertex, secondVertex];
   } else {
      return null;
   }
}

var KEY_BACKSPACE = 8,
    KEY_ENTER = 13,
    KEY_ESC = 27,
    KEY_E = 101,
    KEY_N = 110, // all lower case codes
    KEY_V = 118,
    KEY_0 = 48,
    KEY_1 = 49,
    KEY_2 = 50,
    KEY_3 = 51,
    KEY_4 = 52,
    KEY_5 = 53,
    KEY_6 = 54,
    KEY_7 = 55,
    KEY_8 = 56,
    KEY_9 = 57,
    KEY_SEMI = 59;

var COMMAND_MODE = 0,
    EX_MODE = 1,
    COMMAND_EDGE_ADD = 2,
    COMMAND_DELETE_GENERIC = 3,
    COMMAND_DELETE_VERTEX = 4,
    COMMAND_DELETE_EDGE = 5;

state = {
   commandBuffer:"",
   mode:COMMAND_MODE,

   clear: function() {
      this.commandBuffer = "";
      this.mode = COMMAND_MODE;
      updateD3();
   },

   update: function(event) {
      var code = event.which;

      switch (this.mode) {
         case COMMAND_EDGE_ADD: 
            switch (code) {
               case KEY_ENTER:
                  edge = tryParseEdge(this.commandBuffer);
                  if (edge) {
                     addEdge(edge[0], edge[1]);
                  }
                  this.clear();
                  break;

               case KEY_E:
                  edge = tryParseEdge(this.commandBuffer);
                  if (edge) {
                     addEdge(edge[0], edge[1]);
                  } 
                  this.clear();
                  this.mode = COMMAND_EDGE_ADD;
                  break;

               case KEY_ESC:
                  this.clear();
                  break;

               default:
                  this.commandBuffer += String.fromCharCode(code); 
            }
            break;

         default:
            switch(code) {
               case KEY_V:
                  addVertex(vertex);
                  break;

               case KEY_E:
                  this.mode = COMMAND_EDGE_ADD;
                  break;

               default:
                  ;
            } 
      }

      updateD3();
   }

};

initialize();
$("body").keypress(function(e) { state.update(e); });
