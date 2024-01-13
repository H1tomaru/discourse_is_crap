import { ajax } from 'discourse/lib/ajax';
import Ember from 'ember';

export default Ember.Route.extend({
	model() {
		return ajax('/MrBug.json')
	}
});
