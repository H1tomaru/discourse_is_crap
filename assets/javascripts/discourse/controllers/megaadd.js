import Controller from '@ember/controller'
import { action } from '@ember/object'
import { tracked } from '@glimmer/tracking'
import MegaAddTemplate from '../templates/megaadd'

export default class MyController extends Controller {

	template = MegaAddTemplate

	@tracked addstuff = {
		GAME: '',
		STRING: '',
		ADDFB: false
	}
	
	@tracked p4lista = []

	@action
		async oops(event) {
		event?.preventDefault();
		try {
			const response = await fetch("/admin/MegaAdd/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({
					GAME: this.addstuff.GAME,
					STRING: this.addstuff.STRING,
					ADDFB: this.addstuff.ADDFB
				})
			})
			const result = await response.json()
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
		this.addstuff = { GAME: '', STRING: '', ADDFB: false }
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
	async P4Lista() {
		try {
			const response = await fetch('/MrBug.json')
			const result = await response.json()
			
			this.p4lista = result.gamelist
		} catch (error) {
			console.error("Failed to load P4Lista:", error)
		}
	}

}
