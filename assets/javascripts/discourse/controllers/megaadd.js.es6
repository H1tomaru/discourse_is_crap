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

			return fetch("/admin/MegaAdd/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/json' },
				body: JSON.stringify(data)
			}).then(result => {
				this.set('addstuff', result.json())
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
			return fetch('/MrBug.json').then(result => {
				this.set('p4lista', result.json().gamelist)
			})
		}

	}

})
