export default Ember.Controller.extend({
  bagoPravila: false,
  bagoGuidaz: false,
  bagoPlati: false,

  bagamdal: false,
  poiskmdal: false,
  

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
      this.set('bagamdal', true);
      this.set('poiskmdal', true);
      this.Ember.$.ajax({
        url: '/MrBug/troikopoisk/suka.json',
        type: "GET"
      }).then(result => {
        this.set('troikopoisk', result);
      });
    }
  }
});
