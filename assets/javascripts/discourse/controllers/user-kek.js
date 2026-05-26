import Controller from '@ember/controller'
import { action } from '@ember/object'
import { service } from '@ember/service'
import { tracked } from '@glimmer/tracking'
import { on } from "@ember/modifier";
import { fn, get } from "@ember/helper";
import { Input } from "@ember/component";

export default class MyController extends Controller {
	@service currentUser
	// UI state variables tracking checkboxes, modal boxes, and loading spinners
	@tracked checked1 = true
	@tracked checked2 = false
	@tracked checked3 = false
	@tracked score = 1
	@tracked ozmode = true
	@tracked troikopoisk = null
	@tracked responz = null
	
	@tracked otzivmdal = false
	@tracked otzivsmall = false
	@tracked otzivbig = false
	
	@tracked accamdal = false
	@tracked accawait = false
	@tracked passwait = false
	@tracked actualgp = false
	@tracked pisanina = null

	get fEEDBACKS() {
		const finalvar = { fb1: [], fb2: [] }
		const newfbarray = []
		const currentuser = this.currentUser?.username
		let fbedit = false

		// [...array] safely clones the data so .reverse() doesn't modify the source model
		const rawFeedbacks = this.model?.FEEDBACKS ? [...this.model.FEEDBACKS] : []
		//loop throug fb and set its color for template, also find last editable fb
		rawFeedbacks.reverse().forEach((item) => {
			if (item.SCORE > 0) item.COLOR = 'zeG'
			if (item.SCORE < 0) item.COLOR = 'zeB'
			if (item.SCORE === 0) item.COLOR = 'zeN'

			newfbarray.push({
				FEEDBACK: item.FEEDBACK, pNAME: item.pNAME,
				DATE: item.DATE, COLOR: item.COLOR
			})
			//onetime check for users last feedback to flag it as editable
		    if (!fbedit && currentuser && item.pNAME === currentuser) { 
				newfbarray[newfbarray.length - 1].eDit = true; fbedit = true
		    }
		})
		//save final variable
		// Inline conditional: extracts 11 elements if MENOSHO is true, otherwise extracts 12
    	finalvar.fb1 = newfbarray.splice(0, this.model?.MENOSHO ? 11 : 12)

		// Dynamically chunks all remaining feedbacks into blocks of 12 for page 2+
		while (newfbarray.length > 0) {
			finalvar.fb2.push(newfbarray.splice(0, 12))
		}

		return finalvar
	}

	// Boolean check: returns true if there is a second page of feedbacks to display
	get mORE() {
		return this.fEEDBACKS.fb2.length > 0
	}

	@action
	addOtziv() {
		// Object.assign resets multiple trackable states at once on a single line
		Object.assign(this, { responz: null, otzivmdal: true, ozmode: true, pisanina: null })
	}
	
	@action
	editOtziv(fb) {
		// Toggles the modal into edit-mode and prefills it with the clicked feedback text
		Object.assign(this, { responz: null, otzivmdal: true, ozmode: false, pisanina: fb })
	}
	
	@action
	respCLOZ() {
		// Closes small/big length error validation notifications
		Object.assign(this, { responz: null, otzivsmall: false, otzivbig: false })
	}
	
	@action
	showMORZ() {
		// Unpacks exactly the first 12-item chunk from page 2 into page 1
		this.fEEDBACKS.fb1.push(...this.fEEDBACKS.fb2[0])
		
		this.fEEDBACKS.fb2.shift() // Deletes the chunk we just moved out
		this.model = { ...this.model } // Alerts Ember to redraw the page
	}

