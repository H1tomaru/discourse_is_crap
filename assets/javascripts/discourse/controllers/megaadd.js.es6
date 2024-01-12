import Ember from 'ember';

export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},

	p4lista: null,

	actions: {

		oops() {
			let data = {
				GAME: this.get('addstuff.GAME'),
				STRING: this.get('addstuff.STRING'),
				ADDFB: this.get('addstuff.ADDFB')
			}

			fetch("/admin/MegaAdd/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(data)
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
			fetch('/MrBug.json').then(result => {
				this.set('p4lista', result.gamelist)
			})
		}

	}

})
