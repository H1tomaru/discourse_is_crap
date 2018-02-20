export default Ember.Controller.extend({
	//default states
	bagoPravila: false,
	bagoGuidaz: false,
	bagoPlati: false,

	bagamdal: false,
	poiskmdal: false,
	
	//encoding function
	jsEncode: function (s, k) {
		var enc = "";
		var str = "";
		// make sure that input is string
		str = s.toString();
		for (var i = 0; i < s.length; i++) {
			// create block
			var a = s.charCodeAt(i);
			// bitwise XOR
			var b = a ^ k;
			enc = enc + String.fromCharCode(b);
		}
		return enc;
	}
  

	actions: {

		bagoPravila() {
			this.set('bagoGuidaz', false);
			this.set('bagoPlati', false);
			this.set('bagoPravila', true);
		},

		bagoGuidaz() {
			this.set('bagoPravila', false);
			this.set('bagoPlati', false);
			this.set('bagoGuidaz', true);
		},

		bagoPlati() {
			this.set('bagoPravila', false);
			this.set('bagoGuidaz', false);
			this.set('bagoPlati', true);
		},

		netmudal() {
			this.set('bagamdal', false);
			this.set('poiskmdal', false);
		},

		troikopoisk() {
			this.set('troikopoisk2', this.jsEncode("Hello world!","123"));
			this.set('bagamdal', true);
			this.set('poiskmdal', true);
			Ember.$.ajax({
				url: '/MrBug/troikopoisk/baka.json',
				type: "GET"
			}).then(result => {
				this.set('troikopoisk', result);
			});
		}

	}

});
