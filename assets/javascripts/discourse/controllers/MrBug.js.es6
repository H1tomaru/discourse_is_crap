export default Ember.Controller.extend({
	//default states
	bagoPravila: false,
	bagoGuidaz: false,
	bagoPlati: false,

	bagamdal: false,
	poiskmdal: false,
	
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
			this.set('poiskmdal', false);
			this.set('troikopoisk', '');
		},

		troikopoisk() {
			this.set('bagamdal', true);
			this.set('poiskmdal', true);
			Ember.$.ajax({
				url: "/MrBug/troikopoisk/"+btoa(this.get('troikopoisk2'))+".json",
				type: "GET"
			}).then(result => {
				this.set('troikopoisk', result);
			});
		}

	}

});
