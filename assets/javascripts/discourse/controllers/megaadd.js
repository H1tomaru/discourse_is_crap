import Controller from '@ember/controller'
import { action } from '@ember/object'
import { tracked } from '@glimmer/tracking'
import { ajax } from 'discourse/lib/ajax'

export default class MyController extends Controller {

	@tracked addstuff = {
		GAME: null,
		STRING: null,
		ADDFB: false
	}
	
	@tracked p4lista = null

	@action
	async oops(event) {
		event?.preventDefault()

		try {
			const result = await ajax(`/admin/MegaAdd`, {
				type: "POST",
				data: {
					GAME: this.addstuff.GAME,
					STRING: this.addstuff.STRING,
					ADDFB: this.addstuff.ADDFB
				}
			})
			this.addstuff = result
			//ember doesnt update on 2nd level variables, so use this shit
			this.addstuff = { ...this.addstuff, ADDFB: false }
		} catch (error) {
			console.error("MegaAdd failed:", error)
		}
	}
	
	@action
	Reset() {
		// Resetting the whole object container cleanly
		this.addstuff = { GAME: null, STRING: null, ADDFB: false }
	}
	
	@action
	FeedbacksGo() {
		// Fix: Reassigning the object container so Ember notices the sub-property change
		this.addstuff = { ...this.addstuff, ADDFB: true }
	}
	
	@action
	FeedbacksStop() {
		// Fix: Same thing here to keep Ember's tracker happy
		this.addstuff = { ...this.addstuff, ADDFB: false }
	}

	@action
	async showP4Lista() {
		try {
			const result = await ajax(`/MrBug.json`)
			
			this.p4lista = result.gamelist
		} catch (error) {
			console.error("Failed to load P4Lista:", error)
		}
	}

}
