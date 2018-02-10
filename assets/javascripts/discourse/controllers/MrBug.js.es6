export default Ember.Controller.extend({
  bagoPravila: false,
  bagoGuidaz: false,
  bagoPlati: false,
  
  troikopoisk: '',
  troikopoiskresult: false,

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
      Ember.$.ajax({
        url: '/MrBug/troikopoisk/ebatmiloakka.json',
        type: "GET"

      }).then(result => {
        this.set('troikopoisk', true);
        this.set('troikopoiskresult', resp);
      });
    }
  }
});
