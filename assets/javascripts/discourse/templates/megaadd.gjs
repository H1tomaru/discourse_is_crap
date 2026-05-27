import { on } from '@ember/modifier'
import { Input, Textarea } from '@ember/component'

export default <template>
	<form class="MegaAdd" {{on "submit" @controller.oops}}>
	  MegaAdd some Pokemans<br /><br />
	
	  <Input class="poiskbox" type="text" size="64" @value={{@controller.addstuff.GAME}} />
	  <button type="submit">GoGoGo</button>
	  <button type="button" {{on "click" @controller.Reset}}>Reset</button><br />
	  <button type="button" {{on "click" @controller.FeedbacksGo}}>Add Feedback</button>
	  <button type="button" {{on "click" @controller.FeedbacksStop}}>No Feedback</button><br /><br />
	
	  Add Feedback?: {{@controller.addstuff.ADDFB}}<br /><br />
	
	  <Textarea style="width: 100%" rows="20" @value={{@controller.addstuff.STRING}} />
	
	  <br />
	
 		{{#if @controller.addstuff.RESULT.length}}
			Winrars! P244:<br />
			{{#each @controller.addstuff.RESULT as |game|}}
				{{game.GAME}} {{game._id}} {{game.P2.[0]}} {{game.P4.[0]}} {{game.P4.[1]}}<br />
			{{/each}}
		{{/if}}
	
	  <br />
	
	  MegaAdd List some Pokemans<br />
	
	  <button type="button" {{on "click" @controller.showP4Lista}}>P4 lista:</button><br />
	
		{{#each @controller.p4lista as |game|}}
				{{#each game.TROIKI as |troika index|}}

					{{#if troika.ACCOUNT.length}}
						{{#unless index}}
							<br /><br /><br />{{game.gameNAME}}<br />
						{{/unless}}
						<br />
						{{troika.ACCOUNT}}<br />
						П2 - {{troika.USERS.[0]}}<br />
						П4 - {{troika.USERS.[1]}}<br />
						П4 - {{troika.USERS.[2]}}<br />
					{{/if}}

				{{/each}}
		{{/each}}

	</form>
</template>
