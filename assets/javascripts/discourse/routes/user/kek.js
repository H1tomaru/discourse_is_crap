/*
import Route from '@ember/routing/route'
import { ajax } from 'discourse/lib/ajax'

export default class UserKekRoute extends Route {
	model() {
		const str = this.modelFor('user').username
		
		// Modern backticks (``) let you drop the + plus signs and concatenate strings cleanly
		return ajax(`/u/${encodeURIComponent(str)}/kek.json`)
	}
}
*/

import Route from '@ember/routing/route'
import { ajax } from 'discourse/lib/ajax'

export default class UserKekRoute extends Route {
  model() {
    // 1. Get the parent user model safely
    const user = this.modelFor('user')

    // Safety Check: If parent user model failed to load, stop here to prevent crash
    if (!user || !user.username) {
      console.error("❌ UserKekRoute: Could not find parent 'user' model!", user)
      return { error: "Parent user not found" }
    }

    console.log("✅ UserKekRoute: Found user:", user.username)

    // 2. Construct the URL
    const url = `/u/${encodeURIComponent(user.username)}/kek.json`
    console.log("🔄 UserKekRoute: Fetching:", url)

    // 3. Return the AJAX promise (Ember will wait for this to finish)
    return ajax(url)
      .then((result) => {
        console.log("✅ UserKekRoute: Loaded Data:", result)
        return result
      })
      .catch((error) => {
        console.error("❌ UserKekRoute: AJAX Failed:", error)
        return { error: "Failed to load data", details: error }
      })
  }

  setupController(controller, model) {
    // 4. Manually force the data into the controller just in case
    super.setupController(controller, model)
    console.log("📥 UserKekRoute: Setting controller model to:", model)
    controller.set('model', model)
  }
}