	@action
	async OtzivZaips(event) {
		event?.preventDefault()

		const fbLength = this.pisanina?.length || 0
		if (fbLength < 20) return this.otzivsmall = true
		if (fbLength > 200) return this.otzivbig = true
		// do stuff of all ok
		Object.assign(this, { otzivmdal: false, otzivsmall: false, otzivbig: false })

		try {
			const payload = btoa(unescape(encodeURIComponent(`${this.ozmode}~${this.score}~${this.pisanina}`)))
			const response = await fetch(`/u/${this.model?.uZar}/kek`, {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({ fedbakibaki: payload })
			})
			const result = await response.json()
			this.responz = result

			// Executes if creating a brand new feedback submission was successful
			if (result.winrars_z) {
				//draw this new fb on a page
				//find fb color first and increase corresponding fb number
				let color = 'zeN'
				
				// Flat, classic if/else statements for model tracking updates
				if (this.score > 0) {
					color = 'zeG'
					this.model.fbG = (this.model.fbG) + 1
				} else if (this.score === 0) {
					color = 'zeN'
					this.model.fbN = (this.model.fbN) + 1
				} else if (this.score < 0) {
					color = 'zeB'
					this.model.fbB = (this.model.fbB) + 1
				}
				
				//remove edit tag from now not last feedback
				const ni = this.fEEDBACKS.fb1.findIndex(it => it.pNAME === this.currentUser.username)
				if (ni >= 0) this.fEEDBACKS.fb1[ni].eDit = false
				
				// Unshifts inserts the new feedback live right at the top of the timeline
				this.fEEDBACKS.fb1.unshift({
					pNAME: this.currentUser.username,
					FEEDBACK: this.pisanina,
					DATE: new Date().toISOString().slice(0, 10).replace(/-/g, '.'), // Fast native YYYY.MM.DD string format
					COLOR: color,
					eDit: true
				})
				this.model = { ...this.model } // Wake up Ember template tracking
			}
			
			// Executes if updating an existing feedback was successful
			if (result.winrars_e) {
				//find last feedback
				const ni = this.fEEDBACKS.fb1.findIndex(it => it.pNAME === this.currentUser.username)
				if (ni >= 0) {
					//edit it
					this.fEEDBACKS.fb1[ni].FEEDBACK = this.pisanina
					
					if (this.score > 0) this.fEEDBACKS.fb1[ni].COLOR = 'zeG'
					if (this.score < 0) this.fEEDBACKS.fb1[ni].COLOR = 'zeB'
					if (this.score === 0) this.fEEDBACKS.fb1[ni].COLOR = 'zeN'
				}
				this.model = { ...this.model } // Wake up Ember template tracking
			}
			
			Object.assign(this, { checked1: true, checked2: false, checked3: false, score: 1, pisanina: null })
			
		} catch (error) {
			console.error("Network call execution failed:", error)
		}
	}

	@action
	selectOtz(input) {
		//set variable checked1 2 3 to true and false, for corresponding input
		this.checked1 = input === 1
		this.checked2 = input === 2
		this.checked3 = input === 3
		
		if (input === 1) this.score = 1
		if (input === 2) this.score = 0
		if (input === 3) this.score = -1
	}

	@action
	async troikopoisk(poisk, acc) {
		Object.assign(this, { accamdal: true, accawait: true, actualgp: false })
		try {
			const response = await fetch("/MrBug/troikopoisk/", {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({
					poisk: btoa(unescape(encodeURIComponent(poisk))),
					acc: btoa(unescape(encodeURIComponent(acc)))
				})
			})
			this.troikopoisk = await response.json()
			this.accawait = false
		} catch (error) {
			console.error("Troikopoisk submission failed:", error)
		}
	}
	
	@action
	async getPaZZ(input) {
		this.passwait = true
		try {
			const response = await fetch(`/u/${this.currentUser?.username}/kek/oishiiii`, {
				method: 'POST',
				headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
				body: new URLSearchParams({ myylo: btoa(unescape(encodeURIComponent(input))) })
			})
			this.actualgp = await response.json()
			this.passwait = false
		} catch (error) {
			console.error("getPaZZ transaction failed:", error)
		}
	}

	<template>
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
        <div
          style="background-image:url('https://i.imgur.com/33FJekg.png'); width: 100%; height: 800px;"
        >
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
                <button
                  class="ediZ"
                  type="button"
                  {{on "click" (fn this.editOtziv feedback.FEEDBACK)}}
                >
                  Изменить отзыв
                </button>
              {{/if}}
            </div>
          {{/each}}

