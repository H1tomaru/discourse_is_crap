export default Ember.Controller.extend({

	ebanidze: null,
	str: window.location.href,
	count: this.get('str').length - this.get('str').replace("/", "").length

});
