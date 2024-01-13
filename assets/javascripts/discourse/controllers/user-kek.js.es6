import Ember from 'ember';
import $ from 'jquery';

export default Ember.Controller.extend({

	checked1: true,
	checked2: false,
	checked3: false,
	score: 1,
	ozmode: true,
	troikopoisk: null,
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
			if (fbedit == false && currentuser && item.pNAME == currentuser) { newfbarray[newfbarray.length - 1]['eDit'] = true; fbedit = true }
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
		
		//reset page, cos shit not reset if no page reload
		this.set('accamdal', false)
		this.set('actualgp', false)
		this.set('troikopoisk', false)
		this.set('responz', false)

		return finalvar

 	}),

	mORE: Ember.computed('fEEDBACKS.fb2', 'fEEDBACKS.fb2.[]', function() {
		if (this.get('fEEDBACKS.fb2').length > 0) {
			return true
		}
		else {
			return false
		}
	}),

	otzivmdal: false,
	otzivsmall: false,
	otzivbig: false,

	accamdal: false,
	accawait: false,
	passwait: false,
	actualgp: false,

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

				$.post("/u/" + this.get('model.uZar') + "/kek", { 
					fedbakibaki: btoa(unescape(encodeURIComponent(this.get('ozmode')+"~"+this.get('score')+"~"+this.get('pisanina'))))
				}).then(result => {
					this.set('responz', result)

					if ( result.winrars_z == true ) {
						var color

						if ( this.get('score') > 0 ) {
							color = 'zeG'
							this.set('model.fbG', this.get('model.fbG') + 1)
						} else if ( this.get('score') == 0 ) {
							color = 'zeN'
							this.set('model.fbN', this.get('model.fbN') + 1)
						} else if ( this.get('score') < 0 ) {
							color = 'zeB'
							this.set('model.fbB', this.get('model.fbB') + 1)
						}

						//remove edit tag from now not last feedback
						if (this.get('fEEDBACKS.fb1').length > 0) {
							var ni = this.get('fEEDBACKS.fb1').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
							if ( ni >= 0 ) { Ember.set(this.get('fEEDBACKS.fb1').objectAt(ni), 'eDit', false) }
						}

						//add this feedback to feedbacks
						this.get('fEEDBACKS.fb1').unshiftObject({
							'pNAME': this.get('currentUser.username'),
							'FEEDBACK': this.get('pisanina'),
							'DATE': new Date().getFullYear()+"."+String(new Date().getMonth()+1).padStart(2,'0')+"."+String(new Date().getDate()).padStart(2,'0'),
							'COLOR': color,
							'eDit': true
						})
					}

					if ( result.winrars_e == true ) {
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
		},

		troikopoisk(poisk, acc) {
			this.set('accamdal', true)
			this.set('accawait', true)
			this.set('actualgp', false)

			$.post("/MrBug/troikopoisk/", { 
				poisk: btoa(unescape(encodeURIComponent(poisk))),
				acc: btoa(unescape(encodeURIComponent(acc)))
			}).then(result => {
				this.set('troikopoisk', result)
				this.set('accawait', false)
			})
		},

		getPaZZ(input) {
			this.set('passwait', true)
			$.post("/u/"+this.get('currentUser.username')+"/kek/oishiiii", { 
				myylo: btoa(unescape(encodeURIComponent(input)))
			}).then(result => {
				this.set('actualgp', result)
				this.set('passwait', false)
			})
		}

	}

})
