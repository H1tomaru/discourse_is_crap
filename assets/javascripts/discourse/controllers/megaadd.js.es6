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
					'Api-Key': 'a3f527c441bed95f46263e584ce92da9297c41b311a2667bac82ead4941c1a16'
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
