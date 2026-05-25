import Controller from '@ember/controller'
import { action } from '@ember/object'
import { tracked } from '@glimmer/tracking'

export default class MyController extends Controller {

	@tracked showLIST = localStorage.getItem('showLIST') === "true"
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
	showRULEZ() {
		this.rulez = !this.rulez
	}
	
	@action
	showLIST1() {
		this.showLIST = false
		localStorage.setItem('showLIST', "false")
	}
	
	@action
	showLIST2() {
		this.showLIST = true
		localStorage.setItem('showLIST', "true")
	}
	
	@action
	showGAMEZ() {
		this.showCRAP = false
		this.showGAMEZ = true
	}
	
	@action
	showCRAP() {
		this.showGAMEZ = false
		this.showCRAP = true
	}
	
	@action
	showTYPE1() {
		this.showTYPE1 = !this.showTYPE1;
	}
	
	@action
	showTYPE2() {
		this.showTYPE2 = !this.showTYPE2;
	}
	
	@action
	showTYPE3() {
		this.showTYPE3 = !this.showTYPE3;
	}
	
	@action
	showTYPE4() {
		this.showTYPE4 = !this.showTYPE4;
	}
}
