function stringKey(source, target){
   var L = [source.id, target.id];
   L.sort();
   return L.join();
}

function graph() {

   this.numVertices = 0;
   this.numEdges = 0;
   this.vertices = {};
   /* A vertex is {id:int, name:string, attributes:object} */

   this.vertexNameToId = {};

   this.edges = {};
   /* An edge is 
      {id:int, name:string, source:int, target int, attributes:object}
      Specifically, the source/target are references to
      vertex objects. */

   this.edgeNameToId = {};
   this.edgeSet = {};

   this.hasVertex = function(name) {
      return name in this.vertexNameToId;
   }

   this.hasEdge = function(source, target) {
      return stringKey(source, target) in this.edgeSet;
   }

   this.getVertexByName = function(name) {
      return this.vertices[this.vertexNameToId[name]]
   }

   this.addVertex = function() {
      var id = this.numVertices;
      var name = (this.numVertices + 1).toString(); 
      var vertexObj = {id:id, name:name, attributes:null};
      this.vertices[id] = vertexObj;
      this.numVertices += 1; 
      this.vertexNameToId[name] = id;

      return vertexObj;
   }

   this.addEdge = function(source, target) {
      if !this.edgeInGraph(source, target) {
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

      return edgeObj;
   }

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
   }

}
