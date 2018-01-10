export default Discourse.Route.extend({

  model: function(params) { return params },

  setupController: function(controller, params) {
    ajax(`/mrbug.json`).then(function(data) {
      controller.setProperties({ model:data })
      DiscourseURL.replaceState(`/mrbug`)
    })
  }
})
