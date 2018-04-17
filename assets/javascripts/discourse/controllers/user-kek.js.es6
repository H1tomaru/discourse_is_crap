export default Ember.Controller.extend({

	ebanidze: null,
	str: window.location.href,
	count: str.length - str.replace("/", "").length

});
