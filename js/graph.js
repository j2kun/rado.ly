function stringKey(source, target){
   var L = [source.id, target.id];
   L.sort();
   return L.join();
}

function graph() {

   this.numVertices = 0;
   this.numEdges = 0;
   this.vertices = [];
   /* A vertex is {id:int, name:string, attributes:object} */

   this.vertexNameToId = {};

   this.edges = [];
   /* An edge is 
      {id:int, name:string, source:int, target int, attributes:object}
      Specifically, the source/target are references to
      vertex objects. */

   this.edgeNameToId = {};
   this.edgeSet = {};


   this.hasVertex = function(name) {
      return name in this.vertexNameToId;
   };

   this.hasEdge = function(source, target) {
      return stringKey(source, target) in this.edgeSet;
   };

   this.getVertexByName = function(name) {
      if (!this.hasVertex(name)) {
         return null;
      }

      return this.vertices[this.vertexNameToId[name]]
   };

   this.addVertex = function() {
      var id = this.numVertices;
      var name = (this.numVertices + 1).toString(); 
      var vertexObj = {id:id, name:name, attributes:null};
      this.vertices[id] = vertexObj;
      this.numVertices += 1; 
      this.vertexNameToId[name] = id;

      return vertexObj;
   };

   this.addEdge = function(source, target) {
      if (this.hasEdge(source, target)) {
         return;
      }

      var id = this.numEdges;
      var name = (this.id + 1).toString();
      var edgeObj = {id:id, name:name, source:source, 
         target:target, attributes:null};
      this.edges[id] = edgeObj;
      this.numEdges += 1;
      
      var key = stringKey(source, target);
      this.edgeSet[key] = id;
      this.edgeNameToId[name] = id;

      return edgeObj;
   };

   this.copy = function() {
      var theCopy = new graph();
      
      var i = 0;
      for (i = 0; i < this.vertices.length; i++) {
         theCopy.addVertex();
      }

      for (i = 0; i < this.edges.length; i++) {
         var source = this.edges[i].source;
         var target = this.edges[i].target;
         theCopy.addEdge(source, target);
      }
   
      return theCopy;
   };


   // Try to parse a string representing an edge
   this.tryParseEdge = function(str) {
      var pieces = str.split(new RegExp("[ ,]+"), 2);
      var firstName, secondName;

      if (pieces.length == 2) {
         firstName = pieces[0];
         secondName = pieces[1]; 
      } else if (pieces.length == 1) {
         // greedily match any vertex name
         firstName = str.slice(0,-1); // entire string cannot be one vertex
         while (firstName.length > 0 && this.getVertexByName(firstName) == null) {
            firstName = firstName.slice(0,-1);
         }
         
         secondName = str.slice(firstName.length, str.length); 
      }
      
      var firstVertex = this.getVertexByName(firstName),
          secondVertex = this.getVertexByName(secondName);

      if (firstVertex != null && secondVertex != null) {
         return [firstVertex, secondVertex];
      } else {
         return null;
      }
   }


}
