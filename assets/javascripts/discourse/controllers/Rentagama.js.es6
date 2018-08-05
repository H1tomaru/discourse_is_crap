export default Ember.Controller.extend({

	showTYPE1: true,
	showTYPE2: true,
	showTYPE3: true,
	showTYPE3: true,
	rulez: false,
	showGAMEZ: true,
	showCRAP: false,
	showSHITS: false,

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

		showTYPE4() {
			this.toggleProperty('showTYPE4')
		},

		showGAMEZ() {
			this.set('showCRAP', false)
			this.set('showSHITS', false)
			this.set('showGAMEZ', true)
		},

		showCRAP() {
			this.set('showGAMEZ', false)
			this.set('showSHITS', false)
			this.set('showCRAP', true)
		},

		showSHITS() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', false)
			this.set('showSHITS', true)
		}

	}

})
