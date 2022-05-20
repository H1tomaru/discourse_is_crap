export default Ember.Controller.extend({

	checked1: true,
	checked2: false,
	checked3: false,
	score: 1,
	ozmode: true,
	responz: null,

	fEEDBACKS: Ember.computed('model.FEEDBACKS', function() {
		var finalvar = {fb1: [], fb2: []}
		var newfbarray = []
		var fbedit = false
		var currentuser = this.get('currentUser.username')

		//loop throug fb and set its color for template, also find last editable fb
		this.get('model.FEEDBACKS').reverse().forEach((item, index) => {
			if (item.SCORE > 0) item.COLOR = 'zeG'
			if (item.SCORE < 0) item.COLOR = 'zeB'
			if (item.SCORE == 0) item.COLOR = 'zeN'

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

	pAGES: Ember.computed('fEEDBACKS.fb2', function() {
		return this.get('fEEDBACKS.fb2').length
	}).property('fEEDBACKS.fb2.[]'),

	mORE: Ember.computed('pAGES', function() {
		if (this.get('pAGES') > 0) {
			return true
		}
		else {
			return false
		}
	}).property('pAGES'),

	otzivmdal: false,
	otzivsmall: false,
	otzivbig: false,

	actions: {

		addOtziv() {
			this.set('responz', null)
			this.set('otzivmdal', true)
			this.set('ozmode', true)
			this.set('pisanina', null)
		},

		editOtziv(fb) {
			this.set('responz', null)
			this.set('otzivmdal', true)
			this.set('ozmode', false)
			this.set('pisanina', fb)
		},

		respCLOZ() {
			this.set('responz', null)
			this.set('otzivsmall', false)
			this.set('otzivbig', false)
		},

		showMORZ() {
			this.get('fEEDBACKS.fb1').pushObjects(this.get('fEEDBACKS.fb2')[0])
			this.get('fEEDBACKS.fb2').removeAt(0)
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
				Ember.$.post("/u/" + this.get('model.uZar') + "/kek", { 
					fedbakibaki: btoa(unescape(encodeURIComponent(this.get('ozmode')+"~"+this.get('score')+"~"+this.get('pisanina'))))
				}).then(result => {
					this.set('responz', result)

					if ( result.winrars == true ) {
						if (this.get('ozmode') == true) {

							console.log("Hello world!")
							var color
							if ( this.get('score') > 0 ) { 
								color = 'zeG'
								Ember.set(this.get('model'), 'fbG', this.get('model.fbG') + 1)
							} else if ( this.get('score') == 0 ) {
								color = 'zeN'
								Ember.set(this.get('model'), 'fbN', this.get('model.fbN') + 1)
							} else if ( this.get('score') < 0 ) {
								color = 'zeB'
								Ember.set(this.get('model'), 'fbB', this.get('model.fbB') + 1)
							}

							//remove edit tag from now not last feedback
							if (this.get('fEEDBACKS.fb1').length > 0) {
								var ni = this.get('fEEDBACKS.fb1').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
								if ( ni >= 0 ) { Ember.set(this.get('fEEDBACKS.fb1').objectAt(ni),'eDit',false) }
							}
							//add this feedback to feedbacks
							this.get('fEEDBACKS.fb1').unshiftObject({
								'pNAME': this.get('currentUser.username'),
								'FEEDBACK': this.get('pisanina'),
								'DATE': new Date().getFullYear()+"."+String(new Date().getMonth()+1).padStart(2,'0')+"."+String(new Date().getDate()).padStart(2,'0'),
								'COLOR': color,
								'eDit': true
							})
							console.log("Hello world22!")
						} else {
							//find last feedback
							var ni = this.get('fEEDBACKS.fb1').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
							//edit it
							Ember.set(this.get('fEEDBACKS.fb1').objectAt(ni),'FEEDBACK',this.get('pisanina'))
							if ( this.get('score') > 0 ) Ember.set(this.get('fEEDBACKS.fb1').objectAt(ni),'COLOR','zeG')
							if ( this.get('score') == 0 ) Ember.set(this.get('fEEDBACKS.fb1').objectAt(ni),'COLOR','zeN')
							if ( this.get('score') < 0 ) Ember.set(this.get('fEEDBACKS.fb1').objectAt(ni),'COLOR','zeB')
						}

						this.set('checked1', true)
						this.set('checked2', false)
						this.set('checked3', false)
						this.set('score', 1)
						this.set('pisanina', null)
					}
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
