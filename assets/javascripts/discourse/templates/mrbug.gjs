import { on } from "@ember/modifier"
import { fn, get } from "@ember/helper"

export default <template>

	<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.5.0/css/all.css" integrity="sha384-B4dIYHKNBt8Bc12p+WXckhzcICo0wtJAoU8YZTY5qE0Id1GSseTk6S+L3BlXeVIU" crossorigin="anonymous" />

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
			</tbody>
		</table>
	
		<br />
	
		{{#if @controller.glizt.maigamez1}}
			<div class="ghead red"><h2>ЖДЕМ ОПЛАТУ</h2></div>

			<table class="atats kadu">

					<colgroup>
						<col width="70px" />
						<col width="30px" />
						<col width="100%" />
						<col width="0" />
						<col width="50px" />
					</colgroup>

				{{#each @controller.glizt.maigamez1 as |game|}}
					<tr>
						<td>
							<img src="{{game.gPIC}}" alt="{{game.gNAME}}" />
						</td>

						<td>
							П{{game.POSITION}}
						</td>

						<td>
							<a>{{game.gNAME}}</a>
							{{#if game.TYPE2}}<br /><span class="smaladndark">Акция до: {{game.DATE}}</span>{{/if}}
							{{#if game.TYPE3}}<br /><span class="smaladndark">Дата выхода: {{game.DATE}}</span>{{/if}}
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
	
		{{#if @controller.glizt.maigamez2}}
			<div class="ghead green"><h2>ОПЛАЧЕНО</h2></div>

			<table class="atats udak">
				<colgroup>
					<col width="70px" />
					<col width="30px" />
					<col width="100%" />
				</colgroup>

				{{#each @controller.glizt.maigamez2 as |game|}}
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
	
		{{#if @controller.bagamdal}}
			<div class="etomudal">
			
				{{#if @controller.mdalready}}
				
					<button class="netmudal" type="button" {{on "click" @controller.netmudal}}></button>
					
					{{#if @controller.prezaips.guest}}
						<div class="mudalcontent mudaladdon headin3">
							<div class="bagariban">ВНИМАНИЕ</div>
							<span>Для участия в совместной покупке игр требуется <a href="/signup">Регистрация</a></span>
						</div>
					{{/if}}
					
					{{#if @controller.prezaips.banned}}
						<div class="mudalcontent mudaladdon headin3">
							<div class="bagariban">ВНИМАНИЕ</div>
							<span>Запись возможна только через личное сообщение <a href="/u/MrBug">Организатору</a></span>
						</div>
					{{/if}}
					
					{{#if @controller.prezaips.winrars}}
						<div class="mudalcontent headin3 prezaips">
							<div class="bagato">
								<div class="bagapi" style="background-image:url('{{@controller.prezaips.imgLINK}}')"></div>
								<h1><a>{{@controller.prezaips.gameNAME}}</a> Запись</h1>
							</div>
							<button type="button" {{on "click" @controller.imgoingin}}>Записаться на П{{@controller.pzposition}}</button><button type="button" {{on "click" @controller.netmudal}}>Закрыть</button>
						</div>
					{{/if}}
					
					{{#if @controller.zaipsResult.winrars}}
						<div class="mudalcontent mudaladdon headin3">
							<span>Запись</span>
							<span>на позицию П{{@controller.pzposition}}</span>
							<div class="bagariban">{{@controller.zaipsResult.gameNAME}}</div>
							<span>Успешно произведена!</span>
						</div>
					{{/if}}
					
					{{#if @controller.zaipsResult.zaipsfail}}
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

		{{#if @controller.glizt.gamedb1}}
			<div class='ghed {{unless @controller.hideostates.[0] "slut"}}' {{on "click" (fn @controller.showhideo 0)}}><i class='fas fa-users'></i> Просто Игры <span class='smaladndark'>Ждут своих героев</span></div>
			<div class='MrBug'>

				{{#if @controller.hideostates.[0]}}
					{{#each @controller.glizt.gamedb1 as |game index|}}
					
						<table class='ggg {{if game.MODE1 "bgred2"}} {{if game.MODE2 "bggr3"}}' {{on "click" (fn @controller.showhideo1 index)}}>
							<tr>
								{{! PreButtonsGame }}
								<td class='flagco'>
									{{#if game.MODE1}}<i class='fas fa-exclamation fa-2x fa-pulse'></i>{{/if}}
									<i title='{{game.STORE}} Store' class='flag {{game.STORE}}'></i>
								</td>
								<td class='imgco'><img src='{{game.imgLINK}}' alt='{{game.gameNAME}}' /></td>
					
								<td class='mainco'>
									<a>{{game.gameNAME}}</a><br />
									<span class='baga baga-{{game.CONSOLE}}'>{{game.CONSOLE}}</span>
									<span class='smaladndark minihrenvnizu'> &gt;&gt; открыть составы &lt;&lt; </span>
								</td>
								{{! PreButtonsGame }}
								{{! Buttons244 }}
								<td>
									<button type="button" {{on "click" (fn @controller.zaips2 game._id)}} class='BagButon'>П2<br />
										{{#if game.PRICE2}}
											<h3>{{game.PRICE2}}</h3><br />рублей
										{{else}}
											<h3>НЕТ</h3><br />цены
										{{/if}}
										{{#if game.P2NO}}<div class='statustr status-1'>{{game.P2NO}}</div>{{/if}}
									</button>
								</td>
								<td>
									<button type="button" {{on "click" (fn @controller.zaips4 game._id)}} class='BagButon'>П4<br />
										{{#if game.PRICE4}}
											<h3>{{game.PRICE4}}</h3><br />рублей
										{{else}}
											<h3>НЕТ</h3><br />цены
										{{/if}}
										{{#if game.P4NO}}<div class='statustr status-1'>{{game.P4NO}}</div>{{/if}}
									</button>
								</td>
								{{! Buttons244 }}
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
											{{if users.ACCOUNT users.ACCOUNT}}
										</td>
										<td>
											{{#if users.USERS.[0]}}
												<a title="{{if game.PRICE2 game.PRICE2}}р" href='/u/{{users.USERS.[0]}}'>{{users.USERS.[0]}}</a>
												<a class='repala {{if users.PFBred.[1] "bgred" "bggr2"}}' href='/u/{{users.USERS.[0]}}/kek'>
													{{users.FEEDBACK.[0].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[0].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[0].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[0].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[0]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE2 game.PRICE2}}р
												{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[0]}}
												{{#if users.PSTATUS.[0].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[1]}}
												<a title="{{if game.PRICE4 game.PRICE4}}р" href="/u/{{users.USERS.[1]}}">{{users.USERS.[1]}}</a>
												<a class='repala {{if users.PFBred.[1] "bgred" "bggr2"}}' href='/u/{{users.USERS.[1]}}/kek'>
													{{users.FEEDBACK.[1].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[1].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[1].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[1].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[1]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE4 game.PRICE4}}р
												{{/if}}
											{{/if}}
											<br />
											{{#if users.USERS.[2]}}
												<a title="{{if game.PRICE4 game.PRICE4}}р" href="/u/{{users.USERS.[2]}}">{{users.USERS.[2]}}</a>
												<a class='repala {{if users.PFBred.[2] "bgred" "bggr2"}}' href='/u/{{users.USERS.[2]}}/kek'>
													{{users.FEEDBACK.[2].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[2].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[2].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[2].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[2]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE4 game.PRICE4}}р
												{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[1]}}
												{{#if users.PSTATUS.[1].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
											{{/if}}
											{{#if users.USERS.[2]}}
												{{#if users.PSTATUS.[2].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
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

		{{#if @controller.glizt.gamedb2}}
			<div class='ghed {{unless @controller.hideostates.[1] "slut"}}' {{on "click" (fn @controller.showhideo 1)}}><i class='fas fa-tags'></i> Распродажи <span class='smaladndark'>Самые (о)х#$@&%*ые! скидки в PSN</span></div>
			<div class='MrBug'>

				{{#if @controller.hideostates.[1]}}
					{{#each @controller.glizt.gamedb2 as |game index|}}
					
						<table class='ggg {{if game.MODE1 "bgred2"}} {{if game.MODE2 "bggr3"}}' {{on "click" (fn @controller.showhideo2 index)}}>
							<tr>
								{{! PreButtonsGame }}
								<td class='flagco'>
									{{#if game.MODE1}}<i class='fas fa-exclamation fa-2x fa-pulse'></i>{{/if}}
									<i title='{{game.STORE}} Store' class='flag {{game.STORE}}'></i>
								</td>
								<td class='imgco'><img src='{{game.imgLINK}}' alt='{{game.gameNAME}}' /></td>
								<td class='mainco'>
									<a>{{game.gameNAME}}</a><br />
									<span class='text'>Акция до {{game.DATE}}</span>
									<span class='baga baga-{{game.CONSOLE}}'>{{game.CONSOLE}}</span>
									<span class='smaladndark minihrenvnizu'> &gt;&gt; открыть составы &lt;&lt; </span>
								</td>
								{{! PreButtonsGame }}
								{{! Buttons244 }}
								<td>
									<button type="button" {{on "click" (fn @controller.zaips2 game._id)}} class='BagButon'>П2<br />
										{{#if game.PRICE2}}
											<h3>{{game.PRICE2}}</h3><br />рублей
										{{else}}
											<h3>НЕТ</h3><br />цены
										{{/if}}
										{{#if game.P2NO}}<div class='statustr status-1'>{{game.P2NO}}</div>{{/if}}
									</button>
								</td>
								<td>
									<button type="button" {{on "click" (fn @controller.zaips4 game._id)}} class='BagButon'>П4<br />
										{{#if game.PRICE4}}
											<h3>{{game.PRICE4}}</h3><br />рублей
										{{else}}
											<h3>НЕТ</h3><br />цены
										{{/if}}
										{{#if game.P4NO}}<div class='statustr status-1'>{{game.P4NO}}</div>{{/if}}
									</button>
								</td>
								{{! Buttons244 }}
							</tr>
						</table>
						
						{{#if (get @controller.showhideo2 index)}}
							<table class="djuke">
								{{#each game.TROIKI as |users|}}
									<tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
										<td></td>
										<td colspan='2'>П2</td>
										<td colspan='2'>П4</td>
									</tr>
									<tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
										<td>
											{{if users.ACCOUNT users.ACCOUNT}}
										</td>
										<td>
											{{#if users.USERS.[0]}}
												<a title="{{if game.PRICE2 game.PRICE2}}р" href="/u/{{users.USERS.[0]}}">{{users.USERS.[0]}}</a>
												<a class='repala {{if users.PFBred.[1] "bgred" "bggr2"}}' href='/u/{{users.USERS.[0]}}/kek'>
													{{users.FEEDBACK.[0].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[0].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[0].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[0].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[0]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE2 game.PRICE2}}р
												{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[0]}}
												{{#if users.PSTATUS.[0].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[1]}}
												<a title="{{if game.PRICE4 game.PRICE4}}р" href="/u/{{users.USERS.[1]}}">{{users.USERS.[1]}}</a>
												<a class='repala {{if users.PFBred.[1] "bgred" "bggr2"}}' href='/u/{{users.USERS.[1]}}/kek'>
													{{users.FEEDBACK.[1].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[1].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[1].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[1].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[1]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE4 game.PRICE4}}р
												{{/if}}
											{{/if}}
											<br />
											{{#if users.USERS.[2]}}
												<a title="{{if game.PRICE4 game.PRICE4}}р" href="/u/{{users.USERS.[2]}}">{{users.USERS.[2]}}</a>
												<a class='repala {{if users.PFBred.[2] "bgred" "bggr2"}}' href='/u/{{users.USERS.[2]}}/kek'>
													{{users.FEEDBACK.[2].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[2].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[2].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[2].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[2]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE4 game.PRICE4}}р
												{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[1]}}
												{{#if users.PSTATUS.[1].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
											{{/if}}
											{{#if users.USERS.[2]}}
												{{#if users.PSTATUS.[2].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
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
	
		{{#if @controller.glizt.gamedb3}}
			<div class='ghed {{unless @controller.hideostates.[2] "slut"}}' {{on "click" (fn @controller.showhideo 2)}}><i class='fas fa-history'></i> Предзаказы <span class='smaladndark'>Хотел купить, теперь не уверен</span></div>
			<div class='MrBug'>
				
				{{#if @controller.hideostates.[2]}}
					{{#each @controller.glizt.gamedb3 as |game index|}}
						
						<table class='ggg {{if game.MODE1 "bgred2"}} {{if game.MODE2 "bggr3"}}' {{on "click" (fn @controller.showhideo3 index)}}>
							<tr>
								{{! PreButtonsGame }}
								<td class='flagco'>
									{{#if game.MODE1}}<i class='fas fa-exclamation fa-2x fa-pulse'></i>{{/if}}
									<i title='{{game.STORE}} Store' class='flag {{game.STORE}}'></i>
								</td>
								<td class='imgco'><img src='{{game.imgLINK}}' alt='{{game.gameNAME}}' /></td>
								<td class='mainco'>
									<a>{{game.gameNAME}}</a><br />
									<span class='text'>Дата выхода {{game.DATE}}</span>
									<span class='baga baga-{{game.CONSOLE}}'>{{game.CONSOLE}}</span>
									{{#if game.CONSOLE2}}<span class='baga baga-{{game.CONSOLE2}}'>{{game.CONSOLE2}}</span>{{/if}}
									<span class='smaladndark minihrenvnizu'> &gt;&gt; открыть составы &lt;&lt; </span>
								</td>
								{{! PreButtonsGame }}
								{{! Buttons244 }}
								<td>
									<button type="button" {{on "click" (fn @controller.zaips2 game._id)}} class='BagButon'>П2<br />
										{{#if game.PRICE2}}
											<h3>{{game.PRICE2}}</h3><br />рублей
										{{else}}
											<h3>НЕТ</h3><br />цены
										{{/if}}
										{{#if game.P2NO}}<div class='statustr status-1'>{{game.P2NO}}</div>{{/if}}
									</button>
								</td>
								<td>
									<button type="button" {{on "click" (fn @controller.zaips4 game._id)}} class='BagButon'>П4<br />
										{{#if game.PRICE4}}
											<h3>{{game.PRICE4}}</h3><br />рублей
										{{else}}
											<h3>НЕТ</h3><br />цены
										{{/if}}
										{{#if game.P4NO}}<div class='statustr status-1'>{{game.P4NO}}</div>{{/if}}
									</button>
								</td>
								{{! Buttons244 }}
							</tr>
						</table>
						
						{{#if (get @controller.showhideo3 index)}}
							<table class="djuke">
								{{#each game.TROIKI as |users|}}
									<tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
										<td></td>
										<td colspan='2'>П2</td>
										<td colspan='2'>П4</td>
									</tr>
									<tr class='{{if users.MODE1 "bgred2"}}{{if users.MODE2 "bggr3"}}'>
										<td>
											{{if users.ACCOUNT users.ACCOUNT}}
										</td>
										<td>
											{{#if users.USERS.[0]}}
												<a title="{{if game.PRICE2 game.PRICE2}}р" href="/u/{{users.USERS.[0]}}">{{users.USERS.[0]}}</a>
												<a class='repala {{if users.PFBred.[1] "bgred" "bggr2"}}' href='/u/{{users.USERS.[0]}}/kek'>
													{{users.FEEDBACK.[0].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[0].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[0].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[0].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[0]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE2 game.PRICE2}}р
												{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[0]}}
												{{#if users.PSTATUS.[0].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[0].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[1]}}
												<a title="{{if game.PRICE4 game.PRICE4}}р" href="/u/{{users.USERS.[1]}}">{{users.USERS.[1]}}</a>
												<a class='repala {{if users.PFBred.[1] "bgred" "bggr2"}}' href='/u/{{users.USERS.[1]}}/kek'>
													{{users.FEEDBACK.[1].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[1].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[1].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[1].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[1]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE4 game.PRICE4}}р
												{{/if}}
											{{/if}}
											<br />
											{{#if users.USERS.[2]}}
												<a title="{{if game.PRICE4 game.PRICE4}}р" href="/u/{{users.USERS.[2]}}">{{users.USERS.[2]}}</a>
												<a class='repala {{if users.PFBred.[2] "bgred" "bggr2"}}' href='/u/{{users.USERS.[2]}}/kek'>
													{{users.FEEDBACK.[2].PERCENT}}%
													<span>
														<i class='far fa-smile'></i> {{users.FEEDBACK.[2].GOOD}}
														<i class='far fa-meh'></i> {{users.FEEDBACK.[2].NEUTRAL}}
														<i class='far fa-frown'></i> {{users.FEEDBACK.[2].BAD}}
													</span>
												</a>
											{{else}}
												{{#if users.PTAKEN.[2]}}
													Нету
												{{else}}
													Cвободно {{if game.PRICE4 game.PRICE4}}р
												{{/if}}
											{{/if}}
										</td>
										<td>
											{{#if users.USERS.[1]}}
												{{#if users.PSTATUS.[1].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[1].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
											{{/if}}
											{{#if users.USERS.[2]}}
												{{#if users.PSTATUS.[2].[0]}}<div class='malabela bgred3'><span>ждем оплату</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[1]}}<div class='malabela bggr'><span>оплатил</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[2]}}<div class='malabela bgred'><span>получил данные</span></div>{{/if}}
												{{#if users.PSTATUS.[2].[3]}}<div class='malabela bggr'><span>скачал</span></div>{{/if}}
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
