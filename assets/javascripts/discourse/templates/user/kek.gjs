import { on } from '@ember/modifier'
import { fn } from '@ember/helper'
import { Input } from '@ember/component'

export default <template>
	<div class="kekbakaz">
		<br />
	
		{{#if @controller.otzivmdal}}
			<form {{on "submit" @controller.OtzivZaips}}>
				<div style="position: relative">
					<button	type="button" class={{if @controller.checked1 "bi4"}} {{on "click" (fn @controller.selectOtz 1)}}><img src="https://i.imgur.com/rmydNkF.png" /></button>
					<button	type="button" class={{if @controller.checked2 "bi4"}} {{on "click" (fn @controller.selectOtz 2)}}><img src="https://i.imgur.com/OMygNKW.png" /></button>
					<button	type="button" class={{if @controller.checked3 "bi4"}} {{on "click" (fn @controller.selectOtz 3)}}><img src="https://i.imgur.com/ZcxqN8c.png" /></button>
					<button type="button" style="position: absolute; right: -10px; top: 5px;" {{on "click" (fn @controller.clozOtziv)}}>
						<svg width="20" height="20" viewBox="0 0 16 16">
  							<path d="M2.146 2.854a.5.5 0 1 1 .708-.708L8 7.293l5.146-5.147a.5.5 0 0 1 .708.708L8.707 8l5.147 5.146a.5.5 0 0 1-.708.708L8 8.707l-5.146 5.147a.5.5 0 0 1-.708-.708L7.293 8z"></path>
						</svg>
					</button>
				</div>
				
				<div class="{{if @controller.checked1 'bi4G'}}{{if @controller.checked2 'bi4N'}}{{if @controller.checked3 'bi4B'}}">
					<Input minlength="20" maxlength="200" type="text" @value={{@controller.pisanina}} />
				</div>
				
				<button type="submit">{{if @controller.ozmode "Добавить" "Изменить"}} Отзыв</button>
			</form>
			
			{{#if @controller.otzivsmall}}
				<div class="netmudal">
					Отзыв Слишком Короткий!
					<button type="button" {{on "click" @controller.respCLOZ}}></button>
				</div>
			{{/if}}
			
			{{#if @controller.otzivbig}}
				<div class="netmudal">
					Отзыв Слишком Длинный!
					<button type="button" {{on "click" @controller.respCLOZ}}></button>
				</div>
			{{/if}}
		{{/if}}
	
		{{#if @controller.responz.winrars_z}}
			<div class="netmudal">
				Отзыв Успешно Записан!
				<button type="button" {{on "click" @controller.respCLOZ}}></button>
			</div>
		{{/if}}
	
		{{#if @controller.responz.winrars_e}}
			<div class="netmudal">
				Отзыв Успешно Изменен!
				<button type="button" {{on "click" @controller.respCLOZ}}></button>
			</div>
		{{/if}}
		
		{{#if @controller.responz.gavas_z}}
			<div class="netmudal">
				Вы Уже Оставляли Отзыв, Попробуйте Завтра
				<button type="button" {{on "click" @controller.respCLOZ}}></button>
			</div>
		{{/if}}
	
		{{#if @controller.responz.gavas_e}}
			<div class="netmudal">
				Вы Уже Изменяли Отзыв, Попробуйте Завтра
				<button type="button" {{on "click" @controller.respCLOZ}}></button>
			</div>
		{{/if}}
	
		{{#if @controller.responz.bakas}}
			<div class="netmudal">
				Вы не можете оставлять отзывы имея отрицательный отзыв<br />
				Обратитетсь к <a href="/u/MrBug">Админу</a> чтобы исправить отзыв
				<button type="button" {{on "click" @controller.respCLOZ}}></button>
			</div>
		{{/if}}
	
		{{#if @controller.responz.fail}}
			<div style="background-image:url('https://i.imgur.com/33FJekg.png'); width: 100%; height: 800px;">Epic Fail Is Epic</div>
		{{/if}}
	
		<div class="kekkok">
			<h2>Отзывы</h2>
			<div class="xdux">
				<span style="color: #27ae60">{{@controller.model.fbG}}</span>
				/
				<span style="color: gray">{{@controller.model.fbN}}</span>
				/
				<span style="color: lightcoral">{{@controller.model.fbB}}</span>
			</div>
			
			<div class="keklist">
				{{#if @controller.model.MENOSHO}}
					<div class="kekus">
						<button class="addZ" type="button" {{on "click" @controller.addOtziv}}>Оставить отзыв</button>
					</div>
				{{/if}}
		
				{{#each @controller.fEEDBACKS.fb1 as |feedback|}}
					<div class="kekus {{feedback.COLOR}}">
						<div><a href="/u/{{feedback.pNAME}}">{{feedback.pNAME}}</a></div>
						<div>{{feedback.DATE}}</div>
						<div>{{feedback.FEEDBACK}}</div>
		
						{{#if feedback.eDit}}
							<button class="ediZ" type="button" {{on "click" (fn @controller.editOtziv feedback.FEEDBACK)}}>Изменить отзыв</button>
						{{/if}}
					</div>
				{{/each}}
		
				{{#if @controller.mORE}}
					<button class="morZ" type="button" {{on "click" @controller.showMORZ}}>ещё</button>
				{{else}}
					{{#if @controller.model.fbARC}}
						<div class="kekus zeZ">
							<div><a>Отзывов в Архиве</a></div>
							<div></div>
							<div><h3>{{@controller.model.fbARC}}</h3></div>
						</div>
					{{/if}}
				{{/if}}
			</div>
		</div>
	
		<br />
	
		<div class="kekkok">
			<h2>Аккаунты</h2>
			<div class="keklist gamZ">
				{{#each @controller.model.ugameZ as |gamez|}}
					<div class="kekus zeZ">
						<div><a>{{#each gamez.poZ as |poZ|}}П{{poZ}} {{/each}}</a></div>
						<div>{{gamez.gNAME}}</div>
						<div class="acN">{{gamez.aCC}}</div>
						<button class="findZ" type="button" {{on "click" (fn @controller.runTroikopoisk gamez.gNAMEid gamez.aCC)}}></button>
					</div>
				{{/each}}
				<span class="minihrenvnizu">кто владелец? я владелец! он владелец? жми на аккаунт!? узнай владельцев!</span>
			</div>
		</div>
		
		<br />

		{{#if @controller.accamdal}}
			{{#if @controller.accawait}}
				<div class="bagaspin"></div>
			{{else}}
				{{#if @controller.troikopoisk.poiskwin}}
					<div class="kekkok">
						<h2>{{@controller.troikopoisk._id}}</h2>
					
						{{#unless @controller.model.MENOSHO}}
							<div class="xdux">
								{{#unless @controller.actualgp}}
									{{#if @controller.passwait}}
										<div class="tinybagaspin"></div>
									{{else}}
										<button class="buttZ" type="button" {{on "click" (fn @controller.getPaZZ @controller.troikopoisk._id)}}>&#215; получить пароль &#215;</button>
									{{/if}}
								{{else}}
									{{#if @controller.actualgp.winrar}}{{@controller.actualgp.winrar}}{{/if}}
									{{#if @controller.actualgp.spam}}Бот выдает только <b>два</b> пароля в день, других сегодня небудет{{/if}}
									{{#if @controller.actualgp.noconnect}}Бот не отвечает: {{@controller.actualgp.status}}{{/if}}
									{{#if @controller.actualgp.error}}Бот сломался и словил ошибку: {{@controller.actualgp.status}}{{/if}}
									{{#if @controller.actualgp.noufb}}Бот не работать без отзывов от организатора{{/if}}
									{{#if @controller.actualgp.banned}}Бот не работать когда бан{{/if}}
								{{/unless}}
							</div>
						{{/unless}}
					
						<div class="keklist gamZ">
							<div class="kekus zeZ" style="width: 100%">
								<div style="text-align: center">{{@controller.troikopoisk.GAME}}</div>
							</div>
			
							<div class="kekus zeZ">
								<div><a>П2</a></div>
								<div><a href="/u/{{@controller.troikopoisk.P2.[0]}}">{{@controller.troikopoisk.P2.[0]}}</a></div>
							</div>
							<div class="kekus zeZ">
								<div><a>П4</a></div>
								<div><a href="/u/{{@controller.troikopoisk.P4.[0]}}">{{@controller.troikopoisk.P4.[0]}}</a></div>
							</div>
							<div class="kekus zeZ">
								<div><a>П4</a></div>
								<div><a href="/u/{{@controller.troikopoisk.P4.[1]}}">{{@controller.troikopoisk.P4.[1]}}</a></div>
							</div>
					
							{{#unless @controller.model.MENOSHO}}
								<span class="minihrenvnizu">пароль устарел? пароль сменили! жми получить пароль!? узнай пароль!</span>
								<span class="minihrenvnizu">узнать можно только один пароль в день</span>
								<span class="minihrenvnizu">пользователи без отзывов от организатора узнают пароль через личные сообщения</span>
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
