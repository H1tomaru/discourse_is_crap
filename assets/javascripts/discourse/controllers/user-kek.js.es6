export default Ember.Controller.extend({

	ebanidze: null,
	str: window.location.href,
	this.set('ebanidze', this.get('str').length - this.get('str').replace("/", "").length)

});
