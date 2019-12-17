export default Ember.Controller.extend({

	showLIST: false,
	showTYPE1: true,
	showTYPE2: true,
	showTYPE3: true,
	showTYPE4: true,
	showGAMEZ: true,
	showCRAP: false,
	showSHITS: false,
	showHIDEOZ: false,
	rulez: false,
	hideobutts: {},

	rentaHIDEO: Ember.computed('model.rentaTSHOW', function() {
		return this.get('model.rentaTSHOW').sortBy('GNAME');
	}).property('model.rentaTSHOW.[]'),

	/*
	sortProperties1: ['GNEW:desc', 'GNAME:asc'],
	sortProperties2: ['PR4SORT:desc', 'GNAME:asc'],
	rentaGAMEZ: Ember.computed.sort("model.rentaGAMEZ", "sortProperties1").property('model.rentaGAMEZ.[]'),

	rentaGAMEZ1: Ember.computed('model', function() {
		var gamez = this.get('model.rentaGAMEZ')
		var gamez1 = []
		for (var i = 0; i < gamez.length; ++i) {
			if (gamez[i]['TYPE1'] == true) { gamez1.push(gamez[i]) }
		}
		return gamez1
	}),
	*/

	actions: {

		showRULEZ() {
			this.toggleProperty('rulez')
		},

		showLIST1() {
			this.set('showLIST', false)
		},

		showLIST2() {
			this.set('showLIST', true)
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

		hideoGAMEZ(template, knopk, value) {
			if (this.get('currentUser.username')) {
			Ember.set(this.get('hideobutts'), knopk, true)
			Ember.$.ajax({
				url: "/renta-halehideo/",
				type: "POST",
				data: { "VALUE": value, "UZA": this.get('currentUser.username'),
				"TSHOW": btoa(unescape(encodeURIComponent(JSON.stringify(template)))) }
			}).then(result => {
				if ( value == 1 ) {
					Ember.set(this.get('model.rentaLIST'), template.GNAME, true)
					this.get('model.rentaTSHOW').pushObject(template)
				} else {
					Ember.set(this.get('model.rentaLIST'), template.GNAME, false)
					this.get('model.rentaTSHOW').removeObject(template)
				}
				Ember.set(this.get('model.count'), 5, this.get('model.count')[5] + value)
				Ember.set(this.get('hideobutts'), knopk, false)
			})
			}
		}

	}

})
