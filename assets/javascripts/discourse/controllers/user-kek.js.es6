export default Ember.Controller.extend({

	checked1: true,
	checked2: false,
	checked3: false,
	otziv: null,

	bagamdal: false,
	mdalready: false,
	otzivmdal: false,
	otzivsmall: false,

	actions: {

		netmudal() {
			this.set('bagamdal', false);
			this.set('mdalready', false);
			this.set('otzivmdal', false);
			this.set('otzivsmall', false);
			this.set('otziv', null);
		},

		addOtziv() {
			this.set('bagamdal', true);
			this.set('mdalready', true);
			this.set('otzivmdal', true);
		},

		OtzivZaips() {
			if (this.get('otziv').length < 20) {
				this.set('otzivsmall', true);
			} else {
				this.set('mdalready', false);
				this.set('otzivmdal', false);
				this.set('otzivsmall', false);
				var str = window.location.href.split("/");
				Ember.$.ajax({
					url: "/u/" + str[4] + "/",
					type: "POST",
					data: { "bagatrolit": btoa(this.get('currentUser.username')+"~"+this.get('otziv')) }
				}).then(result => {
					this.set('otziv', result);
					Ember.$.ajax({
						url: "/u/" + str[4] + "/kek.json",
						type: "GET"
					}).then(result => {
						this.set('model', result);
						this.set('mdalready', true);
					});
				});
			}
		},		

		selectOtz(input) {
			if ( input == 1 ) {
				this.set('checked1', true);
				this.set('checked2', false);
				this.set('checked3', false);
			} else if ( input == 2 ) {
				this.set('checked1', false);
				this.set('checked2', true);
				this.set('checked3', false);
			} else if ( input == 3 ) {
				this.set('checked1', false);
				this.set('checked2', false);
				this.set('checked3', true);
			} 
		}

	}

});
