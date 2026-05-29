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

	@tracked mOREdoShoW = 0
	
	@tracked otzivmdal = false
	@tracked otzivsmall = false
	@tracked otzivbig = false
	
	@tracked accamdal = false
	@tracked otzvwait = false
	@tracked accawait = false
	@tracked passwait = false
	@tracked actualgp = false
	@tracked pisanina = null

	get fEEDBACKS() {
		let finalvar = []
		const newfbarray = []
		const currentuser = this.currentUser?.username
		let fbedit = false

		// [...array] safely clones the data so .reverse() doesn't modify the source model
		const rawFeedbacks = [...this.model.FEEDBACKS]
		//loop through fb from newest to oldest
		rawFeedbacks.reverse().forEach((item) => {
			//set fb color based on scrore
			if (item.SCORE > 0) item.COLOR = 'zeG'
			if (item.SCORE < 0) item.COLOR = 'zeB'
			if (item.SCORE === 0) item.COLOR = 'zeN'
			//create new final fb item
			newfbarray.push({
				FEEDBACK: item.FEEDBACK, pNAME: item.pNAME,
				DATE: item.DATE, COLOR: item.COLOR
			})
			//onetime check to find and mark users single editable feedback
		    if (!fbedit && currentuser && item.pNAME === currentuser) { 
				newfbarray[newfbarray.length - 1].eDit = true; fbedit = true
		    }
		})
		//save final variable
		// Inline conditional: extracts 11 elements if MENOSHO is true, otherwise extracts 12
    	finalvar = newfbarray.splice(0, this.model?.MENOSHO ? 11 : 12)
		//add more items to view when more pages are viewed
		for (let i = 0; i < this.mOREdoShoW; i++) {
			finalvar.push(newfbarray.splice(0, 12))
		}

		return finalvar
	}

	get mORE() {
		// see how many items are on the screen right now
		const initial = this.model?.MENOSHO ? 11 : 12
		const mOREdoShoWByPages = this.mOREdoShoW * 12
		const currentlyShowingCount = initial + mOREdoShoWByPages
		
		// see if we have more fb to display, true or false
		return this.model?.FEEDBACKS?.length > currentlyShowingCount
	}

	@action
	showMORZ() {
		//increase viewed pages number
		this.mOREdoShoW++
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
	async OtzivZaips(event) {
		event?.preventDefault()

		const fbLength = this.pisanina?.length
		if (fbLength < 21) return this.otzivsmall = true
		if (fbLength > 200) return this.otzivbig = true
		// do stuff if all ok
		Object.assign(this, { otzvwait: true, otzivmdal: false, otzivsmall: false, otzivbig: false })

		try {
			//must use `, not ' or "
			const result = await ajax(`/u/${this.model?.uZar}/kek`, {
				type: "POST",
				//must use `, not ' or "
				data: {	fedbakibaki: btoa(unescape(encodeURIComponent(`${this.ozmode}~${this.score}~${this.pisanina}`))) }
			})
			this.responz = result

			// Executes if creating a brand new feedback submission was successful
			if (result.winrars_z || result.winrars_e) {
				//do full page reaload
				const result2 = await ajax(`/u/${this.model?.uZar}/kek.json`)
				this.model = result2 // Mutating this automatically updates
			}
			
			Object.assign(this, { otzvwait: false, checked1: true, checked2: false, checked3: false, score: 1, pisanina: null })
			
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
