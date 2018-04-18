export default Ember.Controller.extend({

	otziv: null,

	bagamdal: false,
	mdalready: false,

	actions: {

		netmudal() {
			this.set('bagamdal', false);
			this.set('mdalready', false);
			this.set('otziv', null);
		},
		
		addOtziv() {
			this.set('bagamdal', true);
			this.set('mdalready', true);
			this.set('otziv.prezaips', true);
		},

	}

});
