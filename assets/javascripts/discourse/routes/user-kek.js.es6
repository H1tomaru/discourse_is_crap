import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	
	model() {
		var str = window.location.href;
		return ajax(str.substring(0, str.lastIndexOf("/")) + '/kek.json');
	}
});
