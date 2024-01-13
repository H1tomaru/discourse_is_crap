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
					'Api-Key': '3b117c5ce9e85f6ad38860c35d4ea9955a9a8dd2c57ce3290104988f68636757'
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
