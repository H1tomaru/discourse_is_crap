import { on } from '@ember/modifier'
import { each, unless, get } from '@ember/helper'
import Input from '@ember/component/input'
import Textarea from '@ember/component/textarea'

export default <template>
	<form class="MegaAdd" {{on "submit" @controller.oops}}>
	  MegaAdd some Pokemans<br /><br />
	
	  <Input class="poiskbox" type="text" size="64" @value={{@controller.addstuff.GAME}} />
	  <button type="submit">GoGoGo</button>
	  <button type="button" {{on "click" @controller.reset}}>Reset</button><br />
	  <button type="button" {{on "click" @controller.feedbacksGo}}>Add Feedback</button>
	  <button type="button" {{on "click" @controller.feedbacksStop}}>No Feedback</button><br /><br />
	
	  Add Feedback?: {{@controller.addstuff.ADDFB}}<br /><br />
	
	  <Textarea style="width: 100%" rows="20" @value={{@controller.addstuff.STRING}} />
	
	  <br />
	
	  Winrars! P244:<br />
	  {{#each @controller.addstuff.RESULT as |game|}}
		{{game.GAME}}
		{{game._id}}
		{{get game.P2 0}}
		{{get game.P4 0}}
		{{get game.P4 1}}<br />
	  {{/each}}
	
	  <br />
	
	  MegaAdd List some Pokemans<br />
	
	  <button type="button" {{on "click" @controller.p4Lista}}>P4 lista:</button><br />
	
	  {{#if @controller.p4lista}}
		{{#each @controller.p4lista as |game|}}
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
