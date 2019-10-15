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
	
	count: Ember.computed('model', function() {
		var gamez = this.get('model.rentaGAMEZ')
		var count = [gamez.length,0,0,0,0,0]
		for (var i = 0; i < gamez.length; ++i) {
			if (gamez[:TYPE1] == true) { count[1] = count[1] + 1 }
			if (gamez[:TYPE2] == true) { count[2] = count[2] + 1 }
			if (gamez[:TYPE3] == true) { count[3] = count[3] + 1 }
			if (gamez[:TYPE4] == true) { count[4] = count[4] + 1 }
			if (gamez[:HIDEOZ] == false) { count[5] = count[5] + 1 }
		}
		return count
	}),
	
	rentaGAMEZ1: Ember.computed('model', function() {
		var gamez = this.get('model.rentaGAMEZ')
	}),
	
	rentaGAMEZ2: Ember.computed('model', function() {
		var gamez = this.get('model.rentaGAMEZ')
	}),
	
	rentaGAMEZ3: Ember.computed('model', function() {
		var gamez = this.get('model.rentaGAMEZ')
	}),
	
	rentaHIDEO: Ember.computed('model', function() {
		var gamez = this.get('model.rentaGAMEZ')
	}),

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
