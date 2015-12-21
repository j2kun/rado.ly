

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
    COMMAND_DELETE = 3;

function State(initialGraph) {
   this.history = [initialGraph];
   this.currentIndex = 0;
   this.currentGraph = initialGraph;

   this.commandBuffer = "";
   this.mode = COMMAND_MODE;

   this.clear = function() {
      this.commandBuffer = "";
      this.mode = COMMAND_MODE;
   };

   this.pushGraph = function(graph) {
      this.history.push(graph);
      this.currentIndex += 1;
      this.currentGraph = graph;
   };

   this.update = function(event) {
      var code = event.which;

      switch (this.mode) {
         case COMMAND_EDGE_ADD: 
            switch (code) {
               case KEY_ENTER:
                  edge = this.currentGraph.tryParseEdge(this.commandBuffer);
                  if (edge) {
                     var graph = this.currentGraph.copy();
                     graph.addEdge(edge[0], edge[1]);
                     this.pushGraph(graph);
                  }
                  this.clear();
                  break;

               case KEY_E:
                  edge = this.currentGraph.tryParseEdge(this.commandBuffer);
                  if (edge) {
                     var graph = this.currentGraph.copy();
                     graph.addEdge(edge[0], edge[1]);
                     this.pushGraph(graph);
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
                  var graph = this.currentGraph.copy();
                  graph.addVertex();
                  this.pushGraph(graph);
                  break;

               case KEY_E:
                  this.mode = COMMAND_EDGE_ADD;
                  break;

               default:
                  ;
            } 
      }
   };
};

