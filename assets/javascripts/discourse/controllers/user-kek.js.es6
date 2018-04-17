export default Ember.Controller.extend({

	ebanidze: null,

	Ember.$.ajax({
		url: "window.location.href+'.json'",
		type: "GET"
	}).then(result => {
		this.set('ebanidze', result);
	});

});
