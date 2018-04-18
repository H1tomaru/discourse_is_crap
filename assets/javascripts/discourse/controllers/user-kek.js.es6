export default Ember.Controller.extend({

	otziv: null,

	bagamdal: false,
	mdalready: false,

	actions: {

		netmudal() {
			this.set('bagamdal', false);
			this.set('mdalready', false);
			this.set('otziv', null);
		}

	}

});
