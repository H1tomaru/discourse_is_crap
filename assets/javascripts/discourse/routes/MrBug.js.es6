import { ajax } from 'discourse/lib/ajax';

export default Ember.Route.extend({
	model() {
		return ajax('/MrBug.json');
	},
	activate: function() {
		document.title = "Совместная покупка игр для PS4 на четверых - Union3";
	}
});
