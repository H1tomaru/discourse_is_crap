export default Ember.Controller.extend({
	//default states
	bagoPravila: false,
	bagoGuidaz: false,
	bagoPlati: false,

	troikopoisk: null,
	qzselect: null,
	prezaips: null,

	bagamdal: false,
	mdalready: false,
	poiskmdal: false,
	zaipsmdal: false,

	
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
		},

		troikopoisk() {
			this.set('bagamdal', true);
			Ember.$.ajax({
				url: "/MrBug/troikopoisk/"+btoa(decodeURI(encodeURI(this.get('troikopoisk2'))))+".json",
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
		
		qzaips(value) {
			if (qzselect) {
				this.set('bagamdal', true);
				Ember.$.ajax({
					url: "/MrBug/prezaips/"+btoa(decodeURI(encodeURI(value+qzselect)))+".json",
					type: "GET"
				}).then(result => {
					this.set('prezaips', result);
					this.set('zaipsmdal', true);
					this.set('mdalready', true);
				});
			}
		}

	}

});
