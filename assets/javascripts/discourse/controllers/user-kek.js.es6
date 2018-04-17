export default Ember.Controller.extend({

	ebanidze: null,
	ebanidze2: window.location.href,

	init: function() {
		Ember.$.ajax({
			url: window.location.href+".json",
			type: "GET"
		}).then(result => {
			this.set('ebanidze', result);
		});
	}

});
