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
	
	sortProperties1: ['GNEW:desc', 'GNAME:asc'],
	sortProperties2: ['PR4SORT:desc', 'GNAME:asc'],
	
	rentaGAMEZ: Ember.computed.sort("model.rentaGAMEZ", "sortProperties1"),//.property('model.rentaGAMEZ.[]'),
	rentaGAMEZ1: Ember.computed.sort("model.rentaGAMEZ1", "sortProperties2"),//.property('model.rentaGAMEZ1.[]'),
	rentaGAMEZ2: Ember.computed.sort("model.rentaGAMEZ2", "sortProperties2"),//.property('model.rentaGAMEZ2.[]'),
	rentaGAMEZ3: Ember.computed.sort("model.rentaGAMEZ3", "sortProperties2"),//.property('model.rentaGAMEZ3.[]'),
	rentaHIDEO: Ember.computed.sort("model.rentaHIDEO", "sortProperties2"),//.property('model.rentaHIDEO.[]'),

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
			this.set('renta2LIST', this.get('rentaGAMEZ1'))
		},

		showCRAP() {
			this.set('showGAMEZ', false)
			this.set('showSHITS', false)
			this.set('showHIDEOZ', false)
			this.set('showCRAP', true)
			this.set('renta2LIST', this.get('rentaGAMEZ2'))
		},

		showSHITS() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', false)
			this.set('showHIDEOZ', false)
			this.set('showSHITS', true)
			this.set('renta2LIST', this.get('rentaGAMEZ3'))
		},

		showHIDEOZ() {
			this.set('showGAMEZ', false)
			this.set('showCRAP', false)
			this.set('showSHITS', false)
			this.set('showHIDEOZ', true)
			this.set('renta2LIST', this.get('rentaHIDEO'))
		},

		hideoGAMEZ(gNAME, knopk, value) {
			if (this.get('currentUser.username')) {
			Ember.set(this.get('hideobutts'), knopk, true)
			Ember.$.ajax({
				url: "/renta-halehideo/",
				type: "POST",
				data: { "HIDEOFU": btoa(unescape(encodeURIComponent(this.get('currentUser.username')+"~"+gNAME))) }
			}).then(result => {
				if ( value == 1 ) {
					for (var i = this.get('rentaGAMEZ').length - 1; i >= 0; --i) {
						var game = this.get('rentaGAMEZ')[i]
						game.HIDEOZ = !game.HIDEOZ

						this.get('rentaHIDEO').pushObject(game)

						this.get('rentaGAMEZ').removeAt(i)

						if (game.TYPE1) {
							for (var z = this.get('rentaGAMEZ1').length - 1; z >= 0; --z) {
								if (this.get('rentaGAMEZ1')[z]['GNAME'] == gNAME) {
									this.get('rentaGAMEZ1').removeAt(z)
								}
							}
						}
						if (game.TYPE2 || game.TYPE3) {
							for (var z = this.get('rentaGAMEZ2').length - 1; z >= 0; --z) {
								if (this.get('rentaGAMEZ2')[z]['GNAME'] == gNAME) {
									this.get('rentaGAMEZ2').removeAt(z)
								}
							}
						}
						if (game.TYPE4) {
							for (var z = this.get('rentaGAMEZ3').length - 1; z >= 0; --z) {
								if (this.get('rentaGAMEZ3')[z]['GNAME'] == gNAME) {
									this.get('rentaGAMEZ3').removeAt(z)
								}
							}
						}

					}
				}

				if ( value == -1 ) {
					for (var i = this.get('rentaHIDEO').length - 1; i >= 0; --i) {
						if (this.get('rentaHIDEO')[i]['GNAME'] == gNAME) {
							var game = this.get('rentaHIDEO')[i]
							game.HIDEOZ = !game.HIDEOZ

							this.get('rentaGAMEZ').pushObject(game)
							if (game.TYPE1) {this.get('rentaGAMEZ1').pushObject(game)}
							if (game.TYPE2 || game.TYPE3) {this.get('rentaGAMEZ2').pushObject(game)}
							if (game.TYPE4) {this.get('rentaGAMEZ3').pushObject(game)}

							this.get('rentaHIDEO').removeAt(i)
						}
					}
				}

				Ember.set(this.get('model.count'), 5, this.get('model.count')[5] + value)
				Ember.set(this.get('hideobutts'), knopk, false)
			})
			}
		}

	}

})
