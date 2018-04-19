import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

	model() {
		var usermodel = this.modelFor("user");
		var str = usermodel.params.username;
		//var str = window.location.href.split("/");
		//return ajax('/u/' + str[4] + '/kek.json');
		return ajax('/u/' + str + '/kek.json');
	}

});
