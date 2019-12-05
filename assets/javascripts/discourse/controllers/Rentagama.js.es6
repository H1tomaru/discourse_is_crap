export default Ember.Controller.extend({

	showLIST: true,
	showTYPE1: true,
	showTYPE2: true,
	showTYPE3: true,
	showTYPE4: true,
	rulez: false,
	hideobutts: {},
	
	sortProperties1: ['GNEW:desc', 'GNAME:asc'],
	sortProperties2: ['PR4SORT:desc', 'GNAME:asc'],
	
	rentaGAMEZ: Ember.computed.sort("model.rentaGAMEZ", "sortProperties1"),
	rentaGAMEZ1: Ember.computed.sort("model.rentaGAMEZ1", "sortProperties2"),
	rentaGAMEZ2: Ember.computed.sort("model.rentaGAMEZ2", "sortProperties2"),
	rentaGAMEZ3: Ember.computed.sort("model.rentaGAMEZ3", "sortProperties2"),
	rentaHIDEO: Ember.computed.sort("model.rentaHIDEO", "sortProperties2"),//.property('model.rentaHIDEO.[]'),
	//renta2LIST: this.get('rentaGAMEZ1'),

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
			this.set('showLIST', true)
		},

		showLIST2() {
			this.set('showLIST', false)
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
			this.set('renta2LIST', this.get('rentaGAMEZ1'))
		},

		showCRAP() {
			this.set('renta2LIST', this.get('rentaGAMEZ2'))
		},

		showSHITS() {
			this.set('renta2LIST', this.get('rentaGAMEZ3'))
		},

		showHIDEOZ() {
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
					for (var i = this.get('model.rentaGAMEZ').length - 1; i >= 0; --i) {
						var game = this.get('model.rentaGAMEZ')[i]
						game.HIDEOZ = !game.HIDEOZ

						this.get('model.rentaHIDEO').pushObject(game)

						this.get('model.rentaGAMEZ').removeAt(i)

						if (game.TYPE1) {
							for (var z = this.get('model.rentaGAMEZ1').length - 1; z >= 0; --z) {
								if (this.get('model.rentaGAMEZ1')[z]['GNAME'] == gNAME) {
									this.get('model.rentaGAMEZ1').removeAt(z)
								}
							}
						}
						if (game.TYPE2 || game.TYPE3) {
							for (var z = this.get('model.rentaGAMEZ2').length - 1; z >= 0; --z) {
								if (this.get('model.rentaGAMEZ2')[z]['GNAME'] == gNAME) {
									this.get('model.rentaGAMEZ2').removeAt(z)
								}
							}
						}
						if (game.TYPE4) {
							for (var z = this.get('model.rentaGAMEZ3').length - 1; z >= 0; --z) {
								if (this.get('model.rentaGAMEZ3')[z]['GNAME'] == gNAME) {
									this.get('model.rentaGAMEZ3').removeAt(z)
								}
							}
						}

					}
				}

				if ( value == -1 ) {
					for (var i = this.get('model.rentaHIDEO').length - 1; i >= 0; --i) {
						if (this.get('model.rentaHIDEO')[i]['GNAME'] == gNAME) {
							var game = this.get('model.rentaHIDEO')[i]
							game.HIDEOZ = !game.HIDEOZ

							this.get('model.rentaGAMEZ').pushObject(game)
							if (game.TYPE1) {this.get('model.rentaGAMEZ1').pushObject(game)}
							if (game.TYPE2 || game.TYPE3) {this.get('model.rentaGAMEZ2').pushObject(game)}
							if (game.TYPE4) {this.get('model.rentaGAMEZ3').pushObject(game)}

							this.get('model.rentaHIDEO').removeAt(i)
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
