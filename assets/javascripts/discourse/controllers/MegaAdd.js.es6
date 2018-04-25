export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},
	p4lista: null,
	
	actions: {

		oops() {
			Ember.$.ajax({
				url: "/admin/MegaAdd/",
				type: "POST",
				data: { "GAME": this.get('addstuff.GAME'),
				      	"STRING": this.get('addstuff.STRING'),
					"ADDFB": this.get('addstuff.ADDFB')}
			}).then(result => {
				this.set('addstuff', result)
			})
		},
		
		Reset() {
			this.set('addstuff', {})
		},

		FeedbacksGo() {
			this.set('addstuff.ADDFB', true)
		},
		
		FeedbacksStop() {
			this.set('addstuff.ADDFB', false)
		},

		P4Lista() {
			Ember.$.ajax({
				url: "/MrBug.json",
				type: "GET"
			}).then(result => {
				result = result.gamedb1.concat(result.gamedb2,result.gamedb3)
				this.set('p4lista', result)
			})
		}

	}

})
