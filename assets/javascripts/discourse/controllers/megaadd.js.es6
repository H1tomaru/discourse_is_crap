import Ember from 'ember';

export default Ember.Controller.extend({

	addstuff: {"GAME": null,
		  "STRING": null,
		  "ADDFB": false},

	p4lista: null,

	actions: {

		oops() {
			return fetch("/admin/MegaAdd/", {
				method: 'POST',
				body: {
					GAME: this.get('addstuff.GAME'),
					STRING: this.get('addstuff.STRING'),
					ADDFB: this.get('addstuff.ADDFB')
				}
			}).then(result => {
				this.set('addstuff', result)
				this.set('addstuff.ADDFB', false)
			})
		},

		Reset() {
			this.set('addstuff', { "GAME": null, "STRING": null, "ADDFB": false })
		},

		FeedbacksGo() {
			this.set('addstuff.ADDFB', true)
			this.set('addstuff.ADDFB', p4lista)
		},

		FeedbacksStop() {
			this.set('addstuff.ADDFB', false)
			this.set('p4lista', [{"_id":"playstationplus","imgLINK":"https://i.imgur.com/08232oO.png","gameNAME":"PlayStation Plus 1 Год","STORE":"IN","CONSOLE":"PS4","DATE":"2000.00.00","PRICE":5500,"TYPE":1,"TTYPE":[true,false,false],"PPOSITIONS":[2,4,4,4,4,0],"PDOWN1":0,"PDOWN2":0,"PDOWN3":0,"P4PRICE1":0,"P4PRICE3":1390,"P4PRICE2":790,"PPRICES":[790,1390,1390,1390,1390,0],"TROIKI":[{"USERS":["VeNoM","","","Sheesh","giperion",""],"FEEDBACK":[{"GOOD":3,"BAD":0,"NEUTRAL":0,"PERCENT":100},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0},{"GOOD":21,"BAD":0,"NEUTRAL":0,"PERCENT":100},{"GOOD":7,"BAD":0,"NEUTRAL":0,"PERCENT":100},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0}],"NOP1ADD":0,"ACCOUNT":"","PTAKEN":[false,false,false,false,false,false],"PFBred":[false,true,true,false,false,true],"PSTATUS":[[true,false,false,false],[false,false,false,false],[false,false,false,false],[true,false,false,false],[true,false,false,false],[false,false,false,false]]},{"USERS":["","","","Dmitriy1","",""],"FEEDBACK":[{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0},{"GOOD":1,"BAD":0,"NEUTRAL":0,"PERCENT":100},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0},{"GOOD":0,"BAD":0,"NEUTRAL":0,"PERCENT":0}],"NOP1ADD":0,"ACCOUNT":"","PTAKEN":[false,false,false,false,false,false],"PFBred":[true,true,true,false,true,true],"PSTATUS":[[false,false,false,false],[false,false,false,false],[false,false,false,false],[true,false,false,false],[false,false,false,false],[false,false,false,false]]}],"P1NO":1,"P2NO":0,"P3NO":1.5,"P4NO":0}])               
		},

		P4Lista() {
			return fetch('/MrBug.json').then(result => {
				this.set('p4lista', result.gamelist)
			})
		}

	}

})
