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

    troikopoisk() {
      this.set('bagamdal', true);
      Ember.$.ajax({
        url: '/MrBug/troikopoisk/ebatmiloakka.json',
        type: "GET"
      }).then(result => {
        this.set('troikopoisk', resp);
      });
    }
  }
});
