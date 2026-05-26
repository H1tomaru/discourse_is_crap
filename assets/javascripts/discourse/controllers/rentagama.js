import Controller from '@ember/controller'
import { action } from '@ember/object'
import { tracked } from '@glimmer/tracking'
import { on } from '@ember/modifier'
import RentagamaTemplate from '../templates/rentagama'

export default class MyController extends Controller {

	template = RentagamaTemplate

	@tracked showLIST = localStorage.getItem('showLIST') === "true"
	@tracked showTYPE1 = true
	@tracked showTYPE2 = true
	@tracked showTYPE3 = true
	@tracked showTYPE4 = true
	@tracked showGAMEZ = true
	@tracked showCRAP = false
	@tracked rulez = false

	//loads external script
	constructor() {
		super(...arguments)
		this.lazyLoadScripts()
	}
	
	// Pure helper method to handle script injection asynchronously without jQuery
	async lazyLoadScripts() {
		try {
			//check if script already loaded before, if not, load it
			if (!window.lazySizes) {
				const script = document.createElement('script')
				script.src = 'https://cdnjs.cloudflare.com/ajax/libs/lazysizes/5.1.2/lazysizes.min.js'
				script.async = true
				document.head.appendChild(script)
		  }
		} catch (error) {
			console.error("Failed to load lazysizes:", error)
		}
	}

	@action
	toggleRULEZ() {
		this.rulez = !this.rulez
	}
	
	@action
	setLIST1() {
		this.showLIST = false
		localStorage.setItem('showLIST', "false")
	}
	
	@action
	setLIST2() {
		this.showLIST = true
		localStorage.setItem('showLIST', "true")
	}
	
	@action
	setShowGAMEZ() {
		this.showCRAP = false
		this.showGAMEZ = true
	}
	
	@action
	setShowCRAP() {
		this.showGAMEZ = false
		this.showCRAP = true
	}
	
	@action
	toggleTYPE1() {
		this.showTYPE1 = !this.showTYPE1;
	}
	
	@action
	toggleTYPE2() {
		this.showTYPE2 = !this.showTYPE2;
	}
	
	@action
	toggleTYPE3() {
		this.showTYPE3 = !this.showTYPE3;
	}
	
	@action
	toggleTYPE4() {
		this.showTYPE4 = !this.showTYPE4;
	}
	
}

