import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	model() {
		return ajax('/MrBug.json');
	},
	titleToken() {
		return I18n.t("about.simple_title");
	}
});
