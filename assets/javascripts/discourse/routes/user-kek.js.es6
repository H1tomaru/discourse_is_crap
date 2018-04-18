import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

	model(params) {
		//var str = window.location.href.split("/");
		var str = params.username;
		return ajax('/u/' + str + '/kek.json');
	}

});