<template>
	<link
	  rel="stylesheet"
	  href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
	  integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU"
	  crossorigin="anonymous"
	/>
	
	<div class="rentobaka">
	  <div class="gname">
		<h2>
		  Прокат игр PS4 / PS5 от <a href="/u/MrBug">MrBug</a>
		</h2>
		<button
		  class={{if this.rulez "slut"}}
		  {{on "click" this.toggleRULEZ}}
		>
		  ПРАВИЛА &amp; ИНСТРУКЦИИ
		</button>
	  </div>
	
	  {{#if this.rulez}}
		<div class="bagalert">
		  <ul>
			<h3>Для аренды игры необходимо выполнить следующие действия</h3>
			<li>
			  Определиться с выбором игры и уведомить
			  <a href="/u/MrBug">MrBug</a>, написав ему личное сообщение:
			  Название игры и срок на который Вы хотите взять игру в прокат
			</li>
			<li>
			  В ближайшее время Бага оставит вам реквизиты для оплаты проката
			</li>
			<li>После оплаты проката вам будут переданы данные аккаунта</li>
		  </ul>
		  <ul>
			<h3>Оплата</h3>
			<li>
			  Новичкам аренда предоставляется только после внесения залога за
			  игру (зависит от игры, обычно 1000р, 2000р или 3000р)
			</li>
			<li>Постояльцам аренда предоставляется с минимальным залогом</li>
			<li>
			  Залог вносится на срок проката игры и возвращается по окончанию
			  проката
			</li>
			<li>Невостребованный Залог в течении 7 дней сгорает</li>
		  </ul>
		  <ul>
			<h3>
			  Порядок действий после оплаты и получения данных аккаунта с игрой
			</h3>
			<li>
			  После получения логина и пароля, Вы включаете приставку и создаете
			  нового пользователя
			</li>
			<li>
			  В появившемся меню ввода логина и пароля вписываем полученные
			  данные
			</li>
			<br />
			<h5>При создании аккаунта П4</h5>
			<li>
			  После ввода данных аккаунт активируется как основной автоматически
			</li>
			<br />
			<li>
			  Заходим на аккаунт, выбираем вкладку "Библиотека". Находим игру в
			  списке. Нажимаем на неё и ставим игру на загрузку
			</li>
		  </ul>
		  <ul>
			<h3>Порядок действий после окончания проката П4</h3>
			<li>
			  Сообщить о готовности завершить прокат в личном сообщение
			  <a href="/u/MrBug">MrBug</a>
			</li>
			<li>
			  После ответа от <a href="/u/MrBug">MrBug</a>, заходим на
			  прокатный аккаунт и выполняем деактивацию
			</li>
			<br />
			<h5>На PS4</h5>
			<li>Выбираем настройки</li>
			<li>Выбираем пункт Управление учетной записью</li>
			<li>
			  Выбираем пункт Активировать учетную запись как основную и нажимаем
			  пункт Деактивировать
			</li>
			<li>
			  В случае если пункт Деактивировать неактивен, сначала нажимаем
			  пункт Активировать, затем нажимаем появившийся пункт
			  Деактивировать
			</li>
			<li>Выбираем Пользователи - Удалить Пользователя</li>
			<br />
			<h5>На PS5</h5>
			<li>Выбираем настройки</li>
			<li>Выбираем пункт пользователи и учетные записи</li>
			<li>
			  Выбираем пункт Другое - Общий доступ к консоли и автономная игра -
			  Отключить
			</li>
			<li>
			  В случае если пункт Отключить общий доступ неактивен, сначала
			  нажимаем пункт Включить общий доступ, затем нажимаем появившийся
			  пункт Отключить общий доступ
			</li>
			<li>Выбираем Пользователи - Удалить Пользователя</li>
			<br />
			<li>
			  После деактивации и удаления профиля, сообщаем в личном сообщении
			  <a href="/u/MrBug">MrBug</a>
			  что Вы деактивировали аккаунт и удалили профиль со своей консоли
			</li>
			<li>Укажите реквизиты и сумму для возврата залога</li>
			<li>
			  Бага проверяет аккаунт и если деактивация выполнена правильно,
			  возвращает залог
			</li>
		  </ul>
		  <ul>
			<h3>Сроки проката</h3>
			<li>
			  Срок на который Вы взяли игру в прокат начинается со следующего
			  дня от передачи Вам данных аккаунта
			</li>
			<li>При желании Вы можете вернуть аккаунт раньше срока</li>
			<li>
			  Вы можете продлить прокат по окончанию срока, сколько угодно раз,
			  независимо от очереди
			</li>
		  </ul>
		</div>
	  {{/if}}
	
	  <div class="mimu2">
		<button
		  class="rentabutt{{unless this.showLIST ' bi4'}}"
		  {{on "click" this.showLIST1}}
		>
		  Легкий Список
		</button>
		<button
		  class="rentabutt{{if this.showLIST ' bi4'}}"
		  {{on "click" this.showLIST2}}
		>
		  Тяжелый Cписок
		</button>
	  </div>
	
	  {{#unless this.showLIST}}
		<div class="rentbox">
		  <div class="title">
			Всего игр в прокате: <span>{{get this.model.count 0}}</span><br />
			<div>
			  <input
				type="checkbox"
				checked={{this.showTYPE1}}
				{{on "change" this.toggleTYPE1}}
			  />
			  Реально Игр:
			  <span>{{get this.model.count 1}}</span>
			</div>
			<div>
			  <input
				type="checkbox"
				checked={{this.showTYPE2}}
				{{on "change" this.toggleTYPE2}}
			  />
			  Легких и Коротких Платин:
			  <span>{{get this.model.count 2}}</span>
			</div>
			<div>
			  <input
				type="checkbox"
				checked={{this.showTYPE3}}
				{{on "change" this.toggleTYPE3}}
			  />
			  Легких и Коротких Игр:
			  <span>{{get this.model.count 3}}</span>
			</div>
			<div>
			  <input
				type="checkbox"
				checked={{this.showTYPE4}}
				{{on "change" this.toggleTYPE4}}
			  />
			  Хиты Для Избранных:
			  <span>{{get this.model.count 4}}</span>
			</div>
		  </div>
	
		  <span class="textright2">Неделя / Месяц</span>
	
		  <div class="innerbox">
			{{#each this.model.rentaGAMEZ as |game|}}
			  <div
				class="
				  {{unless this.showTYPE1 (if game.TYPE1 'rentahideoz')}}
				  {{unless this.showTYPE2 (if game.TYPE2 'rentahideoz')}}
				  {{unless this.showTYPE3 (if game.TYPE3 'rentahideoz')}}
				  {{unless this.showTYPE4 (if game.TYPE4 'rentahideoz')}}
				"
			  >
				{{#if game.STATUS}}
				  <span class="red">
					<b>[</b>
					<span class="hideoS">Занят</span>
					<i class="fas fa-times hideoB"></i>
					до
					{{game.STATUS}}
					<b>]</b>
					{{#if game.LINE}}
					  <b>[</b>
					  +{{game.LINE}}
					  в очереди
					  <b>]</b>
					{{/if}}
					<b>[</b>
					{{game.POSITION}}
					<b>]</b>
				  </span>
				{{else}}
				  <span class="green">
					<b>[</b>
					<span class="hideoS">Cвободен</span>
					<i class="fas fa-check hideoB"></i>
					<b>]</b>
					<b>[</b>
					{{game.POSITION}}
					<b>]</b>
				  </span>
				{{/if}}
	
				{{game.GNAME}}
	
				{{#if game.TYPE2}}
				  <span class="t2text hideoS">{{game.GCOMMENT}}</span>
				{{/if}}
				{{#if game.TYPE3}}
				  <span class="t2text hideoS">{{game.GCOMMENT}}</span>
				{{/if}}
				{{#if game.GNEW}}
				  <img src="https://i.imgur.com/84UQp3G.gif" />
				{{/if}}
	
				<span class="textright">{{game.PRICE}}</span>
			  </div>
			{{/each}}
		  </div>
		</div>
	  {{/unless}}
	
	  {{#if this.showLIST}}
		<div class="rentbox2">
		  <div class="mimu">
			<button
			  class="rentabutt{{if this.showGAMEZ ' bi4'}}"
			  {{on "click" this.setShowGAMEZ}}
			>
			  Игры Игры
			</button>
			<button
			  class="rentabutt{{if this.showCRAP ' bi4'}}"
			  {{on "click" this.setShowCRAP}}
			>
			  Легкие и Короткие
			</button>
		  </div>
	
		  {{#if this.showGAMEZ}}
			<table class="list">
			  {{#each this.model.rentaGAMEZ1 as |game index|}}
				<tbody>
				  <tr>
					<td class="gname" colspan="4"><h3>{{game.GNAME}}</h3></td>
					<td class="rentaimg" rowspan="2">
					  <img class="lazyload" data-src={{game.GPIC}} />
					  <span>{{game.GCOMMENT}}</span>
					</td>
				  </tr>
	
				  <tr>
					{{#if game.STATUS}}
					  <td class="malabela2 bgred3">
						Занят до
						{{game.STATUS}}
						{{#if game.LINE}}
						  +{{game.LINE}}
						  в очереди
						{{/if}}
					  </td>
					{{else}}
					  <td class="malabela2 bggr">Cвободен</td>
					{{/if}}
	
					<td class="malabela2"><strong>{{game.POSITION}}</strong></td>
					<td class="malabela2">{{game.PRICE}}</td>
				  </tr>
				</tbody>
			  {{/each}}
			</table>
		  {{/if}}
	
		  {{#if this.showCRAP}}
			<table class="list">
			  {{#each this.model.rentaGAMEZ2 as |game index|}}
				<tbody>
				  <tr>
					<td class="gname" colspan="4"><h3>{{game.GNAME}}</h3></td>
					<td class="rentaimg" rowspan="2">
					  <img class="lazyload" data-src={{game.GPIC}} />
					  <span>{{game.GCOMMENT}}</span>
					</td>
				  </tr>
	
				  <tr>
					{{#if game.STATUS}}
					  <td class="malabela2 bgred3">
						Занят до
						{{game.STATUS}}
						{{#if game.LINE}}
						  +{{game.LINE}}
						  в очереди
						{{/if}}
					  </td>
					{{else}}
					  <td class="malabela2 bggr">Cвободен</td>
					{{/if}}
	
					<td class="malabela2"><strong>{{game.POSITION}}</strong></td>
					<td class="malabela2">{{game.PRICE}}</td>
				  </tr>
				</tbody>
			  {{/each}}
			</table>
		  {{/if}}
		</div>
	  {{/if}}
	</div>
</template>
