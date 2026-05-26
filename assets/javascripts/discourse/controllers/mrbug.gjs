import Controller from '@ember/controller'
import { action } from '@ember/object'
import { service } from '@ember/service'
import { tracked } from '@glimmer/tracking'
import MrBugTemplate from '../templates/mrbug'

export default class MyController extends Controller {

	template = MrBugTemplate

	//gets current user?
	@service currentUser

	//default states
	// Tracked states for automatic template rerendering
	@tracked bagamdal = false
	@tracked mdalready = false
	@tracked prezaips = null
	@tracked pzposition = null
	@tracked zaipsResult = null
	@tracked showhideo = [true, true, true]

	get glizt () {
		//make variables for each game type
		const finalvar = {gamedb1: [], gamedb2: [], gamedb3: [], maigamez1: [], maigamez2: []}
		const currentuser = this.currentUser?.username
		const gameList = this.model?.gamelist

		gameList.forEach((item) => {
			//template stuff, if paint game red or green
			item.MODE1 = false; item.MODE2 = false

			//if not guest, check if user is in this troika
			if (currentuser) {
				//template shit for type 2 and 3 games displaying type 2 and 3 stuff
				//cool way for simlified true false stuff
				const gTYPE2 = item.TYPE === 2
       			const gTYPE3 = item.TYPE === 3

				//loop thorought troikas and see if current user is in it
				item.TROIKI.forEach((troika) => {
					//template stuff, if paint user sostav red or green
					troika.MODE1 = false; troika.MODE2 = false

					//calculate if user is in this troika, if he is, add user + gname to list, also gamechangecolor = true, troika change color = true
					for (let i = 0; i < 3; i++) {
						if (currentuser === troika['USERS']?.[i]) {
							//declare variables with let/const so they don't leak globally
				            let PPRICE
				            let PPOSITION
							//see if we are p2 or p4 to show its P position and P price
							if (i === 0) {
								PPRICE = item.PRICE2
								PPOSITION = 2
							} else {
								PPRICE = item.PRICE4
								PPOSITION = 4
							}
							if (troika['PSTATUS']?.[i]?.[0] == true) {
								item.MODE1 = true; troika.MODE1 = true; item.MODE2 = false; troika.MODE2 = false
								finalvar.maigamez1.push( {
									POSITION: PPOSITION, gNAME: item.gameNAME, gPIC: item.imgLINK, PRICE: PPRICE,
									DATE: item.DATE, TYPE2: gTYPE2, TYPE3: gTYPE3
								} )
							} else {
								if (item.MODE1 === false) item.MODE2 = true
								if (troika.MODE1 === false) troika.MODE2 = true
								finalvar.maigamez2.push( { POSITION: PPOSITION, gNAME: item.gameNAME, gPIC: item.imgLINK } )
							}
						}
					} 
				})
			}

			//fill 3 variables for each game type
			if (item.TYPE == 1) finalvar.gamedb1.push(item)
			if (item.TYPE == 2) finalvar.gamedb2.push(item)
			if (item.TYPE == 3) finalvar.gamedb3.push(item)
		})

		return finalvar
	})

	@action
	netmudal() {
		Object.assign(this, { bagamdal: false, mdalready: false, prezaips: null, zaipsResult: null })
	}

	@action
	async zaips(knopk, gcode) {
		this.bagamdal = true
		//if not guest, do prezaips, else display guest message
		const currentuser = this.currentUser?.username
		
		if (currentuser) {
			try {
				const response = await fetch("/MrBug/prezaips/", {
					method: 'POST',
					headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
					body: new URLSearchParams({ bagakruta: btoa(`${knopk}~${gcode}`) })
				})
				const result = await response.json()
				this.prezaips = result
			  
				if (result?.position) {
					this.pzposition = result['position']?.[0]
				}
				this.mdalready = true
		 	} catch (error) {
				console.error("Failed to run prezaips post syntax:", error)
			}
		} else {
			this.prezaips = { guest: true }
			this.mdalready = true
		}
	}

	@action
	async imgoingin() {
		this.mdalready = false
		//ember doesnt update on 2nd level variables, so use this shit
		this.prezaips = { ...this.prezaips, winrars: false }
		
		try {
			const payload = btoa(unescape(encodeURIComponent(
				`${this.prezaips?.position}~${this.currentUser?.username}~${this.prezaips?._id}~${this.prezaips?.gameNAME}`
			)))
			
			const response = await fetch("/MrBug/zaips/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({ bagatrolit: payload })
			})
			const result = await response.json()
			this.zaipsResult = result
			
			const response2 = await fetch('/MrBug.json')
			const result2 = await response2.json()
			
			this.model = result2 // Mutating this automatically updates the glizt getter!
			this.mdalready = true
		} catch (error) {
			console.error("Failed to run imgoingin submission:", error)
		}
	}


	@action
	async imgoingin() {
		this.mdalready = false
		this.prezaips = { ...this.prezaips, winrars: false }
		
		
		try {
		const payload = btoa(
		unescape(
		encodeURIComponent(
		`${this.prezaips?.position}~${this.currentUser?.username}~${this.prezaips?._id}~${this.prezaips?.gameNAME}`
		)
		)
		)
		
		const zaipsResponse = await fetch("/MrBug/zaips/", {
		method: "POST",
		headers: { "Content-Type": "application/x-www-form-urlencoded" },
		body: new URLSearchParams({ bagatrolit: payload }),
		})
		
		const zaipsResult = await zaipsResponse.json()
		this.zaipsResult = zaipsResult
		
		const response = await fetch("/MrBug.json")
		const result = await response.json()
		
		this.model = result
		this.mdalready = true
		} catch (error) {
		console.error("Failed to run imgoingin submission:", error)
		this.zaipsResult = { zaipsfail: true }
		this.mdalready = true
		}
	}

	@action
	showhideo(index) {
		// Unpacks list reference array to toggle dashboard filter tab visibility flags
		const newShowHideo = [...this.showhideo]
		newShowHideo[index] = !newShowHideo[index]
		this.showhideo = newShowHideo
	}

	@action
	showhideo1(index) {
		const item = this.glizt.gamedb1?.[index]
		if (item) {
			item.SHOWHIDEO = !item.SHOWHIDEO
			this.model = { ...this.model }
		}
	}

	@action
	showhideo2(index) {
		const item = this.glizt.gamedb2?.[index]
		if (item) {
			item.SHOWHIDEO = !item.SHOWHIDEO
			this.model = { ...this.model }
		}
	}

	@action
	showhideo3(index) {
		const item = this.glizt.gamedb3?.[index]
		if (item) {
			item.SHOWHIDEO = !item.SHOWHIDEO
			this.model = { ...this.model }
		}
	}

	@action
	zaips2(gameId, event) {
		event.stopPropagation();
		this.zaips("2", gameId);
	}

	@action
	zaips4(gameId, event) {
		event.stopPropagation();
		this.zaips("4", gameId);
	}

}

