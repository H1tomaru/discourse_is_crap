import Ember from 'ember';
import $ from 'jquery';

export default Ember.Controller.extend({

	showLIST: localStorage.getItem('showLIST') == "true",
	showTYPE1: true,
	showTYPE2: true,
	showTYPE3: true,
	showTYPE4: true,
	showGAMEZ: true,
	showCRAP: false,
	rulez: false,

	didInsertElement: function() { $.getScript('https://cdnjs.cloudflare.com/ajax/libs/lazysizes/5.1.2/lazysizes.min.js') },

	actions: {

		showRULEZ() {
			this.toggleProperty('rulez')
		},

		showLIST1() {
			this.set('showLIST', false)
			localStorage.setItem('showLIST', "false")
		},

		showLIST2() {
			this.set('showLIST', true)
			localStorage.setItem('showLIST', "true")
		},

		showGAMEZ() {
			this.set('showCRAP', false)
			this.set('showGAMEZ', true)
		},

		showCRAP() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', true)
		},

		showTYPE1() {
			this.toggleProperty('showTYPE1')
		},

		showTYPE2() {
			this.toggleProperty('showTYPE2')
		},

		showTYPE3() {
			this.toggleProperty('showTYPE3')
		},

		showTYPE4() {
			this.toggleProperty('showTYPE4')
		}

	}

})
