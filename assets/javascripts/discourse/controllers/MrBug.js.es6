export default Ember.Controller.extend({
	//default states
	bagoPravila: false,
	bagoGuidaz: false,
	bagoPlati: false,

	troikopoisk: null,
	prezaips: null,
	zaips: null,

	bagamdal: false,
	mdalready: false,
	poiskmdal: false,
	zaipsmdal: false,

	showhideo: [true, true, true],
	
	himom: "ololo",


	actions: {

		bagoPravila() {
			this.set('bagoGuidaz', false);
			this.set('bagoPlati', false);
			this.toggleProperty('bagoPravila');
		},

		bagoGuidaz() {
			this.set('bagoPravila', false);
			this.set('bagoPlati', false);
			this.toggleProperty('bagoGuidaz');
		},

		bagoPlati() {
			this.set('bagoPravila', false);
			this.set('bagoGuidaz', false);
			this.toggleProperty('bagoPlati');
		},

		netmudal() {
			this.set('bagamdal', false);
			this.set('mdalready', false);
			this.set('poiskmdal', false);
			this.set('zaipsmdal', false);
			this.set('troikopoisk', null);
			this.set('prezaips', null);
			this.set('zaips', null);
		},

		troikopoisk() {
			this.set('bagamdal', true);
			Ember.$.ajax({
				url: "/MrBug/troikopoisk/"+encodeURIComponent(btoa(unescape(encodeURIComponent(this.get('troikopoisk2')))))+".json",
				type: "GET"
			}).then(result => {
				this.set('troikopoisk', result);
				this.set('poiskmdal', true);
				this.set('mdalready', true);
			});
		},

		qzselect(selected) {
			this.set('qzselect', selected);
		},

		qzaips(knopk) {
			if (this.get('qzselect')) {
				this.set('bagamdal', true);
				Ember.$.ajax({
					url: "/MrBug/prezaips/"+encodeURIComponent(btoa(knopk+"~"+this.get('qzselect')))+".json",
					type: "GET"
				}).then(result => {
					this.set('prezaips', result);
					this.set('zaipsmdal', true);
					this.set('mdalready', true);
				});
			}
		},

		zaips(knopk, gcode) {
			this.set('bagamdal', true);
			Ember.$.ajax({
				url: "/MrBug/prezaips/"+encodeURIComponent(btoa(knopk+"~"+gcode))+".json",
				type: "GET"
			}).then(result => {
				this.set('prezaips', result);
				this.set('zaipsmdal', true);
				this.set('mdalready', true);
			});
		},

		imgoingin() {
			this.set('mdalready', false);
			this.set('prezaips.winrars', false);
			Ember.$.ajax({
				url: "/MrBug/zaips/"+encodeURIComponent(btoa(this.get('prezaips.position')+"~"+this.get('currentUser.username')+"~"+this.get('prezaips._id')+"~"+this.get('prezaips.gameNAME')))+".json",
				type: "GET"
			}).then(result => {
				this.set('zaips', result);
				Ember.$.ajax({
					url: "/MrBug.json",
					type: "GET"
				}).then(result => {
					this.set('model', result);
					this.set('zaipsmdal', true);
					this.set('mdalready', true);
				});
			});
		},

		showhideo(index) {
			this.get('showhideo').toggleProperty(index);
		},

		showhideo1(index) {
			//this.get('model.gamedb1').objectAt(index).toggleProperty('SHOWHIDEO');
			this.set('himom', this.get('model.gamedb1').objectAt(0).get('SHOWHIDEO'));
		},
		
		showhideo2(index) {
			this.get('model.gamedb2').objectAt(index).toggleProperty('SHOWHIDEO');
		},

		showhideo3(index) {
			this.get('model.gamedb3').objectAt(index).toggleProperty('SHOWHIDEO');
		}

	}

});
