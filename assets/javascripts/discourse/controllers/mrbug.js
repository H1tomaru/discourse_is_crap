import Controller from '@ember/controller'
import { action } from '@ember/object'
import { service } from '@ember/service'
import { tracked } from '@glimmer/tracking'
import { ajax } from 'discourse/lib/ajax'

export default class MyController extends Controller {

	//gets current user?
	@service currentUser

	//default states
	// Tracked states for automatic template rerendering
	@tracked bagamdal = false
	@tracked mdalready = false
	@tracked prezaips = null
	@tracked pzposition = null
	@tracked zaipsResult = null
	@tracked showhideo = [true, true, true]

	get glizt () {
		//make variables for each game type
		const finalvar = {gamedb1: [], gamedb2: [], gamedb3: [], maigamez1: [], maigamez2: []}
		const currentuser = this.currentUser?.username
		const gameList = this.model?.gamelist

		gameList.forEach((item) => {
			//template stuff, if paint game red or green
			item.MODE1 = false; item.MODE2 = false

			//if not guest, check if user is in this troika
			if (currentuser) {
				//template shit for type 2 and 3 games displaying type 2 and 3 stuff
				//cool way for simlified true false stuff
				const gTYPE2 = item.TYPE === 2
       			const gTYPE3 = item.TYPE === 3

				//loop thorought troikas and see if current user is in it
				item.TROIKI.forEach((troika) => {
					//template stuff, if paint user sostav red or green
					troika.MODE1 = false; troika.MODE2 = false

					//calculate if user is in this troika, if he is, add user + gname to list, also gamechangecolor = true, troika change color = true
					for (let i = 0; i < 3; i++) {
						if (currentuser === troika['USERS']?.[i]) {
							//declare variables with let/const so they don't leak globally
				            let PPRICE
				            let PPOSITION
							//see if we are p2 or p4 to show its P position and P price
							if (i === 0) {
								PPRICE = item.PRICE2
								PPOSITION = 2
							} else {
								PPRICE = item.PRICE4
								PPOSITION = 4
							}
							if (troika['PSTATUS']?.[i]?.[0] == true) {
								item.MODE1 = true; troika.MODE1 = true; item.MODE2 = false; troika.MODE2 = false
								finalvar.maigamez1.push( {
									POSITION: PPOSITION, gNAME: item.gameNAME, gPIC: item.imgLINK, PRICE: PPRICE,
									DATE: item.DATE, TYPE2: gTYPE2, TYPE3: gTYPE3
								} )
							} else {
								if (item.MODE1 === false) item.MODE2 = true
								if (troika.MODE1 === false) troika.MODE2 = true
								finalvar.maigamez2.push( { POSITION: PPOSITION, gNAME: item.gameNAME, gPIC: item.imgLINK } )
							}
						}
					} 
				})
			}

			//fill 3 variables for each game type
			if (item.TYPE == 1) finalvar.gamedb1.push( { POSITION: "PPOSITION", gNAME: "gameNAME", gPIC: "imgLINK" } )//.push(item)
			if (item.TYPE == 2) finalvar.gamedb2.push(item)
			if (item.TYPE == 3) finalvar.gamedb3.push(item)
		})

		return finalvar
	}

	@action
	netmudal() {
		this.bagamdal = false
		this.mdalready = false
		this.prezaips = null
		this.zaipsResult = null
	}

	@action
	async zaips(knopk, gcode) {
		this.bagamdal = true
		//if not guest, do prezaips, else display guest message
		const currentuser = this.currentUser?.username
		
		if (currentuser) {
			try {
				const result = await ajax("/MrBug/prezaips/", {
					type: "POST",
					data: {
						bagakruta: btoa(`${knopk}~${gcode}`)
					}
				})
				this.prezaips = result

				this.pzposition = result['position']?.[0]

				this.mdalready = true
		 	} catch (error) {
				console.error("Failed to run prezaips post syntax:", error)
			}
		} else {
			this.prezaips = { guest: true }
			this.mdalready = true
		}
	}

	@action
	async imgoingin() {
		this.mdalready = false
		//ember doesnt update on 2nd level variables, so use this shit
		this.prezaips = { ...this.prezaips, winrars: false }
		
		try {
			const result = await ajax("/MrBug/zaips/", {
				type: "POST",
				data: {
					bagatrolit: btoa(unescape(encodeURIComponent(`${this.prezaips?.position}~${this.currentUser?.username}~${this.prezaips?._id}~${this.prezaips?.gameNAME}`)))
				}
			})
			this.zaipsResult = result

			//do full page reaload
			const result2 = await ajax("/MrBug.json")
			this.model = result2 // Mutating this automatically updates the glizt getter!

			this.mdalready = true
		} catch (error) {
			console.error("Failed to run imgoingin submission:", error)
		}
	}

	@action
	showhideo(index) {
		this.showhideo = this.showhideo.with(index, !this.showhideo[index])
	}

	@action
	showhideo1(index) {
		const item = this.glizt.gamedb1?.[index]
		
		if (item) {
		    item.SHOWHIDEO = !item.SHOWHIDEO
		    this.glizt.gamedb1 = [...this.glizt.gamedb1]
		}
	}

	@action
	showhideo2(index) {
		const item = this.glizt.gamedb2?.[index]
		
		if (item) {
		    item.SHOWHIDEO = !item.SHOWHIDEO
		    this.glizt.gamedb2 = [...this.glizt.gamedb2]
		}
	}

	@action
	showhideo3(index) {
		const item = this.glizt.gamedb3?.[index]
		
		if (item) {
		    item.SHOWHIDEO = !item.SHOWHIDEO
		    this.glizt.gamedb3 = [...this.glizt.gamedb3]
		}
	}

	@action
	zaips2(gameId, event) {
		event.stopPropagation()
		this.zaips("2", gameId)
	}

	@action
	zaips4(gameId, event) {
		event.stopPropagation()
		this.zaips("4", gameId)
	}

}
