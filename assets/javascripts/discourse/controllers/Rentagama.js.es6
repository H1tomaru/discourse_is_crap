export default Ember.Controller.extend({

	showTYPE1: true,
	showTYPE2: true,
	showTYPE3: true,
	showTYPE4: true,
	rulez: false,
	showGAMEZ: true,
	showCRAP: false,
	showSHITS: false,
	showHIDEOZ: false,
	hideobutts: {},

	didInsertElement() {
		console.log('did insert working')
		//this.set('model.TESTING', "tralalaika")
	},
	
	init: function() {
		console.log('did init working')
		//this.set('model.TESTING', "tralalaika777")
	},

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
			this.set('showHIDEOZ', false)
			this.set('showGAMEZ', true)
		},

		showCRAP() {
			this.set('showGAMEZ', false)
			this.set('showSHITS', false)
			this.set('showHIDEOZ', false)
			this.set('showCRAP', true)
		},

		showSHITS() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', false)
			this.set('showHIDEOZ', false)
			this.set('showSHITS', true)
		},

		showHIDEOZ() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', false)
			this.set('showSHITS', false)
			this.set('showHIDEOZ', true)
		},

		hideoGAMEZ(gNAME, knopk) {
			Ember.set(this.get('hideobutts'), knopk, true)
			this.set('test1', knopk)
			Ember.$.ajax({
				url: "/renta-halehideo/",
				type: "POST",
				data: { "HIDEOFU": btoa(gNAME) }
			}).then(result => {
				this.set('test2', knopk)
				//this.get('somemega')[index].toggleProperty("HIDEOZ")
				Ember.set(this.get('model.count'), 5, this.get('model.count')[5]+1)
				this.set('test3', knopk)
				Ember.set(this.get('hideobutts'), knopk, false)
				this.set('test4', knopk)
			})
		}

	}

})
