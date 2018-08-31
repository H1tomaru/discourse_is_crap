import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	model() {
		return ajax('/MrBugP4.json');
	}
});
