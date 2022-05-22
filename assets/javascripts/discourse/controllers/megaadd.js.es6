export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},

	p4lista: null,
	
	killzone4tv: false,
	killzonefb: false,
	
	actions: {

		oops() {
			Ember.$.post("/admin/MegaAdd/", { 
				GAME: this.get('addstuff.GAME'),
				STRING: this.get('addstuff.STRING'),
				ADDFB: this.get('addstuff.ADDFB')
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
				this.set('p4lista', result.gamelist)
			})
		},

		killzonefb() {
			Ember.$.ajax({
				url: "/admin/MegaAdd.json",
				data: { "killzonefb": "sleep" },
				type: "GET"
			}).then(result => {
				this.set('killzonefb', result.killzonefb)
			})
		},

		killzone4tv() {
			Ember.$.ajax({
				url: "/admin/MegaAdd.json",
				data: { "killzone4tv": "gamez" },
				type: "GET"
			}).then(result => {
				this.set('killzone4tv', result.killzone4tv)
			})
		}

	}

})
