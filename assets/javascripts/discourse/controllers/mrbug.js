import Controller from '@ember/controller'
import { action } from '@ember/object'
import { service } from '@ember/service'
import { tracked } from '@glimmer/tracking'
import { on } from '@ember/modifier'
import { each, if, concat } from '@ember/helper'
import LinkTo from '@ember/routing/link-to-component'

export default class MyController extends Controller {
	//gets current user?
	@service currentUser

	//default states
	// Tracked states for automatic template rerendering
	@tracked bagamdal = false
	@tracked mdalready = false
	@tracked prezaips = null
	@tracked pzposition = null
	@tracked zaips = null
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
		Object.assign(this, { bagamdal: false, mdalready: false, prezaips: null, zaips: null })
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
			
			await fetch("/MrBug/zaips/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({ bagatrolit: payload })
			})
			
			const response = await fetch('/MrBug.json')
			const result = await response.json()
			
			this.model = result // Mutating this automatically updates the glizt getter!
			this.mdalready = true
		} catch (error) {
			console.error("Failed to run imgoingin submission:", error)
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

}

<template>
  <div class="shinbakaz">
    <hr>
    <h1 class="razdelhe">Совместная покупка игр для PS4 / PS5</h1>
    <hr>

    <table class="bagahe">
      <tbody>
        <tr>
          <td>
            <span class="smaladndark tablq">организатор</span>
            <div class="headin"><LinkTo @route="user" @model="MrBug">MrBug</LinkTo></div>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <span class="smaladndark">
              Реквизиты на оплату можно получить через <LinkTo @route="user" @model="MrBug">Личные Сообщения</LinkTo>
            </span>
          </td>
        </tr>
      </tbody>
    </table>

    <br>
	
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
              <img src={{game.gPIC}} alt={{game.gNAME}}>
            </td>
            <td>
              П{{game.POSITION}}
            </td>
            <td>
              <a>{{game.gNAME}}</a>
              {{#if game.TYPE2}}
                <br><span class="smaladndark">Акция до: {{game.DATE}}</span>
              {{/if}}
              {{#if game.TYPE3}}
                <br><span class="smaladndark">Дата выхода: {{game.DATE}}</span>
              {{/if}}
            </td>
            <td>
              {{#if game.PRICE}}
                {{game.PRICE}}р
              {{else}}
                Цена неизвестна
              {{/if}}
            </td>
          </tr>
        {{/each}}
      </table>
      <div style="text-align: center"><span class="kawaiNO">Реквизиты на оплату получать в ЛС</span></div>
      <span class="smaladndark tablq">
        Сообщите об оплате в соответсвующей личке "Тройка собрана! Ждем оплату!"!<br>
        Если состав не собран и соотвествующей лички нету, сообщить об оплате можно мне через <LinkTo @route="user" @model="MrBug">Личное Сообщение</LinkTo><br>
        Выписаться из несобранного состава можно через неделю через <LinkTo @route="user" @model="MrBug">Личные Сообщения</LinkTo><br>
      </span>
      <hr>
    {{/if}}

    <br>

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
              <img src={{game.gPIC}} alt={{game.gNAME}}>
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
      <hr>
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
              <span>Запись возможна только через личное сообщение <LinkTo @route="user" @model="MrBug">Организатору</LinkTo></span>
            </div>
          {{/if}}

          {{#if this.prezaips.winrars}}
            <div class="mudalcontent headin3 prezaips">
              <div class="bagato">
                <div class="bagapi" style="background-image:url('{{this.prezaips.imgLINK}}')"></div>
                <h1><a>{{this.prezaips.gameNAME}}</a> Запись</h1>
              </div>
              <button type="button" {{on "click" this.imgoingin}}>Записаться на П{{this.pzposition}}</button>
              <button type="button" {{on "click" this.netmudal}}>Закрыть</button>
            </div>
          {{/if}}

		{{#if this.zaips.winrars}}
            <div class="mudalcontent mudaladdon headin3">
              <span>Запись</span>
              <span>на позицию П{{this.pzposition}}</span>
              <div class="bagariban">{{this.zaips.gameNAME}}</div>
              <span>Успешно произведена!</span>
            </div>
        {{/if}}

          {{#if this.zaips.zaipsfail}}
            <div class="mudalcontent headin3 prezaips">
              <div class="bagato">
                <div class="bagapi" style="background-image:url('https://imgur.com')">Epic Fail Is Epic</div>
              </div>
            </div>
          {{/if}}
        {{else}}
          <div class="bagaspin"></div>
        {{/if}}
      </div>
    {{/if}}

    {{! PRE-ORDERS / MAIN GAME DATABASE LOOP SECTION }}
    {{#if this.glizt.gamedb3}}
      <div class="ghed {{if this.showhideo.[2] '' 'slut'}}" {{on "click" (fn this.showhideo 2)}}><i class="fas fa-history"></i> Предзаказы <span class="smaladndark">Хотел купить, теперь не уверен</span></div>
      <div class="MrBug">
        {{#if this.showhideo.[2]}}
          {{#each this.glizt.gamedb3 as |game index|}}
            <table class="ggg {{if game.MODE1 'bgred2' (if game.MODE2 'bggr3')}}" {{on "click" (fn this.toggleGameVisibility "gamedb3" index)}}>
              <tr>
                <td class="flagco">{{#if game.MODE1}}<i class="fas fa-exclamation fa-2x fa-pulse"></i>{{/if}}<i title="{{game.STORE}} Store" class="flag {{game.STORE}}"></i></td>
                <td class="imgco"><img src={{game.imgLINK}} alt={{game.gameNAME}}></td>
                <td class="mainco">
                  <a>{{game.gameNAME}}</a><br>
                  <span class="text">Дата выхода {{game.DATE}}</span>
                  <span class="baga baga-{{game.CONSOLE}}">{{game.CONSOLE}}</span>
                  {{#if game.CONSOLE2}}
                    <span class="baga baga-{{game.CONSOLE2}}">{{game.CONSOLE2}}</span>
                  {{/if}}
                  <span class="smaladndark minihrenvnizu"> &gt;&gt; открыть составы &lt;&lt; </span>
                </td>
                <td>
                  <button type="button" {{on "click" (fn this.zaips "2" game._id)}} class="BagButon">П2<br>
                    {{#if game.PRICE2}}
                      <h3>{{game.PRICE2}}</h3><br>рублей
                    {{else}}
                      <h3>НЕТ</h3><br>цены
                    {{/if}}
                    {{#if game.P2NO}}<div class="statustr status-1">{{game.P2NO}}</div>{{/if}}
                  </button>
                </td>
                <td>
                  <button type="button" {{on "click" (fn this.zaips "4" game._id)}} class="BagButon">П4<br>
                    {{#if game.PRICE4}}
                      <h3>{{game.PRICE4}}</h3><br>рублей
                    {{else}}
                      <h3>НЕТ</h3><br>цены
                    {{/if}}
                    {{#if game.P4NO}}<div class="statustr status-1">{{game.P4NO}}</div>{{/if}}
                  </button>
                </td>
              </tr>
            </table>

            {{! NESTED ROSTER USERS DRAWER PANEL }}
            {{#if game.SHOWHIDEO}}
              <table class="djuke">
                {{#each game.TROIKI as |users|}}
                  <tr class={{if users.MODE1 "bgred2" (if users.MODE2 "bggr3")}}>
                    <td></td>
                    <td colspan="2">П2</td>
                    <td colspan="2">П4</td>
                  </tr>				
                  <tr class={{if users.MODE1 "bgred2" (if users.MODE2 "bggr3")}}>
                    <td>
                      {{#if users.ACCOUNT}}{{users.ACCOUNT}}{{/if}}
                    </td>
                    <td>
                      {{#if users.USERS.[0]}}
                        <LinkTo @route="user" @model={{users.USERS.[0]}} title={{if game.PRICE2 (concat game.PRICE2 "р") ""}}>{{users.USERS.[0]}}</LinkTo>
                        <LinkTo @route="user.kek" @model={{users.USERS.[0]}} class="repala {{if users.PFBred.[0] 'bgred' 'bggr2'}}">
                          {{users.FEEDBACK.[0].PERCENT}}%
                          <span>
                            <i class="far fa-smile"></i> {{users.FEEDBACK.[0].GOOD}} 
                            <i class="far fa-meh"></i> {{users.FEEDBACK.[0].NEUTRAL}} 
                            <i class="far fa-frown"></i> {{users.FEEDBACK.[0].BAD}}
                          </span>
                        </LinkTo>
                      {{else}}
                        {{#if users.PTAKEN.[0]}}
                          Нету
                        {{else}}
                          Cвободно {{if game.PRICE2 (concat game.PRICE2 "р") ""}}
                        {{/if}}
                      {{/if}}
                    </td>
                    <td>
                      {{#if users.USERS.[0]}}
                        {{#if users.PSTATUS.[0].[0]}}<div class="malabela bgred3"><span>ждем оплату</span></div>{{/if}}
                        {{#if users.PSTATUS.[0].[1]}}<div class="malabela bggr"><span>оплатил</span></div>{{/if}}
                        {{#if users.PSTATUS.[0].[2]}}<div class="malabela bgred"><span>получил данные</span></div>{{/if}}
                        {{#if users.PSTATUS.[0].[3]}}<div class="malabela bggr"><span>скачал</span></div>{{/if}}
                      {{/if}}
                    </td>
                    <td>
                      {{#if users.USERS.[1]}}
                        <LinkTo @route="user" @model={{users.USERS.[1]}} title={{if game.PRICE4 (concat game.PRICE4 "р") ""}}>{{users.USERS.[1]}}</LinkTo>
                        <LinkTo @route="user.kek" @model={{users.USERS.[1]}} class="repala {{if users.PFBred.[1] 'bgred' 'bggr2'}}">
                          {{users.FEEDBACK.[1].PERCENT}}%
                          <span>
                            <i class="far fa-smile"></i> {{users.FEEDBACK.[1].GOOD}} 
                            <i class="far fa-meh"></i> {{users.FEEDBACK.[1].NEUTRAL}} 
                            <i class="far fa-frown"></i> {{users.FEEDBACK.[1].BAD}}
                          </span>
                        </LinkTo>
                      {{else}}
                        {{#if users.PTAKEN.[1]}}
                          Нету
                        {{else}}
                          Cвободно {{if game.PRICE4 (concat game.PRICE4 "р") ""}}
                        {{/if}}
                      {{/if}}
                      <br>
                      {{#if users.USERS.[2]}}
                        <LinkTo @route="user" @model={{users.USERS.[2]}} title={{if game.PRICE4 (concat game.PRICE4 "р") ""}}>{{users.USERS.[2]}}</LinkTo>
                        <LinkTo @route="user.kek" @model={{users.USERS.[2]}} class="repala {{if users.PFBred.[2] 'bgred' 'bggr2'}}">
                          {{users.FEEDBACK.[2].PERCENT}}%
                          <span>
                            <i class="far fa-smile"></i> {{users.FEEDBACK.[2].GOOD}} 
                            <i class="far fa-meh'></i> {{users.FEEDBACK.[2].NEUTRAL}} 
                            <i class="far fa-frown"></i> {{users.FEEDBACK.[2].BAD}}
                          </span>
                        </LinkTo>
                      {{else}}
                        {{#if users.PTAKEN.[2]}}
                          Нету
                        {{else}}
                          Cвободно {{if game.PRICE4 (concat game.PRICE4 "р") ""}}
                        {{/if}}
                      {{/if}}
                    </td>
                    <td>
                      {{#if users.USERS.[1]}}
                        {{#if users.PSTATUS.[1].[0]}}<div class="malabela bgred3"><span>ждем оплату</span></div>{{/if}}
                        {{#if users.PSTATUS.[1].[1]}}<div class="malabela bggr"><span>оплатил</span></div>{{/if}}
                        {{#if users.PSTATUS.[1].[2]}}<div class="malabela bgred"><span>получил данные</span></div>{{/if}}
                        {{#if users.PSTATUS.[1].[3]}}<div class="malabela bggr"><span>скачал</span></div>{{/if}}
                      {{/if}}
                      {{#if users.USERS.[2]}}
                        {{#if users.PSTATUS.[2].[0]}}<div class="malabela bgred3"><span>ждем оплату</span></div>{{/if}}
                        {{#if users.PSTATUS.[2].[1]}}<div class="malabela bggr"><span>оплатил</span></div>{{/if}}
                        {{#if users.PSTATUS.[2].[2]}}<div class="malabela bgred"><span>получил данные</span></div>{{/if}}
                        {{#if users.PSTATUS.[2].[3]}}<div class="malabela bggr"><span>скачал</span></div>{{/if}}
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
    <div class="smaladndark tablq">
      Пролистали до конца и не нашли нужной Вам игры?<br>
      Напишите об этом в <LinkTo @route="user" @model="MrBug">Личном Сообщении</LinkTo> и мы постараемся её добавить<br>
      Да и просто пишите игры, которые бы хотели видеть в совместной покупке :)
    </div>
  </div>
</template>
