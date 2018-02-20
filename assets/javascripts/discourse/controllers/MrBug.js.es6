export default Ember.Controller.extend({
	//default states
	bagoPravila: false,
	bagoGuidaz: false,
	bagoPlati: false,

	bagamdal: false,
	poiskmdal: false,
	
	//encoding function
	jsEncode: function(e) {
		e = e.replace(/\r\n/g, "\n");
		var t = "";
		for (var n = 0; n < e.length; n++) {
			var r = e.charCodeAt(n);
			if (r < 128) {
				t += String.fromCharCode(r)
			} else if (r > 127 && r < 2048) {
				t += String.fromCharCode(r >> 6 | 192);
				t += String.fromCharCode(r & 63 | 128)
			} else {
				t += String.fromCharCode(r >> 12 | 224);
				t += String.fromCharCode(r >> 6 & 63 | 128);
				t += String.fromCharCode(r & 63 | 128)
			}
		}
		return t
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
			this.set('troikopoisk2', this.jsEncode("Hello world!"));
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
