export default Ember.Controller.extend({

	otziv: null,

	bagamdal: false,
	mdalready: false,
	otzivmdal: false,

	actions: {

		netmudal() {
			this.set('bagamdal', false);
			this.set('mdalready', false);
			this.set('otzivmdal', false);
			this.set('otziv', null);
		},

		addOtziv() {
			this.set('bagamdal', true);
			this.set('mdalready', true);
			this.set('otzivmdal', true);
		},

		OtzivZaips() {
			this.set('mdalready', false);
			this.set('otzivmdal', false);
			var str = window.location.href.split("/");
			Ember.$.ajax({
				url: "/u/" + str[4] + "/",
				type: "POST",
				data: { "bagatrolit": btoa(this.get('currentUser.username')+"~"+this.get('prezaips._id')+"~"+this.get('prezaips.gameNAME')) }
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

	}

});
