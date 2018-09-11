export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},

	p4lista: null,
	
	p3lista: null,

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
				this.set('addstuff.ADDFB', false)
			})
		},

		Reset() {
			this.set('addstuff', { "GAME": null, "STRING": null, "ADDFB": false })
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
		
		,

		P3Lista() {
			Ember.$.ajax({
				url: "/MrBugP3.json",
				type: "GET"
			}).then(result => {
				result = result.gamedb1.concat(result.gamedb2,result.gamedb3)
				this.set('p3lista', result)
			})
		}

	}

})
