export default Ember.Controller.extend({

	rulez: false,

	actions: {

		showRULEZ() {
			this.toggleProperty('rulez')
		}

	}

})
