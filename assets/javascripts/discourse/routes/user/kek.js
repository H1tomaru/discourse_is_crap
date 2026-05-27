import Route from '@ember/routing/route'
import { ajax } from 'discourse/lib/ajax'

export default class UserKekRoute extends Route {
	model() {
		const str = this.modelFor('user').username
		
		// Modern backticks (``) let you drop the + plus signs and concatenate strings cleanly
		return ajax(`/u/${encodeURIComponent(str)}/kek.json`)
	}
}
