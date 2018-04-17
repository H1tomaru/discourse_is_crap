import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

	model() {
		var str = window.location.href;
		str = str.substring(0, str.lastIndexOf("/"));
		var count = str.length - str.replace("/", "").length;
		if ( count > 4 ) str = str.substring(0, str.lastIndexOf("/"));
		//return ajax(str + '/kek.json');
		return {
			STR: window.location.href,
			COUNT: count,
			AFTER: window.location.href.replace("/", "")
		}
	}

});
