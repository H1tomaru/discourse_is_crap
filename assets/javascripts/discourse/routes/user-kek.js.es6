import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	
	model(params) {
		//return ajax(window.location.href+'.json');
		return params;
	}
});
