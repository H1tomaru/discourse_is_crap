import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	model() {
		return ajax('/MrBug.json');
	},
	titleToken: function() {
		var model = this.modelFor('MrBug');
		if (model) {
			return "TestTestTest";
		}
	}
});
