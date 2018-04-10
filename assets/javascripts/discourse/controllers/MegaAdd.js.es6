export default Ember.Controller.extend({

	addstuff: null,
	
	actions: {

		oops() {
			Ember.$.ajax({
				url: "/admin/MegaAdd",
				type: "POST",
				data: { "GAME": this.get('addstuff.GAME'),
				      	"STRING": this.get('addstuff.STRING')}
			}).then(result => {
				this.set('addstuff', result);
			});
		},
		
		Reset() {
				this.set('addstuff', null);
		}

	}

});
