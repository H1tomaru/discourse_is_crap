export default Ember.Controller.extend({
  bagoPravila: false,
  bagoGuidaz: false,
  bagoPlati: false,

  bagamdal: false,

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
    },

    troikopoisk() {
      Ember.$.ajax({
        url: '/MrBug/troikopoisk/'+troikopoisk2+'.json',
        type: "GET"
      }).then(result => {
        this.set('bagamdal', true);
        this.set('troikopoisk', resp);
      });
    }
  }
});
