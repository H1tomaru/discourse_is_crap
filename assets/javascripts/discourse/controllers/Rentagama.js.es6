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

	disLIST: Ember.computed('model.rentaGAMEZ1'),
	hideoVAR: true,

	rentaHIDEO: Ember.computed('model.rentaTSHOW', function() {
		return this.get('model.rentaTSHOW').sortBy('GNAME')
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
			this.set('disLIST', this.get('model.rentaGAMEZ1'))
			this.set('hideoVAR', true)
		},

		showCRAP() {
			this.set('disLIST', this.get('model.rentaGAMEZ2'))
			this.set('hideoVAR', true)
		},

		showSHITS() {
			this.set('disLIST', this.get('model.rentaGAMEZ3'))
			this.set('hideoVAR', true)
		},

		showHIDEOZ() {
			this.set('disLIST', this.get('model.rentaTSHOW'))
			this.set('hideoVAR', false)
		},

		hideoGAMEZ(template, knopk, value) {
			if (this.get('currentUser.username')) {
			Ember.set(this.get('hideobutts'), knopk, true)
			let ttemp = {GNAME: template.GNAME, GPIC: template.GPIC}
			Ember.$.ajax({
				url: "/renta-halehideo/",
				type: "POST",
				data: { "VALUE": value, "UZA": this.get('currentUser.username'),
				"TSHOW": btoa(unescape(encodeURIComponent(JSON.stringify(ttemp)))) }
			}).then(result => {
				if ( value == 1 ) {
					Ember.set(this.get('model.rentaLIST'), ttemp.GNAME, true)
					this.get('model.rentaTSHOW').pushObject(ttemp)
				} else {
					Ember.set(this.get('model.rentaLIST'), ttemp.GNAME, false)
					this.get('model.rentaTSHOW').removeObject(ttemp)
				}
				Ember.set(this.get('model.count'), 5, this.get('model.count')[5] + value)
				Ember.set(this.get('hideobutts'), knopk, false)
			})
			}
		}

	}

})
