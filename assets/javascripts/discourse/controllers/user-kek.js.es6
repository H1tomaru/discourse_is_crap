export default Ember.Controller.extend({

	checked1: true,
	checked2: false,
	checked3: false,
	score: 1,
	ozmode: 666,
	responz: null,
	tempadd: true,

	thisPA: 1,
	pagesNO: Ember.computed('model.FEEDBACKS', function() {
		if (this.get('model.FEEDBACKS')) return this.get('model.FEEDBACKS').length
	}),
	pageFB: Ember.computed('model.FEEDBACKS', function() {
		if (this.get('model.FEEDBACKS')) return this.get('model.FEEDBACKS')[0]
 	}),

	otzivmdal: false,
	otzivsmall: false,
	otzivbig: false,
	
	cum2m: Ember.computed('model.FEEDBACKS', function() {
		if (this.get('pagesNO') > 1) return true
	}),
	
	showfbARC: Ember.computed('model.FEEDBACKS', function() {
		if (this.get('pagesNO') <= 1 && this.get('model.fbARC') > 0) return true
	}) ,
	
	actions: {
		
		addOtziv() {
			this.set('null', null)
			this.set('tempadd', true)
			this.set('otzivmdal', true)
			this.set('ozmode', 666)
			this.set('pisanina', null)
		},

		editOtziv(fb) {
			this.set('null', null)
			this.set('tempadd', false)
			this.set('otzivmdal', true)
			this.set('ozmode', 1337)
			this.set('pisanina', fb)
		},
		
		respCLOZ() {
			this.set('responz', null)
		},

		smtexCLOZ() {
			this.set('otzivsmall', false)
			this.set('otzivbig', false)
		},
		
		showMORZ() {
			this.get('pageFB').pushObjects(this.get('model.FEEDBACKS')[this.get('thisPA')])
			this.set('thisPA', this.get('thisPA') + 1)
			if (this.get('thisPA') == this.get('pagesNO')) this.set('cum2m', false)
			if (this.get('cum2m') == false && this.get('model.fbARC') > 0) this.set('showfbARC', true)			
		},

		OtzivZaips() {
			if (this.get('pisanina').length < 20) {
				this.set('otzivsmall', true)
			} else if (this.get('pisanina').length > 200) {
				this.set('otzivbig', true)
			} else {
				this.set('otzivmdal', false)
				this.set('otzivsmall', false)
				this.set('otzivbig', false)
				Ember.$.ajax({
					url: "/posos/",	type: "POST",
					data: { "pNAME": this.get('currentUser.username') }
				}).then(result => {
					Ember.$.ajax({
						url: "/u/" + this.get('model.uZar') + "/kek",
						type: "POST",
						data: { "fedbakibaki": btoa(unescape(encodeURIComponent(this.get('ozmode')+"~"+this.get('score')+"~"+this.get('pisanina')))) }
					}).then(result => {
						this.set('responz', result)
						if ( result.winrars == true ) {
							if (this.get('ozmode') == 666) {
								if ( this.get('score') > 0 ) { this.set('score', 'zeG')
									Ember.set(this.get('model'), 'fbG', this.get('model.fbG') + 1) }
								if ( this.get('score') == 0 ) { this.set('score', 'zeN')
									Ember.set(this.get('model'), 'fbN', this.get('model.fbN') + 1) }
								if ( this.get('score') < 0 ) { this.set('score', 'zeB')
									Ember.set(this.get('model'), 'fbB', this.get('model.fbB') + 1) }
								var ni = this.get('pageFB').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
								Ember.set(this.get('pageFB').objectAt(ni),'eDit',false)
								var newpageFB = this.get('pageFB').unshiftObject({
									pNAME: this.get('currentUser.username'),
									FEEDBACK: this.get('pisanina'),
									DATE: new SimpleDateFormat("yyyy.MM.dd"),
									COLOR: this.get('score'),
									eDit: true
								})
								this.set('pageFB', newpageFB)
							} else {
								var ni = this.get('pageFB').map(function(it) { return it.pNAME }).indexOf(this.get('currentUser.username'))
								Ember.set(this.get('pageFB').objectAt(ni),'FEEDBACK',this.get('pisanina'))
								if ( this.get('score') > 0 ) Ember.set(this.get('pageFB').objectAt(ni),'COLOR','zeG')
								if ( this.get('score') == 0 ) Ember.set(this.get('pageFB').objectAt(ni),'COLOR','zeN')
								if ( this.get('score') < 0 ) Ember.set(this.get('pageFB').objectAt(ni),'COLOR','zeB')
							}
							this.set('checked1', true)
							this.set('checked2', false)
							this.set('checked3', false)
							this.set('score', 1)
							this.set('pisanina', null)
						}
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
				this.set('score', 0)
			} else if ( input == 3 ) {
				this.set('checked1', false)
				this.set('checked2', false)
				this.set('checked3', true)
				this.set('score', -1)
			} 
		}

	}

})
