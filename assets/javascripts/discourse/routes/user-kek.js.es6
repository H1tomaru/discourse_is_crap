import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({

	model() {
		params[:title] = 'TestTest';
		var str = this.modelFor("user").username;
		return ajax('/u/' + encodeURIComponent(str) + '/kek.json');
	}

});
