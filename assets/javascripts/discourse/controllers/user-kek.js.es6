export default Ember.Controller.extend({

	checked1: true,
	checked2: false,
	checked3: false,
	score: 1,
	ozmode: 666,
	responz: null,

	FEEDBACKS: Ember.computed('model.FEEDBACKS', function() {
		var finalvar = {fb1: [], fb2: []}
		var newfbarray = []
		var fbedit = false
		var currentuser = this.get('currentUser.username')

		//loop throug fb and set its color for template, also find last editable fb
		this.get('model.FEEDBACKS').reverse().forEach((item, index) => {
			if (item.SCORE) > 0 item.COLOR = 'zeG'
			if (item.SCORE) < 0 item.COLOR = 'zeB'
			if (item.SCORE) == 0 item.COLOR = 'zeN'

			newfbarray.push({
				FEEDBACK: item.FEEDBACK, pNAME: item.pNAME,
				DATE: item.DATE, COLOR: item.COLOR
			})

			//onetime check for users last feedback to make it editable
			if (fbedit == false && currentuser && item.pNAME == currentuser) { newfbarray.[newfbarray.length - 1].eDit = true; fbedit = true }
		})

		//save final variable
		if ( this.get('model.MENOSHO') == true ) {
			finalvar.fb1 = newfbarray.splice(0, 11)
		} else {
			finalvar.fb1 = newfbarray.splice(0, 12)
		}
		while (newfbarray.length > 0) {
			finalvar.fb2.push (newfbarray.splice(0, 12))
		}

		return finalvar

 	}),

	PAGES: Ember.computed('FEEDBACKS.fb2', function() {
		return this.get('FEEDBACKS.fb2').length
	}),

	MORE: Ember.computed('PAGES', function() {
		if (this.get('PAGES') > 0) {
			return true
		}
		else {
			return false
		}
	}),

	otzivmdal: false,
	otzivsmall: false,
	otzivbig: false,

	//cum2m: Ember.computed('model.FEEDBACKS', function() {
	//	if (this.get('pagesNO') > 1) return true
	//}),

	//showfbARC: Ember.computed('model.FEEDBACKS', function() {
	//	if (this.get('pagesNO') == 1 && this.get('model.fbARC') > 0) return true
	//}),

	actions: {

		addOtziv() {
			this.set('responz', null)
			this.set('otzivmdal', true)
			this.set('ozmode', 666)
			this.set('pisanina', null)
		},

		editOtziv(fb) {
			this.set('responz', null)
			this.set('otzivmdal', true)
			this.set('ozmode', 1337)
			this.set('pisanina', fb)
		},

		respCLOZ() {
			this.set('responz', null)
			this.set('otzivsmall', false)
			this.set('otzivbig', false)
		},

		showMORZ() {
			this.get('model.FEEDBACKS').pushObjects(this.get('model.FEEDBACKS2')[0])
			this.get('model.FEEDBACKS2').removeAt(0)
			this.set('thisPA', this.get('thisPA') + 1)
			if (this.get('thisPA') == this.get('pagesNO')) this.set('cum2m', false)
			if (this.get('cum2m') == false && this.get('model.fbARC') > 0) this.set('showfbARC', true)			
		},

		OtzivZaips() {
			if (this.get('pisanina').length < 20) {
				this.set('otzivsmall', true)
			} else if (this.get('pisanina').length > 200) {
				this.set('otzivbig', true)
			} else {
				this.set('otzivmdal', false)
				this.set('otzivsmall', false)
				this.set('otzivbig', false)
				Ember.$.post("/posos/", { 
					pNAME: this.get('currentUser.username')
				}).then(result => {
					Ember.$.post("/u/" + this.get('model.uZar') + "/kek", { 
						fedbakibaki: btoa(this.get('ozmode')+"~"+this.get('score')+"~"+this.get('pisanina'))
					}).then(result => {
						this.set('responz', result)
						if ( result.winrars == true ) {
							if (this.get('ozmode') == 666) {
								if ( this.get('score') > 0 ) { this.set('score', 'zeG')
									Ember.set(this.get('model'), 'fbG', this.get('model.fbG') + 1) }
								else if ( this.get('score') == 0 ) { this.set('score', 'zeN')
									Ember.set(this.get('model'), 'fbN', this.get('model.fbN') + 1) }
								else if ( this.get('score') < 0 ) { this.set('score', 'zeB')
									Ember.set(this.get('model'), 'fbB', this.get('model.fbB') + 1) }
								if (this.get('model.FEEDBACKS').length > 0) {
									var ni = this.get('pageFB').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
									if ( ni >= 0 ) { Ember.set(this.get('model.FEEDBACKS').objectAt(ni),'eDit',false) }
								}
								this.get('model.FEEDBACKS').unshiftObject({
									'pNAME': this.get('currentUser.username'),
									'FEEDBACK': this.get('pisanina'),
									'DATE': new Date().getFullYear()+"."+String(new Date().getMonth()+1).padStart(2,'0')+"."+String(new Date().getDate()).padStart(2,'0'),
									'COLOR': this.get('score'),
									'eDit': true
								})
							} else {
								var ni = this.get('pageFB').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
								Ember.set(this.get('model.FEEDBACKS').objectAt(ni),'FEEDBACK',this.get('pisanina'))
								if ( this.get('score') > 0 ) Ember.set(this.get('model.FEEDBACKS').objectAt(ni),'COLOR','zeG')
								if ( this.get('score') == 0 ) Ember.set(this.get('model.FEEDBACKS').objectAt(ni),'COLOR','zeN')
								if ( this.get('score') < 0 ) Ember.set(this.get('model.FEEDBACKS').objectAt(ni),'COLOR','zeB')
							}
							this.set('checked1', true)
							this.set('checked2', false)
							this.set('checked3', false)
							this.set('score', 1)
							this.set('pisanina', null)
						}
					})
				})
			}
		},

		selectOtz(input) {
			if ( input == 1 ) {
				this.set('checked1', true)
				this.set('checked2', false)
				this.set('checked3', false)
				this.set('score', 1)
			} else if ( input == 2 ) {
				this.set('checked1', false)
				this.set('checked2', true)
				this.set('checked3', false)
				this.set('score', 0)
			} else if ( input == 3 ) {
				this.set('checked1', false)
				this.set('checked2', false)
				this.set('checked3', true)
				this.set('score', -1)
			} 
		}

	}

})
