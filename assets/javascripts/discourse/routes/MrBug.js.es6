import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	model() {
		return ajax('/MrBug.json');
	},
	titleToken() {
		model.title = 'TestTestTest';
		return model.title;
	}
});
