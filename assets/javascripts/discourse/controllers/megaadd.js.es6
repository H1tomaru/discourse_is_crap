import Ember from 'ember';
import $ from 'jquery';

export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},

	p4lista: null,

	actions: {

		oops() {
			$.post("/admin/MegaAdd/", { 
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
			return fetch('/MrBug.json').then(function(response) {
				return response.json();
			}).then(result => {
				this.set('p4lista', result.gamelist)
			})
		}

	}

})
