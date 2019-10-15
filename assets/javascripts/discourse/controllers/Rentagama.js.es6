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
	
	sortProperties1: ['GNEW:desc', 'GNAME:asc'],
	sortProperties2: ['GNAME:asc'],
	
	rentaGAMEZ: Ember.computed.sort("model.rentaGAMEZ", "sortProperties1"),
	rentaHIDEO: Ember.computed.sort("model.rentaHIDEO", "sortProperties2"),

	/*
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

		hideoGAMEZ(gNAME, knopk, value) {
			Ember.set(this.get('hideobutts'), knopk, true)
			Ember.$.ajax({
				url: "/renta-halehideo/",
				type: "POST",
				data: { "HIDEOFU": btoa(unescape(encodeURIComponent(gNAME))) }
			}).then(result => {
				for (let i = 0; i < this.get('rentaGAMEZ').length; i++) {
					if (this.get('rentaGAMEZ')[i]['GNAME'] == gNAME) { Ember.set(this.get('rentaGAMEZ')[i], 'HIDEOZ', !this.get('rentaGAMEZ')[i].HIDEOZ) }
				}
				for (let i = 0; i < this.get('model.rentaGAMEZ1').length; i++) {
					if (this.get('model.rentaGAMEZ1')[i]['GNAME'] == gNAME) {
						Ember.set(this.get('model.rentaGAMEZ1')[i], 'HIDEOZ', !this.get('model.rentaGAMEZ1')[i].HIDEOZ)
						if (value == 1) {
							this.get('rentaHIDEO').pushObject(this.get('model.rentaGAMEZ1')[i])
						}						
					}
				}
				for (let i = 0; i < this.get('model.rentaGAMEZ2').length; i++) {
					if (this.get('model.rentaGAMEZ2')[i]['GNAME'] == gNAME) {
						Ember.set(this.get('model.rentaGAMEZ2')[i], 'HIDEOZ', !this.get('model.rentaGAMEZ2')[i].HIDEOZ)
						if (value == 1) {
							this.get('rentaHIDEO').pushObject(this.get('model.rentaGAMEZ2')[i])
						}						
					}
				}
				for (let i = 0; i < this.get('model.rentaGAMEZ3').length; i++) {
					if (this.get('model.rentaGAMEZ3')[i]['GNAME'] == gNAME) {
						Ember.set(this.get('model.rentaGAMEZ3')[i], 'HIDEOZ', !this.get('model.rentaGAMEZ3')[i].HIDEOZ)
						if (value == 1) {
							this.get('rentaHIDEO').pushObject(this.get('model.rentaGAMEZ3')[i])
						}
					}
				}
				for (let i = 0; i < this.get('rentaHIDEO').length; i++) {
					if (this.get('rentaHIDEO')[i]['GNAME'] == gNAME) {
						this.get('rentaHIDEO').removeAt(i)
					}
				}
				this.get('rentaHIDEO').sortBy('GNAME:asc')
				Ember.set(this.get('model.count'), 5, this.get('model.count')[5] + value)
				Ember.set(this.get('hideobutts'), knopk, false)
			})
		}

	}

})
