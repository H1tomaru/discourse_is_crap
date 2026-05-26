import { fn, concat, get } from "@ember/helper";
import { on } from "@ember/modifier";

export default <template>
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
              <img src={{game.gPIC}} alt={{game.gNAME}} />
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
              <td>{{game.PRICE}}р</td>
            {{else}}
              <td>Цена неизвестна</td>
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
              <img src={{game.gPIC}} alt={{game.gNAME}} />
            </td>

            <td>П{{game.POSITION}}</td>

            <td><a>{{game.gNAME}}</a></td>
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
          <button class="netmudal" {{on "click" this.netmudal}}></button>

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
                <div class="bagapi" style={{concat "background-image:url('" this.prezaips.imgLINK "')"}}></div>
                <h1><a>{{this.prezaips.gameNAME}}</a> Запись</h1>
              </div>
              <button {{on "click" this.imgoingin}}>Записаться на П{{this.pzposition}}</button>
              <button {{on "click" this.netmudal}}>Закрыть</button>
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
                <div class="bagapi" style="background-image:url('https://i.imgur.com/33FJekg.png')">
                  Epic Fail Is Epic
                </div>
              </div>
            </div>
          {{/if}}
        {{else}}
          <div class="bagaspin"></div>
        {{/if}}
      </div>
    {{/if}}

    {{#if this.glizt.gamedb1}}
      <div
        class={{concat "ghed " (unless (get this.showhideo 0) "slut")}}
        {{on "click" (fn this.showhideo 0)}}
      >
        <i class="fas fa-users"></i>
        Просто Игры
        <span class="smaladndark">Ждут своих героев</span>
      </div>

      <div class="MrBug">
        {{#if (get this.showhideo 0)}}
          {{#each this.glizt.gamedb1 as |game index|}}
            <table
              class={{concat "ggg " (if game.MODE1 "bgred2") (if game.MODE2 "bggr3")}}
              {{on "click" (fn this.showhideo1 index)}}
            >
              <tr>
                <td class="flagco">
                  {{#if game.MODE1}}
                    <i class="fas fa-exclamation fa-2x fa-pulse"></i>
                  {{/if}}
                  <i title={{concat game.STORE " Store"}} class={{concat "flag " game.STORE}}></i>
                </td>

                <td class="imgco"><img src={{game.imgLINK}} alt={{game.gameNAME}} /></td>

                <td class="mainco">
                  <a>{{game.gameNAME}}</a><br />
                  <span class={{concat "baga baga-" game.CONSOLE}}>{{game.CONSOLE}}</span>
                  <span class="smaladndark minihrenvnizu"> &gt;&gt; открыть составы &lt;&lt; </span>
                </td>

                <td>
                  <button
                    class="BagButon"
                    {{on "click" (fn this.zaips "2" game._id)}}
                  >
                    П2<br />
                    {{#if game.PRICE2}}
                      <h3>{{game.PRICE2}}</h3><br />рублей
                    {{else}}
                      <h3>НЕТ</h3><br />цены
                    {{/if}}
                    {{#if game.P2NO}}<div class="statustr status-1">{{game.P2NO}}</div>{{/if}}
                  </button>
                </td>

                <td>
                  <button
                    class="BagButon"
                    {{on "click" (fn this.zaips "4" game._id)}}
                  >
                    П4<br />
                    {{#if game.PRICE4}}
                      <h3>{{game.PRICE4}}</h3><br />рублей
                    {{else}}
                      <h3>НЕТ</h3><br />цены
                    {{/if}}
                    {{#if game.P4NO}}<div class="statustr status-1">{{game.P4NO}}</div>{{/if}}
                  </button>
                </td>
              </tr>
            </table>

            {{#if game.SHOWHIDEO}}
              <table class="djuke">
                {{#each game.TROIKI as |users|}}
                  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
                    <td></td>
                    <td colspan="2">П2</td>
                    <td colspan="2">П4</td>
                  </tr>

                  <tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
                    <td>
                      {{#if users.ACCOUNT}}{{users.ACCOUNT}}{{/if}}
                    </td>

                    <td>
                      {{#if users.USERS.[0]}}
                        <a title={{if game.PRICE2 (concat game.PRICE2 "р")}} href={{concat "/u/" users.USERS.[0]}}>
                          {{users.USERS.[0]}}
                        </a>
                        <a
                          class={{concat "repala " (if users.PFBred.[1] "bgred" "bggr2")}}
                          href={{concat "/u/" users.USERS.[0] "/kek"}}
                        >
                          {{users.FEEDBACK.[0].PERCENT}}%
                          <span>
                            <i class="far fa-smile"></i> {{users.FEEDBACK.[0].GOOD}}
                            <i class="far fa-meh"></i> {{users.FEEDBACK.[0].NEUTRAL}}
                            <i class="far fa-frown"></i> {{users.FEEDBACK.[0].BAD}}
                          </span>
                        </a>
                      {{else}}
                        {{#if users.PTAKEN.[0]}}
                          Нету
                        {{else}}
                          Cвободно {{if game.PRICE2 (concat game.PRICE2 "р")}}
                        {{/if}}
                      {{/if}}
                    </td>

                    ...
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

    <br />
    <div class="smaladndark tablq">
      Пролистали до конца и не нашли нужной Вам игры?<br />
      Напишите об этом в <a href="/u/MrBug">Личном Сообщении</a> и мы постараемся её добавить<br />
      Да и просто пишите игры, которые бы хотели видеть в совместной покупке :)
    </div>
  </div>
</template>
