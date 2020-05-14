import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	model() {
		var str = this.modelFor("user").username;
		return ajax('/u/' + encodeURIComponent(str) + '/kek2.json');
	}
});
