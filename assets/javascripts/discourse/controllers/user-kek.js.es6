export default Ember.Controller.extend({
	ebanidze: Ember.getOwner(this).lookup('controller:application').get('currentRouteName')
	//params: params
});
