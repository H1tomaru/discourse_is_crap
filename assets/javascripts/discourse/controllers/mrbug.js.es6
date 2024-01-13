import Ember from 'ember';
import $ from 'jquery';

export default Ember.Controller.extend({
	//default states
	bagamdal: false,
	mdalready: false,
	prezaips: null,
	pzposition: null,
	zaips: null,

	showhideo: [true, true, true],
	
	glizt: Ember.computed('model.gamelist', function() {
		//make variables for each game type
		var finalvar = {gamedb1: [], gamedb2: [], gamedb3: [], maigamez1: [], maigamez2: []}

		this.get('model.gamelist').forEach((item, index) => {
			item.MODE1 = false; item.MODE2 = false

			//if not guest, check if user is in this troika
			var currentuser = this.get('currentUser.username')
			if (currentuser) {
				//template shit for type 2 and 3 games displaying type 2 and 3 stuff
				var gTYPE2 = false; var gTYPE3 = false
				if (item.TYPE == 2) gTYPE2 = true
				if (item.TYPE == 3) gTYPE3 = true

				//loop thorought troikas and see if current user is in it
				item.TROIKI.forEach((troika, index) => {
					troika.MODE1 = false; troika.MODE2 = false

					//calculate if user is in this troika, if he is, add user + gname to list, also gamechangecolor = true, troika change color = true
					for (let i = 0; i < 6; i++) {
						if (currentuser == troika['USERS'][i]) {
							if (troika['PSTATUS'][i][0] == true) {
								item.MODE1 = true; troika.MODE1 = true; item.MODE2 = false; troika.MODE2 = false
								finalvar.maigamez1.push( {
									POSITION: item['PPOSITIONS'][i], gNAME: item.gameNAME, gPIC: item.imgLINK, PRICE: item['PPRICES'][i],
									P1ADD: troika.NOP1ADD, DATE: item.DATE, TYPE2: gTYPE2, TYPE3: gTYPE3
								} )
							} else {
								if (item.MODE1 == false) item.MODE2 = true
								if (troika.MODE1 == false) troika.MODE2 = true
								finalvar.maigamez2.push( { POSITION: item['PPOSITIONS'][i], gNAME: item.gameNAME, gPIC: item.imgLINK } )
							}
						}
					} 
				})
			}

			//fill 3 variables for each game type
			if (item.TYPE == 1) finalvar.gamedb1.push(item)
			if (item.TYPE == 2) finalvar.gamedb2.push(item)
			if (item.TYPE == 3) finalvar.gamedb3.push(item)
		})

		return finalvar
	}),


	actions: {

		netmudal() {
			this.set('bagamdal', false)
			this.set('mdalready', false)
			this.set('troikopoisk', null)
			this.set('prezaips', null)
			this.set('zaips', null)
		},

		zaips(knopk, gcode) {
			this.set('bagamdal', true)
			$.post("/MrBug/prezaips/", { 
				bagakruta: btoa(knopk+"~"+gcode)
			}).then(result => {
				this.set('prezaips', result)
				if (result.hasOwnProperty('position')) this.set('pzposition', result['position'][0])
				this.set('mdalready', true)
			})
		},

		imgoingin() {
			this.set('mdalready', false)
			this.set('prezaips.winrars', false)
			$.post("/MrBug/zaips/", { 
				bagatrolit: btoa(unescape(encodeURIComponent(this.get('prezaips.position')+"~"+this.get('currentUser.username')+"~"+this.get('prezaips._id')+"~"+this.get('prezaips.gameNAME'))))
			}).then(result => {
				this.set('zaips', result)
				return fetch('/MrBug.json').then(function(response) {
					return response.json();
				}).then(result => {
					this.set('model', result)
					this.set('mdalready', true)
				})
			})
		},

		showhideo(index) {
			this.get('showhideo').toggleProperty(index)
		},

		showhideo1(index) {
			Ember.set(this.get('glizt.gamedb1')[index],'SHOWHIDEO',!this.get('glizt.gamedb1')[index].SHOWHIDEO)
		},
		
		showhideo2(index) {
			Ember.set(this.get('glizt.gamedb2')[index],'SHOWHIDEO',!this.get('glizt.gamedb2')[index].SHOWHIDEO)
		},

		showhideo3(index) {
			Ember.set(this.get('glizt.gamedb3')[index],'SHOWHIDEO',!this.get('glizt.gamedb3')[index].SHOWHIDEO)
		}

	}

})
