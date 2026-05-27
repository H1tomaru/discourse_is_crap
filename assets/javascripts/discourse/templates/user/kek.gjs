import { on } from '@ember/modifier'
import { fn } from '@ember/helper'
import { Input } from '@ember/component'

export default <template>
	<div class="kekbakaz"><br />
	
	  {{#if this.otzivmdal}}
		<form {{on "submit" this.OtzivZaips}}>
		  <div>
			<button
			  type="button"
			  class={{if this.checked1 "bi4"}}
			  {{on "click" (fn this.selectOtz 1)}}
			>
			  <img src="https://i.imgur.com/rmydNkF.png" />
			</button>
			<button
			  type="button"
			  class={{if this.checked2 "bi4"}}
			  {{on "click" (fn this.selectOtz 2)}}
			>
			  <img src="https://i.imgur.com/OMygNKW.png" />
			</button>
			<button
			  type="button"
			  class={{if this.checked3 "bi4"}}
			  {{on "click" (fn this.selectOtz 3)}}
			>
			  <img src="https://i.imgur.com/ZcxqN8c.png" />
			</button>
		  </div>
	
		  <div
			class="{{if this.checked1 'bi4G'}}{{if this.checked2 'bi4N'}}{{if this.checked3 'bi4B'}}"
		  >
			<Input
			  minlength="20"
			  maxlength="200"
			  type="text"
			  @value={{this.pisanina}}
			/>
		  </div>
	
		  <button type="submit">
			{{if this.ozmode "Добавить" "Изменить"}}
			Отзыв
		  </button>
		</form>
	
		{{#if this.otzivsmall}}
		  <div class="netmudal">
			Отзыв Слишком Короткий!
			<button type="button" {{on "click" this.respCLOZ}}></button>
		  </div>
		{{/if}}
	
		{{#if this.otzivbig}}
		  <div class="netmudal">
			Отзыв Слишком Длинный!
			<button type="button" {{on "click" this.respCLOZ}}></button>
		  </div>
		{{/if}}
	  {{/if}}
	
	  {{#if this.responz.winrars_z}}
		<div class="netmudal">
		  Отзыв Успешно Записан!
		  <button type="button" {{on "click" this.respCLOZ}}></button>
		</div>
	  {{/if}}
	
	  {{#if this.responz.winrars_e}}
		<div class="netmudal">
		  Отзыв Успешно Изменен!
		  <button type="button" {{on "click" this.respCLOZ}}></button>
		</div>
	  {{/if}}
	
	  {{#if this.responz.gavas_z}}
		<div class="netmudal">
		  Вы Уже Оставляли Отзыв, Попробуйте Завтра
		  <button type="button" {{on "click" this.respCLOZ}}></button>
		</div>
	  {{/if}}
	
	  {{#if this.responz.gavas_e}}
		<div class="netmudal">
		  Вы Уже Изменяли Отзыв, Попробуйте Завтра
		  <button type="button" {{on "click" this.respCLOZ}}></button>
		</div>
	  {{/if}}
	
	  {{#if this.responz.bakas}}
		<div class="netmudal">
		  Вы не можете оставлять отзывы имея отрицательный отзыв<br />
		  Обратитетсь к <a href="/u/MrBug">Организатору</a> чтобы исправить отзыв
		  <button type="button" {{on "click" this.respCLOZ}}></button>
		</div>
	  {{/if}}
	
	  {{#if this.responz.fail}}
		<div style="background-image:url('https://i.imgur.com/33FJekg.png'); width: 100%; height: 800px;">
		  Epic Fail Is Epic
		</div>
	  {{/if}}
	
	  <div class="kekkok">
		<h2>Отзывы</h2>
		<div class="xdux">
		  <span style="color: #27ae60">{{this.model.fbG}}</span>
		  /
		  <span style="color: gray">{{this.model.fbN}}</span>
		  /
		  <span style="color: lightcoral">{{this.model.fbB}}</span>
		</div>
	
		<div class="keklist">
		  {{#if this.model.MENOSHO}}
			<div class="kekus">
			  <button class="addZ" type="button" {{on "click" this.addOtziv}}>
				Оставить отзыв
			  </button>
			</div>
		  {{/if}}
	
		  {{#each this.fEEDBACKS.fb1 as |feedback|}}
			<div class="kekus {{feedback.COLOR}}">
			  <div><a href="/u/{{feedback.pNAME}}">{{feedback.pNAME}}</a></div>
			  <div>{{feedback.DATE}}</div>
			  <div>{{feedback.FEEDBACK}}</div>
	
			  {{#if feedback.eDit}}
				<button class="ediZ" type="button" {{on "click" (fn this.editOtziv feedback.FEEDBACK)}}>Изменить отзыв</button>
			  {{/if}}
			</div>
		  {{/each}}
	
		  {{#if this.mORE}}
			<button class="morZ" type="button" {{on "click" this.showMORZ}}>ещё</button>
		  {{else}}
			{{#if this.model.fbARC}}
			  <div class="kekus zeZ">
				<div><a>Отзывов в Архиве</a></div>
				<div></div>
				<div><h3>{{this.model.fbARC}}</h3></div>
			  </div>
			{{/if}}
		  {{/if}}
		</div>
	  </div>
	
	  <br />
	
	  <div class="kekkok">
		<h2>Аккаунты</h2>
		<div class="keklist gamZ">
		  {{#each this.model.ugameZ as |gamez|}}
			<div class="kekus zeZ">
			  <div>
				<a>{{#each gamez.poZ as |poZ|}}П{{poZ}} {{/each}}</a>
			  </div>
			  <div>{{gamez.gNAME}}</div>
			  <div class="acN">{{gamez.aCC}}</div>
			  <button class="findZ" type="button" {{on "click" (fn this.runTroikopoisk gamez.gNAMEid gamez.aCC)}}></button>
			</div>
		  {{/each}}
		  <span class="minihrenvnizu">кто владелец? я владелец! он владелец? жми на аккаунт!? узнай владельцев!</span>
		</div>
	  </div>
	
	  <br />
	
	  {{#if this.accamdal}}
		{{#if this.accawait}}
		  <div class="bagaspin"></div>
		{{else}}
		  {{#if this.troikopoisk.poiskwin}}
			<div class="kekkok">
			  <h2>{{this.troikopoisk._id}}</h2>
	
			  {{#unless this.model.MENOSHO}}
				<div class="xdux">
				  {{#unless this.actualgp}}
					{{#if this.passwait}}
					  <div class="tinybagaspin"></div>
					{{else}}
					  <button class="buttZ" type="button" {{on "click" (fn this.getPaZZ this.troikopoisk._id)}}>&#215; получить пароль &#215;</button>
					{{/if}}
				  {{else}}
					{{#if this.actualgp.winrar}}{{this.actualgp.winrar}}{{/if}}
					{{#if this.actualgp.spam}}Бот выдает только <b>два</b> пароля в день, других сегодня небудет{{/if}}
					{{#if this.actualgp.noconnect}}Бот не отвечает: {{this.actualgp.status}}{{/if}}
					{{#if this.actualgp.error}}Бот сломался и словил ошибку: {{this.actualgp.status}}{{/if}}
					{{#if this.actualgp.noufb}}Бот не работать без отзывов от организатора{{/if}}
					{{#if this.actualgp.banned}}Бот не работать когда бан{{/if}}
				  {{/unless}}
				</div>
			  {{/unless}}
	
			  <div class="keklist gamZ">
				<div class="kekus zeZ" style="width: 100%">
				  <div style="text-align: center">{{this.troikopoisk.GAME}}</div>
				</div>
	
				{{#if this.troikopoisk.P2.[1]}}
				  <div class="kekus zeZ">
					<div><a>П2 PS4</a></div>
					<div>
						<a href="/u/{{this.troikopoisk.P2.[0]}}">{{this.troikopoisk.P2.[0]}}</a>
					</div>
				  </div>
				  <div class="kekus zeZ">
					<div><a>П4 PS4</a></div>
					<div>
						<a href="/u/{{this.troikopoisk.P4.[0]}}">{{this.troikopoisk.P4.[0]}}</a>
					</div>
				  </div>
				  <div class="kekus zeZ">
					<div><a>П4 PS4</a></div>
					<div>
						<a href="/u/{{this.troikopoisk.P4.[1]}}">{{this.troikopoisk.P4.[1]}}</a>
					</div>
				  </div>
	
				  <div class="kekus zeZ">
					<div><a>П2 PS5</a></div>
					<div>
						<a href="/u/{{this.troikopoisk.P2.[1]}}">{{this.troikopoisk.P2.[1]}}</a>
					</div>
				  </div>
				  <div class="kekus zeZ">
					<div><a>П4 PS5</a></div>
					<div>
						<a href="/u/{{this.troikopoisk.P4.[2]}}">{{this.troikopoisk.P4.[2]}}</a>
					</div>
				  </div>
				  <div class="kekus zeZ">
					<div><a>П4 PS5</a></div>
					<div>
						<a href="/u/{{this.troikopoisk.P4.[3]}}">{{this.troikopoisk.P4.[3]}}</a>
					</div>
				  </div>
				{{else}}
				  {{#if this.troikopoisk.P4.[3]}}
					<div class="kekus zeZ">
					  <div><a>П2</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P2.[0]}}">{{this.troikopoisk.P2.[0]}}</a>
					  </div>
					</div>
					<div class="kekus zeZ">
					  <div><a>П4 PS4</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P4.[0]}}">{{this.troikopoisk.P4.[0]}}</a>
					  </div>
					</div>
					<div class="kekus zeZ">
					  <div><a>П4 PS4</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P4.[1]}}">{{this.troikopoisk.P4.[1]}}</a>
					  </div>
					</div>
					<div class="kekus zeZ">
					  <div><a>П4 PS5</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P4.[2]}}">{{this.troikopoisk.P4.[2]}}</a>
					  </div>
					</div>
					<div class="kekus zeZ">
					  <div><a>П4 PS5</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P4.[3]}}">{{this.troikopoisk.P4.[3]}}</a>
					  </div>
					</div>
				  {{else}}
					<div class="kekus zeZ">
					  <div><a>П2</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P2.[0]}}">{{this.troikopoisk.P2.[0]}}</a>
					  </div>
					</div>
					<div class="kekus zeZ">
					  <div><a>П4</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P4.[0]}}">{{this.troikopoisk.P4.[0]}}</a>
					  </div>
					</div>
					<div class="kekus zeZ">
					  <div><a>П4</a></div>
					  <div>
						<a href="/u/{{this.troikopoisk.P4.[1]}}">{{this.troikopoisk.P4.[1]}}</a>
					  </div>
					</div>
				  {{/if}}
				{{/if}}
	
				{{#unless this.model.MENOSHO}}
				  <span class="minihrenvnizu">
					пароль устарел? пароль сменили! жми получить пароль!? узнай
					пароль!
				  </span>
				  <span class="minihrenvnizu">
					узнать можно только один пароль в день
				  </span>
				  <span class="minihrenvnizu">
					пользователи без отзывов от организатора узнают пароль через
					личные сообщения
				  </span>
				{{/unless}}
			  </div>
			</div>
		  {{else}}
			<h1 style="text-align: center">Epic Fail Is Epic</h1>
			<img src="https://i.imgur.com/33FJekg.png" style="width: 100%" />
		  {{/if}}
		{{/if}}
	  {{/if}}
	
	</div>
</template>
