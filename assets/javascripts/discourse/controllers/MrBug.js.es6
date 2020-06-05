export default Ember.Controller.extend({
	//default states
	bagamdal: false,
	mdalready: false,
	troikopoisk: null,
	prezaips: null,
	zaips: null,

	showhideo: [true, true, true],


	actions: {

		netmudal() {
			this.set('bagamdal', false)
			this.set('mdalready', false)
			this.set('troikopoisk', null)
			this.set('prezaips', null)
			this.set('zaips', null)
		},

		troikopoisk() {
			this.set('bagamdal', true)
			Ember.$.ajax({
				url: "/MrBug/troikopoisk/",
				type: "POST",
				data: { "input": btoa(unescape(encodeURIComponent(this.get('troikopoisk2')))) }
			}).then(result => {
				this.set('troikopoisk', result)
				this.set('mdalready', true)
			})
		},

		qzselect(selected) {
			this.set('qzselect', selected)
		},

		qzaips(knopk) {
			if (this.get('qzselect')) {
				this.set('bagamdal', true)
				Ember.$.ajax({
					url: "/posos/",	type: "POST",
					data: { "pNAME": this.get('currentUser.username') }
				}).then(result => {
					Ember.$.ajax({
						url: "/MrBug/prezaips/",
						type: "POST",
						data: { "bagakruta": btoa(knopk+"~"+this.get('qzselect')) }
					}).then(result => {
						this.set('prezaips', result)
						this.set('mdalready', true)
					})
				})
			}
		},

		zaips(knopk, gcode) {
			this.set('bagamdal', true)
			Ember.$.ajax({
				url: "/posos/",	type: "POST",
				data: { "pNAME": this.get('currentUser.username') }
			}).then(result => {
				Ember.$.ajax({
					url: "/MrBug/prezaips/",
					type: "POST",
					data: { "bagakruta": btoa(knopk+"~"+gcode) }
				}).then(result => {
					this.set('prezaips', result)
					this.set('mdalready', true)
				})
			})
		},

		imgoingin() {
			this.set('mdalready', false)
			this.set('prezaips.winrars', false)
			Ember.$.ajax({
				url: "/MrBug/zaips/",
				type: "POST",
				data: { "bagatrolit": btoa(unescape(encodeURIComponent(this.get('prezaips.position')+"~"+this.get('currentUser.username')+"~"+this.get('prezaips._id')+"~"+this.get('prezaips.gameNAME')))) }
			}).then(result => {
				this.set('zaips', result)
				Ember.$.ajax({
					url: "/MrBug.json",
					type: "GET"
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
			Ember.set(this.get('model.gamedb1')[index],'SHOWHIDEO',!this.get('model.gamedb1')[index].SHOWHIDEO)
		},
		
		showhideo2(index) {
			Ember.set(this.get('model.gamedb2')[index],'SHOWHIDEO',!this.get('model.gamedb2')[index].SHOWHIDEO)
		},

		showhideo3(index) {
			Ember.set(this.get('model.gamedb3')[index],'SHOWHIDEO',!this.get('model.gamedb3')[index].SHOWHIDEO)
		}

	}

})
