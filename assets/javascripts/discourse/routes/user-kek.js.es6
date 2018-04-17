import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

	model() {
		var str = window.location.href.split("/");
		return ajax('/u/' + str[4] + '/kek.json');
	}

});
