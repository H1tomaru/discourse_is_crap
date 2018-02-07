export default Ember.Controller.extend({
  bagoPravila: false,
  bagoGuidaz: false,
  bagoPlati: false,

  actions: {
    showTentacle() {
      this.set('tentacleVisible', true);
    }
  }
});
