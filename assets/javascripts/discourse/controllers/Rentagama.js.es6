export default Ember.Controller.extend({

	showTYPE1: true,
	showTYPE2: true,
	showTYPE3: true,
	rulez: false,
	showGAMEZ: true,
	showCRAP: false,

	actions: {

		showRULEZ() {
			this.toggleProperty('rulez')
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
		
		showGAMEZ() {
			this.set('showGAMEZ', true)
			this.set('showCRAP', false)
		},
		
		showCRAP() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', true)
		}

	}

})
