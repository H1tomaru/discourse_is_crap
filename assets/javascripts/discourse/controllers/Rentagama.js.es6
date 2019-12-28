export default Ember.Controller.extend({

	inprogress: false,
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
		return this.get('model.rentaTSHOW').sortBy('GNAME')
	}).property('model.rentaTSHOW.[]'),

	LazyLoadLoad: function() {
		Ember.run.scheduleOnce('afterRender', this, function() {
			Ember.$.getScript('https://cdnjs.cloudflare.com/ajax/libs/lazysizes/5.1.2/lazysizes.min.js')
		})
	}.on('init'),

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
			if (this.get('currentUser.username') && !this.get('inprogress')) {
				this.set('inprogress', true)
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
						var rIndex = this.get('model.rentaTSHOW').map(function(item) { return item.GNAME }).indexOf(ttemp.GNAME)
						this.get('model.rentaTSHOW').splice(rIndex, 1)
					}
					Ember.set(this.get('model.count'), 5, this.get('model.count')[5] + value)
					Ember.set(this.get('hideobutts'), knopk, false)
					this.set('inprogress', false)
				})
			}
		}

	}

})
