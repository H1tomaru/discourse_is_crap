export default Discourse.Route.extend({
   model:function() {
     return ajax('/mrbug.json');
   }
