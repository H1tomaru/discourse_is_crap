export default Ember.Controller.extend({

	loadPlugin: function() {
		Ember.run.scheduleOnce('afterRender', this, function() {
		Ember.$.getScript('https://www.gstatic.com/charts/loader.js');
	});
	}.on('init')

});
