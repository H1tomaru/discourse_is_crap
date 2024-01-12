import { ajax } from 'discourse/lib/ajax';
import Ember from 'ember';

export default Ember.Route.extend({
	model() {
		var str = this.modelFor("user").username;
		return ajax('/u/' + encodeURIComponent(str) + '/kek.json');
	}
});
