import Controller from '@ember/controller'
import { action } from '@ember/object'
import { service } from '@ember/service'
import { tracked } from '@glimmer/tracking'

export default class MyController extends Controller {
	@service currentUser
	// UI state variables tracking checkboxes, modal boxes, and loading spinners
	@tracked checked1 = true
	@tracked checked2 = false
	@tracked checked3 = false
	@tracked score = 1
	@tracked ozmode = true
	@tracked troikopoisk = null
	@tracked responz = null
	
	@tracked otzivmdal = false
	@tracked otzivsmall = false
	@tracked otzivbig = false
	
	@tracked accamdal = false
	@tracked accawait = false
	@tracked passwait = false
	@tracked actualgp = false
	@tracked pisanina = null

	get fEEDBACKS() {
		const finalvar = { fb1: [], fb2: [] }
		const newfbarray = []
		const currentuser = this.currentUser?.username
		let fbedit = false

		// [...array] safely clones the data so .reverse() doesn't modify the source model
		const rawFeedbacks = this.model?.FEEDBACKS ? [...this.model.FEEDBACKS] : []
		//loop throug fb and set its color for template, also find last editable fb
		rawFeedbacks.reverse().forEach((item) => {
			// Nested ternary: If score > 0 use green, else if score < 0 use blue, otherwise neutral
			item.COLOR = item.SCORE > 0 ? 'zeG' : (item.SCORE < 0 ? 'zeB' : 'zeN')

			newfbarray.push({
				FEEDBACK: item.FEEDBACK, pNAME: item.pNAME,
				DATE: item.DATE, COLOR: item.COLOR
			})
			//onetime check for users last feedback to flag it as editable
		    if (!fbedit && currentuser && item.pNAME === currentuser) { 
				newfbarray[newfbarray.length - 1].eDit = true; fbedit = true
		    }
		})
		//save final variable
		// Inline conditional: extracts 11 elements if MENOSHO is true, otherwise extracts 12
    	finalvar.fb1 = newfbarray.splice(0, this.model?.MENOSHO ? 11 : 12)

		// Dynamically chunks all remaining feedbacks into blocks of 12 for page 2+
		while (newfbarray.length > 0) {
			finalvar.fb2.push(newfbarray.splice(0, 12))
		}

		return finalvar
	}

	// Boolean check: returns true if there is a second page of feedbacks to display
	get mORE() {
		return this.fEEDBACKS.fb2.length > 0
	}

	@action
	addOtziv() {
		// Object.assign resets multiple trackable states at once on a single line
		Object.assign(this, { responz: null, otzivmdal: true, ozmode: true, pisanina: null })
	}
	
	@action
	editOtziv(fb) {
		// Toggles the modal into edit-mode and prefills it with the clicked feedback text
		Object.assign(this, { responz: null, otzivmdal: true, ozmode: false, pisanina: fb })
	}
	
	@action
	respCLOZ() {
		// Closes small/big length error validation notifications
		Object.assign(this, { responz: null, otzivsmall: false, otzivbig: false })
	}
	
	@action
	showMORZ() {
		// Unpacks exactly the first 12-item chunk from page 2 into page 1
		this.fEEDBACKS.fb1.push(...this.fEEDBACKS.fb2[0])
		
		this.fEEDBACKS.fb2.shift() // Deletes the chunk we just moved out
		this.model = { ...this.model } // Alerts Ember to redraw the page
	}

	@action
	async OtzivZaips() {
		const fbLength = this.pisanina?.length || 0
		if (fbLength < 20) return this.otzivsmall = true
		if (fbLength > 200) return this.otzivbig = true
		// do stuff of all ok
		Object.assign(this, { otzivmdal: false, otzivsmall: false, otzivbig: false })

		try {
			const payload = btoa(unescape(encodeURIComponent(`${this.ozmode}~${this.score}~${this.pisanina}`)))
			const response = await fetch(`/u/${this.model?.uZar}/kek`, {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({ fedbakibaki: payload })
			})
			const result = await response.json()
			this.responz = result

			// Executes if creating a brand new feedback submission was successful
			if (result.winrars_z) {
				//draw this new fb on a page
				//find fb color first and increase corresponding fb number
				//Map configurations using score rules to match counters and colors instantly
				const scoreProps = { 1: { color: 'zeG', model: 'fbG' }, 0: { color: 'zeN', model: 'fbN' }, '-1': { color: 'zeB', model: 'fbB' } }
				const scoreKey = this.score > 0 ? 1 : (this.score < 0 ? -1 : 0) // Fast boundary map
				const config = scoreProps[scoreKey]
				
				// Increments the target model total tally counter (e.g. model.fbG++)
				this.model[config.model] = (this.model[config.model] || 0) + 1
				
				// findIndex scans list directly. Disables edit on user's older posts.
				const ni = this.fEEDBACKS.fb1.findIndex(it => it.pNAME === this.currentUser.username)
				if (ni >= 0) this.fEEDBACKS.fb1[ni].eDit = false
				
				// Unshifts inserts the new feedback live right at the top of the timeline
				this.fEEDBACKS.fb1.unshift({
				pNAME: this.currentUser.username,
				FEEDBACK: this.pisanina,
				DATE: new Date().toISOString().slice(0, 10).replace(/-/g, '.'), // Fast native YYYY.MM.DD string format
				COLOR: config.c,
				eDit: true
				})
				this.model = { ...this.model } // Wake up Ember template tracking
			}
			
			// Executes if updating an existing feedback was successful
			if (result.winrars_e) {
				const ni = this.fEEDBACKS.fb1.findIndex(it => it.pNAME === this.currentUser.username)
				if (ni >= 0) {
				this.fEEDBACKS.fb1[ni].FEEDBACK = this.pisanina
				this.fEEDBACKS.fb1[ni].COLOR = this.score > 0 ? 'zeG' : (this.score < 0 ? 'zeB' : 'zeN')
				}
				this.model = { ...this.model } // Wake up Ember template tracking
			}
			
			Object.assign(this, { checked1: true, checked2: false, checked3: false, score: 1, pisanina: null })
			
		} catch (error) {
			console.error("Network call execution failed:", error)
		}
	}



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

}
