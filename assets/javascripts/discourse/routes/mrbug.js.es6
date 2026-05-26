import Route from '@ember/routing/route'
import { ajax } from 'discourse/lib/ajax'

export default class extends Route {
	model() {
		return ajax('/MrBug.json')
	}
}