<template>
	<link
	  rel="stylesheet"
	  href="https://use.fontawesome.com/releases/v5.5.0/css/all.css"
	  integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU"
	  crossorigin="anonymous"
	/>
	<div class="shinbakaz">
	
	  <hr />
	  <h1 class="razdelhe">Совместная покупка игр для PS4 / PS5</h1>
	  <hr />
	
	  <table class="bagahe">
		<tbody>
		  <tr>
			<td>
			  <span class="smaladndark tablq">организатор</span>
			  <div class="headin"><a href="/u/MrBug">MrBug</a></div>
			</td>
		  </tr>
	
		  <tr>
			<td colspan="2">
			  <span class="smaladndark">
				Реквизиты на оплату можно получить через <a href="/u/MrBug">Личные Сообщения</a>
			  </span>
			</td>
		  </tr>
		</tbody>
	  </table>
	
	  <br />
	
	  {{#if this.glizt.maigamez1}}
		<div class="ghead red"><h2>ЖДЕМ ОПЛАТУ</h2></div>
		<table class="atats kadu">
		  <colgroup>
			<col width="70px" />
			<col width="30px" />
			<col width="100%" />
			<col width="0" />
			<col width="50px" />
		  </colgroup>
		  {{#each this.glizt.maigamez1 as |game|}}
			<tr>
			  <td>
				<img src="{{game.gPIC}}" alt="{{game.gNAME}}" />
			  </td>
	
			  <td>
				П{{game.POSITION}}
			  </td>
	
			  <td>
				<a>{{game.gNAME}}</a>
				{{#if game.TYPE2}}
				  <br /><span class="smaladndark">Акция до: {{game.DATE}}</span>
				{{/if}}
				{{#if game.TYPE3}}
				  <br /><span class="smaladndark">Дата выхода: {{game.DATE}}</span>
				{{/if}}
			  </td>
	
			  {{#if game.PRICE}}
				<td>
				  {{game.PRICE}}р
				</td>
			  {{else}}
				<td>
				  Цена неизвестна
				</td>
			  {{/if}}
			</tr>
		  {{/each}}
		</table>
		<div style="text-align: center"><span class="kawaiNO">Реквизиты на оплату получать в ЛС</span></div>
		<span class="smaladndark tablq">
		  Сообщите об оплате в соответсвующей личке "Тройка собрана! Ждем оплату!"!<br />
		  Если состав не собран и соотвествующей лички нету, сообщить об оплате можно мне через <a href="/u/MrBug">Личное Сообщение</a><br />
		  Выписаться из несобранного состава можно через неделю через <a href="/u/MrBug">Личные Сообщения</a><br />
		</span>
	
		<hr />
	  {{/if}}
	
	  <br />
	
	  {{#if this.glizt.maigamez2}}
		<div class="ghead green"><h2>ОПЛАЧЕНО</h2></div>
		<table class="atats udak">
		  <colgroup>
			<col width="70px" />
			<col width="30px" />
			<col width="100%" />
		  </colgroup>
		  {{#each this.glizt.maigamez2 as |game|}}
			<tr>
			  <td>
				<img src="{{game.gPIC}}" alt="{{game.gNAME}}" />
			  </td>
	
			  <td>
				П{{game.POSITION}}
			  </td>
	
			  <td>
				<a>{{game.gNAME}}</a>
			  </td>
			</tr>
		  {{/each}}
		</table>
		<span class="smaladndark tablq">
		  Ход и статус раздачи отслеживайте по списку ниже :)
		</span>
	
		<hr />
	  {{/if}}
	
	  {{#if this.bagamdal}}
		<div class="etomudal">
	
		  {{#if this.mdalready}}
	
			<button class="netmudal" type="button" {{on "click" this.netmudal}}></button>
	
			{{#if this.prezaips.guest}}
			  <div class="mudalcontent mudaladdon headin3">
				<div class="bagariban">ВНИМАНИЕ</div>
				<span>Для участия в совместной покупке игр требуется <a href="/signup">Регистрация</a></span>
			  </div>
			{{/if}}
	
			{{#if this.prezaips.banned}}
			  <div class="mudalcontent mudaladdon headin3">
				<div class="bagariban">ВНИМАНИЕ</div>
				<span>Запись возможна только через личное сообщение <a href="/u/MrBug">Организатору</a></span>
			  </div>
			{{/if}}
	
			{{#if this.prezaips.winrars}}
			  <div class="mudalcontent headin3 prezaips">
				<div class="bagato">
				  <div class="bagapi" style="{{concat "background-image:url('" this.prezaips.imgLINK "')"}}"></div>
				  <h1><a>{{this.prezaips.gameNAME}}</a> Запись</h1>
				</div>
				<button type="button" {{on "click" this.imgoingin}}>Записаться на П{{this.pzposition}}</button><button type="button" {{on "click" this.netmudal}}>Закрыть</button>
			  </div>
			{{/if}}
	
			{{#if this.zaipsResult.winrars}}
			  <div class="mudalcontent mudaladdon headin3">
				<span>Запись</span>
				<span>на позицию П{{this.pzposition}}</span>
				<div class="bagariban">{{this.zaipsResult.gameNAME}}</div>
				<span>Успешно произведена!</span>
			  </div>
			{{/if}}
	
			{{#if this.zaipsResult.zaipsfail}}
			  <div class="mudalcontent headin3 prezaips">
				<div class="bagato">
				  <div class="bagapi" style="background-image:url('https://i.imgur.com/33FJekg.png')">Epic Fail Is Epic</div>
				</div>
			  </div>
			{{/if}}
	
		  {{else}}
	
			<div class="bagaspin"></div>
	
		  {{/if}}
	
		</div>
	  {{/if}}
	
	  {{#if this.glizt.gamedb1}}
		<div class='ghed {{unless (get this.showhideo 0) "slut"}}' {{on "click" (fn this.showhideo 0)}}><i class='fas fa-users'></i> Просто Игры <span class='smaladndark'>Ждут своих героев</span></div>
		<div class='MrBug'>
	
		{{#if (get this.showhideo 0)}}
		{{#each this.glizt.gamedb1 as |game index|}}
	
		  <table class='ggg {{if game.MODE1 "bgred2"}}{{if game.MODE2 "bggr3"}}' {{on "click" (fn this.showhideo1 index)}}>
			<tr>
			  <td class='flagco'>{{#if game.MODE1}}<i class='fas fa-exclamation fa-2x fa-pulse'></i>{{/if}}<i title='{{game.STORE}} Store' class='flag {{game.STORE}}'></i></td>
			  <td class='imgco'><img src='{{game.imgLINK}}' alt='{{game.gameNAME}}' /></td>
			  <td class='mainco'>
				<a>{{game.gameNAME}}</a><br />
				<span class='baga baga-{{game.CONSOLE}}'>{{game.CONSOLE}}</span>
				<span class='smaladndark minihrenvnizu'> &gt;&gt; открыть составы &lt;&lt; </span>
			  </td>
			  <td>
				<button type="button" {{on "click" (fn this.zaips2 game._id)}} class='BagButon'>П2<br />
				  {{#if game.PRICE2}}
					<h3>{{game.PRICE2}}</h3><br />рублей
				  {{else}}
					<h3>НЕТ</h3><br />цены
				  {{/if}}
				  {{#if game.P2NO}}<div class='statustr status-1'>{{game.P2NO}}</div>{{/if}}
				</button>
			  </td>
			  <td>
				<button type="button" {{on "click" (fn this.zaips4 game._id)}} class='BagButon'>П4<br />
				  {{#if game.PRICE4}}
					<h3>{{game.PRICE4}}</h3><br />рублей
				  {{else}}
					<h3>НЕТ</h3><br />цены
				  {{/if}}
				  {{#if game.P4NO}}<div class='statustr status-1'>{{game.P4NO}}</div>{{/if}}
				</button>
			  </td>
			</tr>
		  </table>
	
		  {{#if game.SHOWHIDEO}}
		  <table class="djuke">
			{{#each game.TROIKI as |users|}}
			  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
				<td></td>
				<td colspan='2'>П2</td>
				<td colspan='2'>П4</td>
			  </tr>
			  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
				<td>
				  {{#if users.ACCOUNT}}{{users.ACCOUNT}}{{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 0)}}
					<a title='{{if game.PRICE2 (concat game.PRICE2 "р")}}' href='/u/{{get users.USERS 0}}'>{{get users.USERS 0}}</a>
					<a class='repala {{if (get users.PFBred 1) "bgred" "bggr2"}}' href='/u/{{get users.USERS 0}}/kek'>
					  {{get (get users.FEEDBACK 0) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 0) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 0) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 0) "BAD"}}
					  </span>
					</a>
				  {{else}}
					{{#if (get users.PTAKEN 0)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE2 (concat game.PRICE2 "р")}}
					{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 0)}}
					{{#if (get (get users.PSTATUS 0) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 1)}}
					<a title='{{if game.PRICE4 (concat game.PRICE4 "р")}}' href='/u/{{get users.USERS 1}}'>{{get users.USERS 1}}</a>
					<a class='repala {{if (get users.PFBred 1) "bgred" "bggr2"}}' href='/u/{{get users.USERS 1}}/kek'>
					  {{get (get users.FEEDBACK 1) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 1) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 1) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 1) "BAD"}}
					  </span></a>
				  {{else}}
					{{#if (get users.PTAKEN 1)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE4 (concat game.PRICE4 "р")}}
					{{/if}}
				  {{/if}}
				  <br />
				  {{#if (get users.USERS 2)}}
					<a title='{{if game.PRICE4 (concat game.PRICE4 "р")}}' href='/u/{{get users.USERS 2}}'>{{get users.USERS 2}}</a>
					<a class='repala {{if (get users.PFBred 2) "bgred" "bggr2"}}' href='/u/{{get users.USERS 2}}/kek'>
					  {{get (get users.FEEDBACK 2) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 2) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 2) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 2) "BAD"}}
					  </span>
					</a>
				  {{else}}
					{{#if (get users.PTAKEN 2)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE4 (concat game.PRICE4 "р")}}
					{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 1)}}
					{{#if (get (get users.PSTATUS 1) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				  {{#if (get users.USERS 2)}}
					{{#if (get (get users.PSTATUS 2) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				</td>
			  </tr>
			{{else}}
			  <tr><td>Пусто</td></tr>
			{{/each}}
		  </table>
		  {{/if}}
	
		{{/each}}
		{{/if}}
	
		</div>
	  {{/if}}
	
	  {{#if this.glizt.gamedb2}}
		<div class='ghed {{unless (get this.showhideo 1) "slut"}}' {{on "click" (fn this.showhideo 1)}}><i class='fas fa-tags'></i> Распродажи <span class='smaladndark'>Самые (о)х#$@&%*ые! скидки в PSN</span></div>
		<div class='MrBug'>
	
		{{#if (get this.showhideo 1)}}
		{{#each this.glizt.gamedb2 as |game index|}}
	
		  <table class='ggg {{if game.MODE1 "bgred2"}}{{if game.MODE2 "bggr3"}}' {{on "click" (fn this.showhideo2 index)}}>
			<tr>
			  <td class='flagco'>{{#if game.MODE1}}<i class='fas fa-exclamation fa-2x fa-pulse'></i>{{/if}}<i title='{{game.STORE}} Store' class='flag {{game.STORE}}'></i></td>
			  <td class='imgco'><img src='{{game.imgLINK}}' alt='{{game.gameNAME}}' /></td>
			  <td class='mainco'>
				<a>{{game.gameNAME}}</a><br />
				<span class='text'>Акция до {{game.DATE}}</span>
				<span class='baga baga-{{game.CONSOLE}}'>{{game.CONSOLE}}</span>
				<span class='smaladndark minihrenvnizu'> &gt;&gt; открыть составы &lt;&lt; </span>
			  </td>
			  <td>
				<button type="button" {{on "click" (fn this.zaips2 game._id)}} class='BagButon'>П2<br />
				  {{#if game.PRICE2}}
					<h3>{{game.PRICE2}}</h3><br />рублей
				  {{else}}
					<h3>НЕТ</h3><br />цены
				  {{/if}}
				  {{#if game.P2NO}}<div class='statustr status-1'>{{game.P2NO}}</div>{{/if}}
				</button>
			  </td>
			  <td>
				<button type="button" {{on "click" (fn this.zaips4 game._id)}} class='BagButon'>П4<br />
				  {{#if game.PRICE4}}
					<h3>{{game.PRICE4}}</h3><br />рублей
				  {{else}}
					<h3>НЕТ</h3><br />цены
				  {{/if}}
				  {{#if game.P4NO}}<div class='statustr status-1'>{{game.P4NO}}</div>{{/if}}
				</button>
			  </td>
			</tr>
		  </table>
	
		  {{#if game.SHOWHIDEO}}
		  <table class="djuke">
			{{#each game.TROIKI as |users|}}
			  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
				<td></td>
				<td colspan='2'>П2</td>
				<td colspan='2'>П4</td>
			  </tr>
			  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
				<td>
				  {{#if users.ACCOUNT}}{{users.ACCOUNT}}{{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 0)}}
					<a title='{{if game.PRICE2 (concat game.PRICE2 "р")}}' href='/u/{{get users.USERS 0}}'>{{get users.USERS 0}}</a>
					<a class='repala {{if (get users.PFBred 1) "bgred" "bggr2"}}' href='/u/{{get users.USERS 0}}/kek'>
					  {{get (get users.FEEDBACK 0) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 0) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 0) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 0) "BAD"}}
					  </span>
					</a>
				  {{else}}
					{{#if (get users.PTAKEN 0)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE2 (concat game.PRICE2 "р")}}
					{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 0)}}
					{{#if (get (get users.PSTATUS 0) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 1)}}
					<a title='{{if game.PRICE4 (concat game.PRICE4 "р")}}' href='/u/{{get users.USERS 1}}'>{{get users.USERS 1}}</a>
					<a class='repala {{if (get users.PFBred 1) "bgred" "bggr2"}}' href='/u/{{get users.USERS 1}}/kek'>
					  {{get (get users.FEEDBACK 1) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 1) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 1) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 1) "BAD"}}
					  </span></a>
				  {{else}}
					{{#if (get users.PTAKEN 1)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE4 (concat game.PRICE4 "р")}}
					{{/if}}
				  {{/if}}
				  <br />
				  {{#if (get users.USERS 2)}}
					<a title='{{if game.PRICE4 (concat game.PRICE4 "р")}}' href='/u/{{get users.USERS 2}}'>{{get users.USERS 2}}</a>
					<a class='repala {{if (get users.PFBred 2) "bgred" "bggr2"}}' href='/u/{{get users.USERS 2}}/kek'>
					  {{get (get users.FEEDBACK 2) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 2) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 2) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 2) "BAD"}}
					  </span>
					</a>
				  {{else}}
					{{#if (get users.PTAKEN 2)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE4 (concat game.PRICE4 "р")}}
					{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 1)}}
					{{#if (get (get users.PSTATUS 1) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				  {{#if (get users.USERS 2)}}
					{{#if (get (get users.PSTATUS 2) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				</td>
			  </tr>
			{{else}}
			  <tr><td>Пусто</td></tr>
			{{/each}}
		  </table>
		  {{/if}}
	
		{{/each}}
		{{/if}}
	
		</div>
	  {{/if}}
	
	  {{#if this.glizt.gamedb3}}
		<div class='ghed {{unless (get this.showhideo 2) "slut"}}' {{on "click" (fn this.showhideo 2)}}><i class='fas fa-history'></i> Предзаказы <span class='smaladndark'>Хотел купить, теперь не уверен</span></div>
		<div class='MrBug'>
	
		{{#if (get this.showhideo 2)}}
		{{#each this.glizt.gamedb3 as |game index|}}
	
		  <table class='ggg {{if game.MODE1 "bgred2"}}{{if game.MODE2 "bggr3"}}' {{on "click" (fn this.showhideo3 index)}}>
			<tr>
			  <td class='flagco'>{{#if game.MODE1}}<i class='fas fa-exclamation fa-2x fa-pulse'></i>{{/if}}<i title='{{game.STORE}} Store' class='flag {{game.STORE}}'></i></td>
			  <td class='imgco'><img src='{{game.imgLINK}}' alt='{{game.gameNAME}}' /></td>
			  <td class='mainco'>
				<a>{{game.gameNAME}}</a><br />
				<span class='text'>Дата выхода {{game.DATE}}</span>
				<span class='baga baga-{{game.CONSOLE}}'>{{game.CONSOLE}}</span>
				{{#if game.CONSOLE2}}
				  <span class='baga baga-{{game.CONSOLE2}}'>{{game.CONSOLE2}}</span>
				{{/if}}
				<span class='smaladndark minihrenvnizu'> &gt;&gt; открыть составы &lt;&lt; </span>
			  </td>
			  <td>
				<button type="button" {{on "click" (fn this.zaips2 game._id)}} class='BagButon'>П2<br />
				  {{#if game.PRICE2}}
					<h3>{{game.PRICE2}}</h3><br />рублей
				  {{else}}
					<h3>НЕТ</h3><br />цены
				  {{/if}}
				  {{#if game.P2NO}}<div class='statustr status-1'>{{game.P2NO}}</div>{{/if}}
				</button>
			  </td>
			  <td>
				<button type="button" {{on "click" (fn this.zaips4 game._id)}} class='BagButon'>П4<br />
				  {{#if game.PRICE4}}
					<h3>{{game.PRICE4}}</h3><br />рублей
				  {{else}}
					<h3>НЕТ</h3><br />цены
				  {{/if}}
				  {{#if game.P4NO}}<div class='statustr status-1'>{{game.P4NO}}</div>{{/if}}
				</button>
			  </td>
			</tr>
		  </table>
	
		  {{#if game.SHOWHIDEO}}
		  <table class="djuke">
			{{#each game.TROIKI as |users|}}
			  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
				<td></td>
				<td colspan='2'>П2</td>
				<td colspan='2'>П4</td>
			  </tr>
			  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
				<td>
				  {{#if users.ACCOUNT}}{{users.ACCOUNT}}{{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 0)}}
					<a title='{{if game.PRICE2 (concat game.PRICE2 "р")}}' href='/u/{{get users.USERS 0}}'>{{get users.USERS 0}}</a>
					<a class='repala {{if (get users.PFBred 1) "bgred" "bggr2"}}' href='/u/{{get users.USERS 0}}/kek'>
					  {{get (get users.FEEDBACK 0) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 0) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 0) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 0) "BAD"}}
					  </span>
					</a>
				  {{else}}
					{{#if (get users.PTAKEN 0)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE2 (concat game.PRICE2 "р")}}
					{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 0)}}
					{{#if (get (get users.PSTATUS 0) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 0) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 1)}}
					<a title='{{if game.PRICE4 (concat game.PRICE4 "р")}}' href='/u/{{get users.USERS 1}}'>{{get users.USERS 1}}</a>
					<a class='repala {{if (get users.PFBred 1) "bgred" "bggr2"}}' href='/u/{{get users.USERS 1}}/kek'>
					  {{get (get users.FEEDBACK 1) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 1) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 1) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 1) "BAD"}}
					  </span></a>
				  {{else}}
					{{#if (get users.PTAKEN 1)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE4 (concat game.PRICE4 "р")}}
					{{/if}}
				  {{/if}}
				  <br />
				  {{#if (get users.USERS 2)}}
					<a title='{{if game.PRICE4 (concat game.PRICE4 "р")}}' href='/u/{{get users.USERS 2}}'>{{get users.USERS 2}}</a>
					<a class='repala {{if (get users.PFBred 2) "bgred" "bggr2"}}' href='/u/{{get users.USERS 2}}/kek'>
					  {{get (get users.FEEDBACK 2) "PERCENT"}}%
					  <span>
						<i class='far fa-smile'></i> {{get (get users.FEEDBACK 2) "GOOD"}}
						<i class='far fa-meh'></i> {{get (get users.FEEDBACK 2) "NEUTRAL"}}
						<i class='far fa-frown'></i> {{get (get users.FEEDBACK 2) "BAD"}}
					  </span>
					</a>
				  {{else}}
					{{#if (get users.PTAKEN 2)}}
					  Нету
					{{else}}
					  Cвободно {{if game.PRICE4 (concat game.PRICE4 "р")}}
					{{/if}}
				  {{/if}}
				</td>
				<td>
				  {{#if (get users.USERS 1)}}
					{{#if (get (get users.PSTATUS 1) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 1) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				  {{#if (get users.USERS 2)}}
					{{#if (get (get users.PSTATUS 2) 0)}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 1)}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 2)}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
					{{#if (get (get users.PSTATUS 2) 3)}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
				  {{/if}}
				</td>
			  </tr>
			{{else}}
			  <tr><td>Пусто</td></tr>
			{{/each}}
		  </table>
		  {{/if}}
	
		{{/each}}
		{{/if}}
	
		</div>
	  {{/if}}

		<br>
			<div class='smaladndark tablq'>
			Пролистали до конца и не нашли нужной Вам игры?<br>
			Напишите об этом в <a href='/u/MrBug'>Личном Сообщении</a> и мы постараемся её добавить<br>
			Да и просто пишите игры, которые бы хотели видеть в совместной покупке :)
		</div>
	
	</div>
</template>
