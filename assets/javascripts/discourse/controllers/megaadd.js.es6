import Ember from 'ember';

export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},

	p4lista: null,

	actions: {

		oops() {
			return fetch("/admin/MegaAdd/", {
				method: 'POST',
				body: {
					GAME: this.get('addstuff.GAME'),
					STRING: this.get('addstuff.STRING'),
					ADDFB: this.get('addstuff.ADDFB')
				}
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
			return fetch('/MrBug.json').then(result => {
				this.set('addstuff.ADDFB', 'Start!')
				this.set('p4lista', result.gamelist)
				this.set('addstuff.ADDFB', 'Works!')
			})
		}

	}

})
