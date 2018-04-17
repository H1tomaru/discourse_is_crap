export default Ember.Controller.extend({

	ebanidze: null,

	init: function() {
		Ember.$.ajax({
			url: window.location.href+".json",
			type: "GET"
		}).then(result => {
			this.set('ebanidze', result);
		});
	}

});
