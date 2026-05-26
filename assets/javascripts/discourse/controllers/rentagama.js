import Controller from '@ember/controller'
import { action } from '@ember/object'
import { tracked } from '@glimmer/tracking'
import RentagamaTemplate from '../templates/rentagama'

export default class RentagamaController extends Controller {

	template = RentagamaTemplate

	@tracked showLIST = false//localStorage.getItem('showLIST') === "true"
	@tracked showTYPE1 = true
	@tracked showTYPE2 = true
	@tracked showTYPE3 = true
	@tracked showTYPE4 = true

	@tracked showGAMEZ = true
	@tracked showCRAP = false

	@tracked rulez = false

	//loads external script
	constructor() {
		super(...arguments)
		this.lazyLoadScripts()
	}
	
	// Pure helper method to handle script injection asynchronously without jQuery
	async lazyLoadScripts() {
		try {
			//check if script already loaded before, if not, load it
			if (!window.lazySizes) {
				const script = document.createElement('script')
				script.src = 'https://cdnjs.cloudflare.com/ajax/libs/lazysizes/5.1.2/lazysizes.min.js'
				script.async = true
				document.head.appendChild(script)
		  }
		} catch (error) {
			console.error("Failed to load lazysizes:", error)
		}
	}

	@action
	toggleRULEZ() {
		this.rulez = !this.rulez
	}
	
	@action
	setLIST1() {
		this.showLIST = false
		localStorage.setItem('showLIST', "false")
	}
	
	@action
	setLIST2() {
		this.showLIST = true
		localStorage.setItem('showLIST', "true")
	}
	
	@action
	setShowGAMEZ() {
		this.showCRAP = false
		this.showGAMEZ = true
	}
	
	@action
	setShowCRAP() {
		this.showGAMEZ = false
		this.showCRAP = true
	}
	
	@action
	toggleTYPE1() {
		this.showTYPE1 = !this.showTYPE1;
	}
	
	@action
	toggleTYPE2() {
		this.showTYPE2 = !this.showTYPE2;
	}
	
	@action
	toggleTYPE3() {
		this.showTYPE3 = !this.showTYPE3;
	}
	
	@action
	toggleTYPE4() {
		this.showTYPE4 = !this.showTYPE4;
	}
	
}
