import Controller from '@ember/controller'
import { action } from '@ember/object'
import { service } from '@ember/service'
import { tracked } from '@glimmer/tracking'
import { ajax } from 'discourse/lib/ajax'

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
		const rawFeedbacks = [...this.model.FEEDBACKS]
		//loop throug fb and set its color for template, also find last editable fb
		rawFeedbacks.reverse().forEach((item) => {
			if (item.SCORE > 0) item.COLOR = 'zeG'
			if (item.SCORE < 0) item.COLOR = 'zeB'
			if (item.SCORE === 0) item.COLOR = 'zeN'

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
		Object.assign(this, { responz: null, ozmode: true, pisanina: null })
		this.otzivmdal = !this.otzivmdal
	}

	@action
	clozOtziv() {
		this.otzivmdal = false
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
	async OtzivZaips(event) {
		event?.preventDefault()

		const fbLength = this.pisanina?.length
		if (fbLength < 21) return this.otzivsmall = true
		if (fbLength > 200) return this.otzivbig = true
		// do stuff if all ok
		Object.assign(this, { otzivmdal: false, otzivsmall: false, otzivbig: false })

		try {
			//must use `, not ' or "
			const result = await ajax(`/u/${this.model?.uZar}/kek`, {
				type: "POST",
				//must use `, not ' or "
				data: {	fedbakibaki: btoa(unescape(encodeURIComponent(`${this.ozmode}~${this.score}~${this.pisanina}`))) }
			})
			this.responz = result

			// Executes if creating a brand new feedback submission was successful
			if (result.winrars_z) {
				//draw this new fb on a page
				//find fb color first and increase corresponding fb number
				let color = 'zeN'
				
				// Flat, classic if/else statements for model tracking updates
				if (this.score > 0) {
					color = 'zeG'
					this.model.fbG = (this.model.fbG) + 1
				} else if (this.score === 0) {
					color = 'zeN'
					this.model.fbN = (this.model.fbN) + 1
				} else if (this.score < 0) {
					color = 'zeB'
					this.model.fbB = (this.model.fbB) + 1
				}
				
				//remove edit tag from now not last feedback
				const ni = this.fEEDBACKS.fb1.findIndex(it => it.pNAME === this.currentUser.username)
				if (ni >= 0) this.fEEDBACKS.fb1[ni].eDit = false
				
				// Unshifts inserts the new feedback live right at the top of the timeline
				this.fEEDBACKS.fb1.unshift({
					pNAME: this.currentUser.username,
					FEEDBACK: this.pisanina,
					DATE: new Date().toISOString().slice(0, 10).replace(/-/g, '.'), // Fast native YYYY.MM.DD string format
					COLOR: color,
					eDit: true
				})
				this.model = { ...this.model } // Wake up Ember template tracking
			}
			
			// Executes if updating an existing feedback was successful
			if (result.winrars_e) {
				//find last feedback
				const ni = this.fEEDBACKS.fb1.findIndex(it => it.pNAME === this.currentUser.username)
				if (ni >= 0) {
					//edit it
					this.fEEDBACKS.fb1[ni].FEEDBACK = this.pisanina
					
					if (this.score > 0) this.fEEDBACKS.fb1[ni].COLOR = 'zeG'
					if (this.score < 0) this.fEEDBACKS.fb1[ni].COLOR = 'zeB'
					if (this.score === 0) this.fEEDBACKS.fb1[ni].COLOR = 'zeN'
				}
				this.model = { ...this.model } // Wake up Ember template tracking
			}
			
			Object.assign(this, { checked1: true, checked2: false, checked3: false, score: 1, pisanina: null })
			
		} catch (error) {
			console.error("Network call execution failed:", error)
		}
	}

	@action
	selectOtz(input) {
		//set variable checked1 2 3 to true and false, for corresponding input
		this.checked1 = input === 1
		this.checked2 = input === 2
		this.checked3 = input === 3
		
		if (input === 1) this.score = 1
		if (input === 2) this.score = 0
		if (input === 3) this.score = -1
	}

	@action
	async runTroikopoisk(poisk, acc) {
		Object.assign(this, { accamdal: true, accawait: true, actualgp: false })
		try {
			this.troikopoisk = await ajax(`/MrBug/troikopoisk/`, {
				type: "POST",
				data: {
					poisk: btoa(unescape(encodeURIComponent(poisk))),
					acc: btoa(unescape(encodeURIComponent(acc)))
				}
			})
			this.accawait = false
		} catch (error) {
			console.error("Troikopoisk submission failed:", error)
		}
	}
	
	@action
	async getPaZZ(input) {
		this.passwait = true
		try {
			//must use `, not ' or "
			this.actualgp = await ajax(`/u/${this.currentUser?.username}/kek/oishiiii`, {
				type: "POST",
				data: {	myylo: btoa(unescape(encodeURIComponent(input))) }
			})
			this.passwait = false
		} catch (error) {
			console.error("getPaZZ transaction failed:", error)
		}
	}

}
