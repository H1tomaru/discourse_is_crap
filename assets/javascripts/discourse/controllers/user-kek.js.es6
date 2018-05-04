export default Ember.Controller.extend({

	checked1: true,
	checked2: false,
	checked3: false,
	score: 1,
	otziv: null,
	pageFB: Ember.computed('model', 'model.pageNO', function() {
		if this.get('model.FEEDBACKS') { return this.get('model.FEEDBACKS')[this.get('model.pageNO')] }
		else { return null }
 	}),

	bagamdal: false,
	mdalready: false,
	otzivmdal: false,
	otzivsmall: false,
	otzivbig: false,
	
	actions: {
		
		netmudal() {
			this.set('bagamdal', false)
			this.set('mdalready', false)
			this.set('otzivmdal', false)
			this.set('otzivsmall', false)
			this.set('otzivbig', false)
			this.set('otziv', null)
		},

		addOtziv() {
			this.set('bagamdal', true)
			this.set('mdalready', true)
			this.set('otzivmdal', true)
		},

		OtzivZaips() {
			if (this.get('pisanina').length < 20) {
				this.set('otzivsmall', true)
			} else if (this.get('pisanina').length > 200) {
				this.set('otzivbig', true)
			} else {
				this.set('mdalready', false)
				this.set('otzivmdal', false)
				this.set('otzivsmall', false)
				this.set('otzivbig', false)
				this.set('pageFB', null)
				var str = window.location.href.split("/")
				Ember.$.ajax({
					url: "/u/" + encodeURIComponent(str[4]) + "/kek",
					type: "POST",
					data: { "fedbakibaki": btoa(unescape(encodeURIComponent(this.get('score')+"~"+this.get('pisanina')))) }
				}).then(result => {
					this.set('otziv', result)
					Ember.$.ajax({
						url: "/u/" + encodeURIComponent(str[4]) + "/kek.json",
						type: "GET"
					}).then(result => {
						this.set('model', result)
						//this.set('pageFB', this.get('model.FEEDBACKS')[0])
						this.set('mdalready', true)
					})
				})
			}
		},

		selectOtz(input) {
			if ( input == 1 ) {
				this.set('checked1', true)
				this.set('checked2', false)
				this.set('checked3', false)
				this.set('score', 1)
			} else if ( input == 2 ) {
				this.set('checked1', false)
				this.set('checked2', true)
				this.set('checked3', false)
				this.set('score', 2)
			} else if ( input == 3 ) {
				this.set('checked1', false)
				this.set('checked2', false)
				this.set('checked3', true)
				this.set('score', 3)
			} 
		},

		PageChange(value) {
			this.set('model.pageNO', value-1)
		}

	}

})