          {{#if this.mORE}}
            <button class="morZ" type="button" {{on "click" this.showMORZ}}>
              ещё
            </button>
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
              <button
                class="findZ"
                type="button"
                {{on "click" (fn this.runTroikopoisk gamez.gNAMEid gamez.aCC)}}
              ></button>
            </div>
          {{/each}}
          <span class="minihrenvnizu">
            кто владелец? я владелец! он владелец? жми на аккаунт!? узнай
            владельцев!
          </span>
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
                      <button
                        class="buttZ"
                        type="button"
                        {{on "click" (fn this.getPaZZ this.troikopoisk._id)}}
                      >
                        &#215; получить пароль &#215;
                      </button>
                    {{/if}}
                  {{else}}
                    {{#if this.actualgp.winrar}}
                      {{{this.actualgp.winrar}}}
                    {{/if}}
                    {{#if this.actualgp.spam}}
                      Бот выдает только <b>два</b> пароля в день, других сегодня
                      небудет
                    {{/if}}
                    {{#if this.actualgp.noconnect}}
                      Бот не отвечает: {{this.actualgp.status}}
                    {{/if}}
                    {{#if this.actualgp.error}}
                      Бот сломался и словил ошибку: {{this.actualgp.status}}
                    {{/if}}
                    {{#if this.actualgp.noufb}}
                      Бот не работать без отзывов от организатора
                    {{/if}}
                    {{#if this.actualgp.banned}}
                      Бот не работать когда бан
                    {{/if}}
                  {{/unless}}
                </div>
              {{/unless}}

              <div class="keklist gamZ">
                <div class="kekus zeZ" style="width: 100%">
                  <div style="text-align: center">{{this.troikopoisk.GAME}}</div>
                </div>

                {{#if (get this.troikopoisk.P2 1)}}
                  <div class="kekus zeZ">
                    <div><a>П2 PS4</a></div>
                    <div>
                      <a href="/u/{{get this.troikopoisk.P2 0}}">
                        {{get this.troikopoisk.P2 0}}
                      </a>
                    </div>
                  </div>
                  <div class="kekus zeZ">
                    <div><a>П4 PS4</a></div>
                    <div>
                      <a href="/u/{{get this.troikopoisk.P4 0}}">
                        {{get this.troikopoisk.P4 0}}
                      </a>
                    </div>
                  </div>
                  <div class="kekus zeZ">
                    <div><a>П4 PS4</a></div>
                    <div>
                      <a href="/u/{{get this.troikopoisk.P4 1}}">
                        {{get this.troikopoisk.P4 1}}
                      </a>
                    </div>
                  </div>

                  <div class="kekus zeZ">
                    <div><a>П2 PS5</a></div>
                    <div>
                      <a href="/u/{{get this.troikopoisk.P2 1}}">
                        {{get this.troikopoisk.P2 1}}
                      </a>
                    </div>
                  </div>
                  <div class="kekus zeZ">
                    <div><a>П4 PS5</a></div>
                    <div>
                      <a href="/u/{{get this.troikopoisk.P4 2}}">
                        {{get this.troikopoisk.P4 2}}
                      </a>
                    </div>
                  </div>
                  <div class="kekus zeZ">
                    <div><a>П4 PS5</a></div>
                    <div>
                      <a href="/u/{{get this.troikopoisk.P4 3}}">
                        {{get this.troikopoisk.P4 3}}
                      </a>
                    </div>
                  </div>
                {{else}}
                  {{#if (get this.troikopoisk.P4 3)}}
                    <div class="kekus zeZ">
                      <div><a>П2</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P2 0}}">
                          {{get this.troikopoisk.P2 0}}
                        </a>
                      </div>
                    </div>
                    <div class="kekus zeZ">
                      <div><a>П4 PS4</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P4 0}}">
                          {{get this.troikopoisk.P4 0}}
                        </a>
                      </div>
                    </div>
                    <div class="kekus zeZ">
                      <div><a>П4 PS4</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P4 1}}">
                          {{get this.troikopoisk.P4 1}}
                        </a>
                      </div>
                    </div>
                    <div class="kekus zeZ">
                      <div><a>П4 PS5</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P4 2}}">
                          {{get this.troikopoisk.P4 2}}
                        </a>
                      </div>
                    </div>
                    <div class="kekus zeZ">
                      <div><a>П4 PS5</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P4 3}}">
                          {{get this.troikopoisk.P4 3}}
                        </a>
                      </div>
                    </div>
                  {{else}}
                    <div class="kekus zeZ">
                      <div><a>П2</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P2 0}}">
                          {{get this.troikopoisk.P2 0}}
                        </a>
                      </div>
                    </div>
                    <div class="kekus zeZ">
                      <div><a>П4</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P4 0}}">
                          {{get this.troikopoisk.P4 0}}
                        </a>
                      </div>
                    </div>
                    <div class="kekus zeZ">
                      <div><a>П4</a></div>
                      <div>
                        <a href="/u/{{get this.troikopoisk.P4 1}}">
                          {{get this.troikopoisk.P4 1}}
                        </a>
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

}
