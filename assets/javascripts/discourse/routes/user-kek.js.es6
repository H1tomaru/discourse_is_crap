import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	
	model() {
		//return ajax(window.location.href+'.json');
		//return JSON.stringify(params);
	}
});
