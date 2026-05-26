import Route from '@ember/routing/route'
import { ajax } from 'discourse/lib/ajax'

export default class RentaGameRoute extends Route {
	model() {
		return ajax('/renta-haleguu.json')
	}
}
