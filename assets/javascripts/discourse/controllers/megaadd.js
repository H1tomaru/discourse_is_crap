import Controller from '@ember/controller'
import { action } from '@ember/object'
import { tracked } from '@glimmer/tracking'
import { on } from "@ember/modifier"
import { Input, Textarea } from "@ember/component"

export default class MyController extends Controller {

	@tracked addstuff = {
		GAME: null,
		STRING: null,
		ADDFB: false
	}
	
	@tracked p4lista = null

	@action
		async oops(event) {
		event?.preventDefault();
		try {
			const response = await fetch("/admin/MegaAdd/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({
					GAME: this.addstuff.GAME,
					STRING: this.addstuff.STRING,
					ADDFB: this.addstuff.ADDFB
				})
			})
			const result = await response.json()
			this.addstuff = result
			//ember doesnt update on 2nd level variables, so use this shit
			this.addstuff = { ...this.addstuff, ADDFB: false }
		} catch (error) {
			console.error("MegaAdd failed:", error)
		}
	}
	
	@action
	Reset() {
		// Resetting the whole object container cleanly
		this.addstuff = { GAME: null, STRING: null, ADDFB: false }
	}
	
	@action
	FeedbacksGo() {
		// Fix: Reassigning the object container so Ember notices the sub-property change
		this.addstuff = { ...this.addstuff, ADDFB: true }
	}
	
	@action
	FeedbacksStop() {
		// Fix: Same thing here to keep Ember's tracker happy
		this.addstuff = { ...this.addstuff, ADDFB: false }
	}
	
	@action
	async P4Lista() {
		try {
			const response = await fetch('/MrBug.json')
			const result = await response.json()
			
			this.p4lista = result.gamelist
		} catch (error) {
			console.error("Failed to load P4Lista:", error)
		}
	}

  <template>
    <form class="MegaAdd" {{on "submit" this.oops}}>
      MegaAdd some Pokemans<br /><br />

      <Input class="poiskbox" type="text" size="64" @value={{this.addstuff.GAME}} />
      <button type="submit">GoGoGo</button>
      <button type="button" {{on "click" this.reset}}>Reset</button><br />
      <button type="button" {{on "click" this.feedbacksGo}}>Add Feedback</button>
      <button type="button" {{on "click" this.feedbacksStop}}>No Feedback</button><br /><br />

      Add Feedback?: {{this.addstuff.ADDFB}}<br /><br />

      <Textarea style="width: 100%" rows="20" @value={{this.addstuff.STRING}} />

      <br />

      Winrars! P244:<br />
      {{#each this.addstuff.RESULT as |game|}}
        {{game.GAME}}
        {{game._id}}
        {{get game.P2 0}}
        {{get game.P4 0}}
        {{get game.P4 1}}<br />
      {{/each}}

      <br />

      MegaAdd List some Pokemans<br />

      <button type="button" {{on "click" this.p4Lista}}>P4 lista:</button><br />

      {{#if this.p4lista}}
        {{#each this.p4lista as |game|}}
          {{#each game.TROIKI as |troika index|}}
            {{#if troika.ACCOUNT}}
              {{#unless index}}
                <br /><br /><br />{{game.gameNAME}}<br />
              {{/unless}}
              <br />
              {{troika.ACCOUNT}}<br />
              П2 - {{get troika.USERS 0}}<br />
              П4 - {{get troika.USERS 1}}<br />
              П4 - {{get troika.USERS 2}}<br />
            {{/if}}
          {{/each}}
        {{/each}}
      {{/if}}
    </form>
  </template>
}
