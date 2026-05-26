import Route from '@ember/routing/route'
import { ajax } from 'discourse/lib/ajax'

export default class MrBugRoute extends Route {
	model() {
		return ajax('/MrBug.json')
	}
}
