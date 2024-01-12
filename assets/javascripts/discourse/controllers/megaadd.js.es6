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
				headers: {
					'Content-Type': 'application/json',
					'Api-Key': '90fee712da230eefb6a785217edf7323b248b4a54fad680ad02e7d87f242808a',
					'Api-Username': 'H1tomaru'
					},
				body: JSON.stringify({
					GAME: this.get('addstuff.GAME'),
					STRING: this.get('addstuff.STRING'),
					ADDFB: this.get('addstuff.ADDFB')
				})
			}).then(function(response) {
				return response.json();
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
			return fetch('/MrBug.json').then(function(response) {
				return response.json();
			}).then(result => {
				this.set('p4lista', result.gamelist)
			})
		}

	}

})
