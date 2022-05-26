# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'
require 'base64'
require 'net/http'

enabled_site_setting :metatron_id
enabled_site_setting :telegram_id
enabled_site_setting :site_ip

register_asset 'stylesheets/MrBug.scss'

register_svg_icon "star-half-alt" if respond_to?(:register_svg_icon)

after_initialize do

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
		post '/MrBug/troikopoisk' => 'mrbug#troikopoisk'
		post '/MrBug/prezaips' => 'mrbug#prezaips'
		post '/MrBug/zaips' => 'mrbug#zaips'
		get '/renta-haleguu' => 'mrbug#rentagama'
		get '/admin/MegaAdd' => 'mrbug#showadd', constraints: AdminConstraint.new
		post '/admin/MegaAdd' => 'mrbug#megaadd', constraints: AdminConstraint.new
		get '/u/:username/kek' => 'mrbug#feedbacks', constraints: { username: RouteFormat.username }
		post '/u/:username/kek' => 'mrbug#zafeedback', constraints: { username: RouteFormat.username }
	end

	class ::MrbugController < ::ApplicationController

		SiteSetting.site_ip = 'union3.vg' if SiteSetting.site_ip.empty?

		db = Mongo::Client.new([ SiteSetting.site_ip+':33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@rentadb = db.use('rentagadb')

		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')
		
		@@cachedb = db.use('cacheDB')

		#user zapis count, glitchy, not stable, must use db for it... but eh, not that important to bother
		@@zaipsalsq = {}

		#cache for 4tverki and rent pages and fbgamezlist
		@@rentaCache = {}
		@@fbglist = {}

		#get usefb from db and index it for easier global usage
		@@user_FB = {}
		@@user_FB_date = {}
		@@user_FB_edit = {}
		@@userfb[:userfb].find().to_a.each do |fb|

			#check if fb exista
			if fb[:FEEDBACKS]
				@@user_FB[fb[:_id]] = fb

			#alert if theres nothing to count
			else
				puts "###Warning!!!### "+fb[:_id]+" feedback is broken!"
			end
		end

		def show
			autozCache = @@cachedb[:autozCache].find().to_a

			#drop chache if its old
			( @@cachedb[:autozCache].drop(); autozCache = [] ) if autozCache[0] && Time.now - autozCache[0][:TIME] > 1800

			#create cache if theres none
			if autozCache[0].empty?
				#get all type 123 games
				gameDB = @@gamedb[:gameDB].find( { TYPE: { "$in": [1,2,3] } }, projection: { imgLINKHQ: 0 } ).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a

				#get all users 2 list
				userDB = @@userlistdb[:uListP4].find().to_a

				#start a loop for every game to display
				gameDB.each do |game|
					#somevariables
					p1NO = 0; p2NO = 0; p3NO = 0; p4NO = 0; troikaNO = 0, game[:TTYPE] = [false, false, false] #0 - 24444, 1 - 1244, 2 - 224444

					#do each game postitions for futher template and other stuff usage
					if game[:CONSOLE] == "PS4" && !game[:CONSOLE2]
						game[:TTYPE][0] = true
						game[:PPOSITIONS] = [2,4,4,4,4,0]
					elsif ( game[:CONSOLE] == "PS5" && !game[:CONSOLE2] ) || ( game[:CONSOLE] == "PS4" && game[:CONSOLE2] == "XXX" )
						game[:TTYPE][1] = true
						game[:PPOSITIONS] = [1,2,4,4,0,0]
					else
						game[:TTYPE][2] = true
						game[:PPOSITIONS] = [2,2,4,4,4,4]
					end

					#create display prices
					if game[:PRICE] > 0
						game[:P4PDOWN1] = 0 if !game[:P4PDOWN1]
						game[:P4PDOWN2] = 0 if !game[:P4PDOWN2]
						game[:P4PDOWN3] = 0 if !game[:P4PDOWN3]

						#calculate prices, for ps4 only game, for ps5 only game, and ps4\ps5 game type
						if game[:TTYPE][0]
							game[:P4PRICE1] = 0

							game[:P4PRICE3] = (game[:PRICE] * 0.88 / 200).floor * 50 # '/200' is '/ 4 / 50'

							game[:P4PRICE2] = game[:PRICE] - 4 * game[:P4PRICE3]
							
							p4UP = [0,100,200]
							if game[:PRICE] < 1001
								p4UP = [0,0,100]
							elsif game[:PRICE] > 11001
								p4UP = [0,400,400]
							elsif game[:PRICE] > 7001	
								p4UP = [0,300,300] 
							end

						elsif game[:TTYPE][1]
							game[:P4PRICE1] = (game[:PRICE] * 0.13 / 50).ceil * 50

							game[:P4PRICE3] = (game[:PRICE] * 0.33 / 50).floor * 50 # '* 0.33' is '*.66 / 2'

							game[:P4PRICE2] = game[:PRICE] - 2 * game[:P4PRICE3] - game[:P4PRICE1]
							
							p4UP = [50,150,250]
							if game[:PRICE] < 1001
								p4UP = [0,0,150]
							elsif game[:PRICE] > 11001
								p4UP = [0,400,500]
							elsif game[:PRICE] > 7001	
								p4UP = [0,300,400] 
							end

						else
							game[:P4PRICE1] = 0

							game[:P4PRICE3] = (game[:PRICE] * 0.82 / 200).floor * 50 # '/200' is '/ 4 / 50'

							game[:P4PRICE2] = (game[:PRICE] - 4 * game[:P4PRICE3]) / 2
							
							p4UP = [0,150,200]
							if game[:PRICE] < 1001
								p4UP = [0,100,100]
							elsif game[:PRICE] > 11001
								p4UP = [0,400,400]
							elsif game[:PRICE] > 7001	
								p4UP = [0,300,300] 
							end
						end
						
						game[:P4PRICE1] = game[:P4PRICE1] - game[:P4PDOWN1] + p4UP[0] if game[:TTYPE][1]
						game[:P4PRICE2] = game[:P4PRICE2] - game[:P4PDOWN2] + p4UP[1]
						game[:P4PRICE3] = game[:P4PRICE3] - game[:P4PDOWN3] + p4UP[2]
						
						#set price to -10 if its x100
						game[:P4PRICE1] = game[:P4PRICE1] - 10 if game[:TTYPE][1] && game[:P4PRICE1]/100.0 == (game[:P4PRICE1]/100.0).ceil
						game[:P4PRICE2] = game[:P4PRICE2] - 10 if game[:P4PRICE2]/100.0 == (game[:P4PRICE2]/100.0).ceil
						game[:P4PRICE3] = game[:P4PRICE3] - 10 if game[:P4PRICE3]/100.0 == (game[:P4PRICE3]/100.0).ceil

						#do each game prices for futher template and other stuff usage
						if game[:TTYPE][0]
							game[:PPRICES] = [game[:P4PRICE2], game[:P4PRICE3], game[:P4PRICE3], game[:P4PRICE3], game[:P4PRICE3],0]
						elsif game[:TTYPE][1]
							game[:PPRICES] = [game[:P4PRICE1], game[:P4PRICE2], game[:P4PRICE3], game[:P4PRICE3],0,0]
						else
							game[:PPRICES] = [game[:P4PRICE2], game[:P4PRICE2], game[:P4PRICE3], game[:P4PRICE3], game[:P4PRICE3], game[:P4PRICE3]]
						end

					else
						game[:P4PRICE1] = game[:P4PRICE2] = game[:P4PRICE3] = 0

						game[:PPRICES] = [0,0,0,0,0,0]
					end
					
					#see if we have users to display
					users = userDB.find{ |h| h['_id'] == game[:_id] }

					game[:TROIKI] = []
					#do stuff if we do
					if users
						#find how many p1 p2 p3 we have, and how many troikas to display
						if game[:TTYPE][0]
							p1NO = users[:P2].length if users[:P2]
							p2NO = users[:P4_4].length / 2.0 if users[:P4_4] #fix because 2 P4 per troika
							p3NO = users[:P4_5].length / 2.0 if users[:P4_5] #fix because 2 P4 per troika
							#get how many troikas, roundup p4 numbers cos theres 2 per troika
							troikaNO = [p1NO, p2NO.ceil, p3NO.ceil].max - 1
						elsif game[:TTYPE][1]
							p1NO = users[:P1].length if users[:P1]
							p2NO = users[:P2].length if users[:P2]
							p3NO = users[:P4].length / 2.0 if users[:P4] #fix because 2 P4 per troika
							#get how many troikas, roundup p4 number cos theres 2 per troika
							troikaNO = [p1NO, p2NO, p3NO.ceil].max - 1
						else
							p1NO = users[:P2_4].length if users[:P2_4]
							p2NO = users[:P2_5].length if users[:P2_5]
							p3NO = users[:P4_4].length / 2.0 if users[:P4_4] #fix because 2 P4 per troika
							p4NO = users[:P4_5].length / 2.0 if users[:P4_5] #fix because 2 P4 per troika
							#get how many troikas, roundup p4 number cos theres 2 per troika
							troikaNO = [p1NO, p2NO, p3NO.ceil, p4NO.ceil].max - 1
						end

						#create variables for every troika
						for i in 0..troikaNO
							#tons of variables for everything
							p1 = ''; p2 = ''; p3 = ''; p4 = ''; p5 = ''; p6 = ''; account = ''; nop1ADD = 0
							p1STATUS = [false,false,false,false]; p2STATUS = [false,false,false,false]
							p3STATUS = [false,false,false,false]; p4STATUS = [false,false,false,false]
							p5STATUS = [false,false,false,false]; p6STATUS = [false,false,false,false]
							p1FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p2FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p3FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p4FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p5FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p6FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p1TAKEN = false; p2TAKEN = false; p3TAKEN = false; p4TAKEN = false; p5TAKEN = false; p6TAKEN = false
							p1FBred = false; p2FBred = false; p3FBred = false; p4FBred = false; p5FBred = false; p6FBred = false

							#fill user info and template variables for statuses
							if game[:TTYPE][0]
								if users[:P2] && users[:P2][i]
									p1 = users[:P2][i][:NAME].strip
									p1STATUS[users[:P2][i][:STAT]] = true
								end
								if users[:P4_4] && users[:P4_4][2*i]
									p2 = users[:P4_4][2*i][:NAME].strip
									p2STATUS[users[:P4_4][2*i][:STAT]] = true
								end
								if users[:P4_4] && users[:P4_4][2*i+1]
									p3 = users[:P4_4][2*i+1][:NAME].strip
									p3STATUS[users[:P4_4][2*i+1][:STAT]] = true
								end
								if users[:P4_5] && users[:P4_5][2*i]
									p4 = users[:P4_5][2*i][:NAME].strip
									p4STATUS[users[:P4_5][2*i][:STAT]] = true
								end
								if users[:P4_5] && users[:P4_5][2*i+1]
									p5 = users[:P4_5][2*i+1][:NAME].strip
									p5STATUS[users[:P4_5][2*i+1][:STAT]] = true
								end
							elsif game[:TTYPE][1]
								if users[:P1] && users[:P1][i]
									p1 = users[:P1][i][:NAME].strip
									p1STATUS[users[:P1][i][:STAT]] = true
								end
								if users[:P2] && users[:P2][i]
									p2 = users[:P2][i][:NAME].strip
									p2STATUS[users[:P2][i][:STAT]] = true
								end
								if users[:P4] && users[:P4][2*i]
									p3 = users[:P4][2*i][:NAME].strip
									p3STATUS[users[:P4][2*i][:STAT]] = true
								end
								if users[:P4] && users[:P4][2*i+1]
									p4 = users[:P4][2*i+1][:NAME].strip
									p4STATUS[users[:P4][2*i+1][:STAT]] = true
								end
							else
								if users[:P2_4] && users[:P2_4][i]
									p1 = users[:P2_4][i][:NAME].strip
									p1STATUS[users[:P2_4][i][:STAT]] = true
								end
								if users[:P2_5] && users[:P2_5][i]
									p2 = users[:P2_5][i][:NAME].strip
									p2STATUS[users[:P2_5][i][:STAT]] = true
								end
								if users[:P4_4] && users[:P4_4][2*i]
									p3 = users[:P4_4][2*i][:NAME].strip
									p3STATUS[users[:P4_4][2*i][:STAT]] = true
								end
								if users[:P4_4] && users[:P4_4][2*i+1]
									p4 = users[:P4_4][2*i+1][:NAME].strip
									p4STATUS[users[:P4_4][2*i+1][:STAT]] = true
								end
								if users[:P4_5] && users[:P4_5][2*i]
									p5 = users[:P4_5][2*i][:NAME].strip
									p5STATUS[users[:P4_5][2*i][:STAT]] = true
								end
								if users[:P4_5] && users[:P4_5][2*i+1]
									p6 = users[:P4_5][2*i+1][:NAME].strip
									p6STATUS[users[:P4_5][2*i+1][:STAT]] = true
								end
							end

							#template variables for when p1 p2 p3 p4 are taken
							(p1TAKEN = true; p1 = '') if p1 == '-55'
							(p2TAKEN = true; p2 = '') if p2 == '-55'
							(p3TAKEN = true; p3 = '') if p3 == '-55'
							(p4TAKEN = true; p4 = '') if p4 == '-55'
							(p5TAKEN = true; p5 = '') if p5 == '-55'
							(p6TAKEN = true; p6 = '') if p6 == '-55'

							#find feedback for users
							if p1.length > 0 && @@user_FB[p1.downcase]
								p1FEEDBACK[:GOOD] = @@user_FB[p1.downcase][:fbG]
								p1FEEDBACK[:BAD] = @@user_FB[p1.downcase][:fbB]
								p1FEEDBACK[:NEUTRAL] = @@user_FB[p1.downcase][:fbN]
							end
							if p2.length > 0 && @@user_FB[p2.downcase]
								p2FEEDBACK[:GOOD] = @@user_FB[p2.downcase][:fbG]
								p2FEEDBACK[:BAD] = @@user_FB[p2.downcase][:fbB]
								p2FEEDBACK[:NEUTRAL] = @@user_FB[p2.downcase][:fbN]
							end
							if p3.length > 0 && @@user_FB[p3.downcase]
								p3FEEDBACK[:GOOD] = @@user_FB[p3.downcase][:fbG]
								p3FEEDBACK[:BAD] = @@user_FB[p3.downcase][:fbB]
								p3FEEDBACK[:NEUTRAL] = @@user_FB[p3.downcase][:fbN]
							end
							if p4.length > 0 && @@user_FB[p4.downcase]
									p4FEEDBACK[:GOOD] = @@user_FB[p4.downcase][:fbG]
									p4FEEDBACK[:BAD] = @@user_FB[p4.downcase][:fbB]
									p4FEEDBACK[:NEUTRAL] = @@user_FB[p4.downcase][:fbN]
							end
							if p5.length > 0 && @@user_FB[p5.downcase]
								p5FEEDBACK[:GOOD] = @@user_FB[p5.downcase][:fbG]
								p5FEEDBACK[:BAD] = @@user_FB[p5.downcase][:fbB]
								p5FEEDBACK[:NEUTRAL] = @@user_FB[p5.downcase][:fbN]
							end
							if p6.length > 0 && @@user_FB[p6.downcase]
								p6FEEDBACK[:GOOD] = @@user_FB[p6.downcase][:fbG]
								p6FEEDBACK[:BAD] = @@user_FB[p6.downcase][:fbB]
								p6FEEDBACK[:NEUTRAL] = @@user_FB[p6.downcase][:fbN]
							end

							#find feedback percentage
							p1FEEDBACK[:PERCENT] = (p1FEEDBACK[:GOOD].to_f/(p1FEEDBACK[:GOOD] + p1FEEDBACK[:BAD]) * 100.0).floor if p1FEEDBACK[:GOOD] > 0
							p2FEEDBACK[:PERCENT] = (p2FEEDBACK[:GOOD].to_f/(p2FEEDBACK[:GOOD] + p2FEEDBACK[:BAD]) * 100.0).floor if p2FEEDBACK[:GOOD] > 0
							p3FEEDBACK[:PERCENT] = (p3FEEDBACK[:GOOD].to_f/(p3FEEDBACK[:GOOD] + p3FEEDBACK[:BAD]) * 100.0).floor if p3FEEDBACK[:GOOD] > 0
							p4FEEDBACK[:PERCENT] = (p4FEEDBACK[:GOOD].to_f/(p4FEEDBACK[:GOOD] + p4FEEDBACK[:BAD]) * 100.0).floor if p4FEEDBACK[:GOOD] > 0
							p5FEEDBACK[:PERCENT] = (p5FEEDBACK[:GOOD].to_f/(p5FEEDBACK[:GOOD] + p5FEEDBACK[:BAD]) * 100.0).floor if p5FEEDBACK[:GOOD] > 0
							p6FEEDBACK[:PERCENT] = (p6FEEDBACK[:GOOD].to_f/(p6FEEDBACK[:GOOD] + p6FEEDBACK[:BAD]) * 100.0).floor if p6FEEDBACK[:GOOD] > 0

							#create account variable if it exists
							account = users[(i+1).to_s][:ACCOUNT] if users[(i+1).to_s][:ACCOUNT] if users[(i+1).to_s]

							#template again, is feedback green or red?
							p1FBred = true if p1FEEDBACK[:PERCENT] < 100
							p2FBred = true if p2FEEDBACK[:PERCENT] < 100
							p3FBred = true if p3FEEDBACK[:PERCENT] < 100
							p4FBred = true if p4FEEDBACK[:PERCENT] < 100
							p5FBred = true if p5FEEDBACK[:PERCENT] < 100
							p6FBred = true if p6FEEDBACK[:PERCENT] < 100

							#vizmem bez p1?!
							nop1ADD = (game[:P4PRICE1] / 30.0).ceil * 10 if game[:TTYPE][1] && p1 == ''

							#create final variable
							game[:TROIKI].push( {
								USERS: [p1,p2,p3,p4,p5,p6],
								FEEDBACK: [p1FEEDBACK,p2FEEDBACK,p3FEEDBACK,p4FEEDBACK,p5FEEDBACK,p6FEEDBACK],
								NOP1ADD: nop1ADD, ACCOUNT: account,
								PTAKEN: [p1TAKEN,p2TAKEN,p3TAKEN,p4TAKEN,p5TAKEN,p6TAKEN],
								PFBred: [p1FBred,p2FBred,p3FBred,p4FBred,p5FBred,p6FBred],
								PSTATUS: [p1STATUS,p2STATUS,p3STATUS,p4STATUS,p5STATUS,p6STATUS]
							} )
						end
					end

					#set display user numbers since we finished looping through this game users
					game[:P1NO] = p1NO; game[:P2NO] = p2NO; game[:P3NO] = p3NO; game[:P4NO] = p4NO

				end

				#save everything to cachedb
				@@cachedb[:autozCache].insert_one( { gamelist: gameDB, TIME: Time.now } )

				autozCache[0][:gamelist] = gameDB

			end

			render json: { gamelist: autozCache[0][:gamelist] }

		end

		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(params[:input]).strip.downcase
			
			accountsDB = @@userdb[:PS4db].find( { _id: troikopoisk } ).to_a

			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40 && accountsDB[0] && ( Time.now - accountsDB[0][:DATE].to_time < 63000000 )
				render json: { 
					_id: accountsDB[0][:_id], GAME: accountsDB[0][:GAME],
					P2: accountsDB[0][:P2], P4: accountsDB[0][:P4],
					poiskwin: true
				}
			else 
				render json: { poiskfail: true }
			end
		end

		def prezaips
			#decode shit
			code = Base64.decode64(params[:bagakruta]).split("~") #0 - position, 1 - gameCODE

			#if viewer registered, count his fb
			if current_user && code.length == 2
				user_d = current_user[:username].downcase

				#delete users zaipsalsq if its old
				@@zaipsalsq.except!(user_d) if @@zaipsalsq[user_d] && @@zaipsalsq[user_d][:DATE] != Time.now.strftime("%d")

				user_FB = @@userfb[:userfb].find({ _id: user_d }, projection: { fbG: 1, fbBuG: 1, troikaBAN: 1 }).to_a

				#check if positive feedback or spam exists
				if user_FB[0] && user_FB[0][:fbG] > 0 && user_FB[0][:troikaBAN] == 0 && Time.now - current_user[:created_at] > 260000 &&
					( current_user[:username] == 'MrBug' || (!@@zaipsalsq[user_d] || @@zaipsalsq[user_d][:count] < 4) )
					#special message if its a p1 zapis with less then 5 mrbug feedback
					if code[0] == "1" && user_FB[0][:fbBuG] < 5 && current_user[:username] != 'MrBug'
						render json: { piadin: true, fbcount: user_FB[0][:fbBuG] }
					else
						#get stuff from db
						prezaips = @@gamedb[:gameDB].find( { _id: code[1] }, projection: { imgLINK: 1, imgLINKHQ: 1, gameNAME: 1 } ).to_a
						if prezaips[0][:imgLINKHQ]
							prezaips[0][:imgLINK] = prezaips[0][:imgLINKHQ]
							prezaips[0].except!("imgLINKHQ")
						end

						prezaips[0][:position] = code[0]
						prezaips[0][:winrars] = true

						render json: prezaips[0]
					end
				else
					render json: { banned: true }
				end
			else
				render json: { guest: true }
			end
		end

		def zaips
			#decode shit
			code = Base64.decode64(params[:bagatrolit]).force_encoding('UTF-8').split("~") #0 - position, 1 - userNAME, 2 - gameCODE, 3 - gameNAME

			#do stuff if user is actual user and code is correct
			if current_user && code[3] && current_user[:username] == code[1]
				user_d = current_user[:username].downcase

				#delete users zaipsalsq if its old
				@@zaipsalsq.except!(user_d) if @@zaipsalsq[user_d] && @@zaipsalsq[user_d][:DATE] != Time.now.strftime("%d")

				user_FB = @@userfb[:userfb].find({ _id: user_d }, projection: { fbG: 1, fbBuG: 1, troikaBAN: 1 }).to_a

				#do everything checking again!
				if user_FB[0] && user_FB[0][:fbG] > 0 && user_FB[0][:troikaBAN] == 0 && Time.now - current_user[:created_at] > 260000 &&
					( current_user[:username] == 'MrBug' || (!@@zaipsalsq[user_d] || @@zaipsalsq[user_d][:count] < 4) ) &&
				!(code[0] == "1" && user_FB[0][:fbBuG] < 5 && current_user[:username] != 'MrBug')
					#increase zaips count for user
					if @@zaipsalsq[user_d]
						@@zaipsalsq[user_d][:count] += 1
					else
						@@zaipsalsq[user_d] = {	count: 1, DATE: Time.now.strftime("%d") }
					end

					#do actual zaips, wohoo
					push = { "P"+code[0]: { NAME: current_user[:username], DATE: Time.now.strftime("%Y.%m.%d"), STAT: 0 } }

					@@userlistdb[:uListP4].find_one_and_update( { _id: code[2] }, { "$push" => push }, { upsert: true } )

					render json: { winrars: true, position: code[0], gameNAME: code[3] }

					#destroy 4tverki cache
					@@cachedb[:autozCache].drop()

					#add message to chat
					PostCreator.create(
						Discourse.system_user,
						skip_validations: true,
						topic_id: 61653,
						raw: current_user[:username]+" записался на позицию П"+code[0][0]+" совместной покупки "+code[3]
					)

					#add message to telegram bot, if enabled
					uri = URI('https://api.telegram.org/bot'+SiteSetting.metatron_id+'/sendMessage')
					Net::HTTP.post_form(uri, 'chat_id' => SiteSetting.telegram_id, 'text' => current_user[:username]+' записался на позицию П'+code[0][0]+' совместной покупки '+code[3])

					#create forum notification if sobrano
					#get game userlist
					gameuzers = @@userlistdb[:uListP4].find( _id: code[2] ).to_a
					#find this troika index
					troino = gameuzers[0]["P"+code[0]].count
					troino = troino / 2.0 if code[0] == "4" || code[0] == "4_4" || code[0] == "4_5"
					trindx = troino - 1

					#dont do shit if troika index not full number
					#check if troika sobrana
					if troino.to_i == troino && ( (gameuzers[0]["P2"] && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"] &&
						gameuzers[0]["P2"][trindx] && gameuzers[0]["P4_4"][trindx*2+1] && gameuzers[0]["P4_5"][trindx*2+1]) ||
					(gameuzers[0]["P2"] && gameuzers[0]["P4"] &&
						gameuzers[0]["P2"][trindx] && gameuzers[0]["P4"][trindx*2+1]) ||
					(gameuzers[0]["P2_4"] && gameuzers[0]["P2_5"] && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"] &&
						gameuzers[0]["P2_4"][trindx] && gameuzers[0]["P2_5"][trindx] && gameuzers[0]["P4_4"][trindx*2+1] && gameuzers[0]["P4_5"][trindx*2+1]) )
						#add users to userlist
						usernames = ["MrBug"]
						usernames.push(gameuzers[0][:P1][trindx][:NAME])	if gameuzers[0][:P1] && gameuzers[0][:P1][trindx] && gameuzers[0][:P1][trindx][:STAT] == 0 && gameuzers[0][:P1][trindx][:NAME] != "-55"
						usernames.push(gameuzers[0][:P2][trindx][:NAME])	if gameuzers[0][:P2] && gameuzers[0][:P2][trindx][:STAT] == 0
						usernames.push(gameuzers[0][:P4][trindx*2][:NAME])	if gameuzers[0][:P4] && gameuzers[0][:P4][trindx*2][:STAT] == 0
						usernames.push(gameuzers[0][:P4][trindx*2+1][:NAME])	if gameuzers[0][:P4] && gameuzers[0][:P4][trindx*2+1][:STAT] == 0
						usernames.push(gameuzers[0][:P2_4][trindx][:NAME])	if gameuzers[0][:P2_4] && gameuzers[0][:P2_4][trindx][:STAT] == 0
						usernames.push(gameuzers[0][:P2_5][trindx][:NAME])	if gameuzers[0][:P2_5] && gameuzers[0][:P2_5][trindx][:STAT] == 0
						usernames.push(gameuzers[0][:P4_4][trindx*2][:NAME])	if gameuzers[0][:P4_4] && gameuzers[0][:P4_4][trindx*2][:STAT] == 0
						usernames.push(gameuzers[0][:P4_4][trindx*2+1][:NAME])	if gameuzers[0][:P4_4] && gameuzers[0][:P4_4][trindx*2+1][:STAT] == 0
						usernames.push(gameuzers[0][:P4_5][trindx*2][:NAME])	if gameuzers[0][:P4_5] && gameuzers[0][:P4_5][trindx*2][:STAT] == 0
						usernames.push(gameuzers[0][:P4_5][trindx*2+1][:NAME])	if gameuzers[0][:P4_5] && gameuzers[0][:P4_5][trindx*2+1][:STAT] == 0
						usernames.uniq!

						hrenka = "Тройка" if gameuzers[0]["P2"] && gameuzers[0]["P4"]
						hrenka = "Четверка" if gameuzers[0][:P1] && gameuzers[0][:P1][trindx]
						hrenka = "Пятерка" if gameuzers[0]["P2"] && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"]
						hrenka = "Шестерка" if gameuzers[0]["P2_4"] && gameuzers[0]["P2_5"] && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"]	

						troititle = hrenka + " на " + code[3] + " собрана! Ждем оплату!"
						troitext = "Здравствуйте! :robot:\n" +
						"Случилось невероятное! " + hrenka + " на " + code[3] + " собрана.\n" +
						"Этого не должно было произойти, но придется теперь как-то с этим жить :robot:\n\n" +
						"Вот план дальнейших действий:\n" +
						"1) Оплатить свою позицию, суммы и реквизиты указаны [на странице четверок, в начале страницы](/MrBug)\n" +
						"2) Сразу же нажать кнопку 'ответить' под этим сообщением и сообщить что вы оплатили\n" +
						"3) Ознакомиться с [инструкциями в разделе FAQ](/faq)\n" +
						"4) Написать в общем чате как вам не повезло с товарищами по составу\n\n" +
						"Держитесь! И да поможет вам :bug:"

						PostCreator.create(
							Discourse.system_user,
							skip_validations: true,
							target_usernames: usernames.join(","),
							archetype: Archetype.private_message,
							subtype: TopicSubtype.system_message,
							title: troititle,
							raw: troitext
						)
					end
				else
					render json: { zaipsfail: true }
					puts "###Warning!!!### "+current_user[:username]+" is hacking 4tverki!"
				end

			else
				render json: { zaipsfail: true }
				puts "###Warning!!!### "+current_user[:username]+" is hacking 4tverki!"
			end
		end

		def showadd
			render json: { HiMom: '!!!' }
		end

		def megaadd
			addstuff = {}, feedbacks = [], chetverk = ''
			addstuff = params
			addstuff[:RESULT] = []
			if current_user && current_user[:username] == 'H1tomaru' && addstuff[:GAME] && addstuff[:STRING]
				gameNAME = addstuff[:GAME].strip
				#regex string #1: remove lines with P1, #2: remove stuff left of " - ", #3: remove prices like "(800 рублей)", #4: make proper new lines
				newstring = addstuff[:STRING].gsub(/^.*П1 - .*$/,"").gsub(/^.* - /,"").gsub(/(\()(.*)(\))/,"").gsub(/^\s*[\r\n]/,"").split("\n")
				#check if were doing p2p4p4, p2p4p4p4p4 or p2p2p4p4p4p4
				if (addstuff[:STRING].include? "П4") && (addstuff[:STRING].exclude? "П4_5")
					#p2p4p4 version
					chetverk = 'четверке'
					newstring.each_slice(4) do |sostav|
						if sostav[0] && (sostav[0].include? "gmail.com") && sostav[1] && sostav[2] && sostav[3]
							addstuff[:winrarP244] = true
							for i in 1..3
								sostav[i] = sostav[i].split(" ---> ").map { |item| item.strip }
							end
							addstuff[:RESULT].push({ _id: sostav[0].strip, GAME: gameNAME, P2: [sostav[1].last], P4: [sostav[2].last, sostav[3].last], DATE: Time.now.strftime("%Y.%m.%d") })

							#add those users to a list of users to give them feedback after, if were giving it
							feedbacks.push(sostav[1].last, sostav[2].last, sostav[3].last) if addstuff[:ADDFB]
						end
					end
				elsif (addstuff[:STRING].include? "П4_5") && (addstuff[:STRING].include? "П2_5")
					#p2p2p4p4p4p4 version
					chetverk = 'шестерке'
					newstring.each_slice(7) do |sostav|
						if sostav[0] && (sostav[0].include? "gmail.com") && sostav[1] && sostav[2] && sostav[3] && sostav[4] && sostav[5] && sostav[6]
							addstuff[:winrarP224444] = true
							for i in 1..6
								sostav[i] = sostav[i].split(" ---> ").map { |item| item.strip }
							end
							addstuff[:RESULT].push({ _id: sostav[0].strip, GAME: gameNAME, P2: [sostav[1].last, sostav[2].last], P4: [sostav[3].last, sostav[4].last, sostav[5].last, sostav[6].last], DATE: Time.now.strftime("%Y.%m.%d") })

							#add those users to a list of users to give them feedback after, if were giving it
							feedbacks.push(sostav[1].last, sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last, sostav[6].last) if addstuff[:ADDFB]
						end
					end
				else
					#p2p4p4p4p4 version
					chetverk = 'пятерке'
					newstring.each_slice(6) do |sostav|
						if sostav[0] && (sostav[0].include? "gmail.com") && sostav[1] && sostav[2] && sostav[3] && sostav[4] && sostav[5]
							addstuff[:winrarP24444] = true
							for i in 1..5
								sostav[i] = sostav[i].split(" ---> ").map { |item| item.strip }
							end
							addstuff[:RESULT].push({ _id: sostav[0].strip, GAME: gameNAME, P2: [sostav[1].last], P4: [sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last], DATE: Time.now.strftime("%Y.%m.%d") })

							#add those users to a list of users to give them feedback after, if were giving it
							feedbacks.push(sostav[1].last, sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last) if addstuff[:ADDFB]
						end
					end
				end

				addstuff[:RESULT].each do |winrar|
					#save to db
					@@userdb[:PS4db].replace_one( { _id: winrar[:_id] }, { GAME: winrar[:GAME], P2: winrar[:P2], P4: winrar[:P4], DATE: winrar[:DATE] }, { upsert: true } )
				end

				#drop fbgamezlist cache
				@@cachedb[:fbglist].drop() #can drop it only for involved users... but eeeehh... drop everything

				render json: addstuff

				#add feedback if we're doing it
				if addstuff[:ADDFB] == 'true'
					#variables
					daTE = Time.now.strftime("%Y.%m.%d")
					daTE_day = Time.now.strftime("%d")
					neoFB = {
						FEEDBACK: "Участвовал в "+chetverk+" на "+gameNAME+". Всё отлично!",
						pNAME: "MrBug",
						DATE: daTE,
						SCORE: 1
					}

					#delete duplicate users
					feedbacks.uniq!

					#downcase all names
					feedbacks.map!{|uname| uname.downcase}
					
					feedbacks.each do |user|
						user_FB = @@userfb[:userfb].find({ _id: user }).to_a
						#find if we gave user this feedback already
						hasfb = user_FB[0][:FEEDBACKS].any? {|h| h[:FEEDBACK] == neoFB[:FEEDBACK] && h[:DATE] == daTE } if user_FB[0]
						unless hasfb
							#add to fb, or create new if there no fb
							if user_FB[0]
								#save to db
								@@userfb[:userfb].find_one_and_update( { _id: user }, { 
									"$push" => { FEEDBACKS: neoFB },
									"$inc" => { fbG: 1, fbBuG: 1 }
								}, { upsert: true } )
							else
								@@user_FB_date[user] = daTE_day
								@@userfb[:userfb].insert_one( {
									_id: user, FEEDBACKS: [neoFB], troikaBAN: 0, fbG: 1, fbN: 0, fbB: 0, fbBuG: 1, fbBuB: 0, fbARC: 0
								} )
							end
						end
					end
				end
			end
		end

		def feedbacks
			feedbacks = { FEEDBACKS: [], MENOSHO: true, fbG: 0, fbN: 0, fbB: 0, fbBuG: 0, fbBuB: 0, fbARC: 0, uZar: params[:username] }
			timeNOW = Time.now
			user_d = params[:username].downcase

			#page owners cant do feedbacks!
			feedbacks[:MENOSHO] = false if current_user && current_user[:username].downcase == user_d

			#recount user fb, in case its old
			if @@user_FB[user_d]
				#recount fb in case some fb is old
				( ufbupdate(@@user_FB[user_d]); @@user_FB_date[user_d] = Time.now.strftime("%d") ) if !@@user_FB_date[user_d] || @@user_FB_date[user_d] != Time.now.strftime("%d")
				feedbacks[:FEEDBACKS] = @@user_FB[user_d][:FEEDBACKS]
				feedbacks[:fbG] = @@user_FB[user_d][:fbG]
				feedbacks[:fbN] = @@user_FB[user_d][:fbN]
				feedbacks[:fbB] = @@user_FB[user_d][:fbB]
				feedbacks[:fbBuG] = @@user_FB[user_d][:fbBuG]
				feedbacks[:fbBuB] = @@user_FB[user_d][:fbBuB]
				feedbacks[:fbARC] = @@user_FB[user_d][:fbARC]
			end

			#do the games owned display, for logged in users only
			if current_user && params[:username] != 'MrBug' && ( !@@fbglist[user_d] || @@fbglist[user_d][:DATE] != Time.now.strftime("%d") )
				#get user games from my database
				ugamez = @@accountsDB.select { |key, hash| (hash[:P2].include? params[:username]) || (hash[:P4].include? params[:username]) }

				ugamezfinal = []
				#do stuff if we have some
				if ugamez
					ugamez.each do |key, ugaz|
						if timeNOW - ugaz[:DATE].to_time < 63000000 && ugaz[:P2] && ugaz[:P4]
							#select acc mail between + and @, \+ and \@
							aCC = ugaz[:_id][/\+(.*?)\@/m, 1]

							#create final variable
							ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 2, aCC: aCC } ) if ugaz[:P2][0] && ugaz[:P2][0].downcase == user_d
							ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 2, aCC: aCC } ) if ugaz[:P2][1] && ugaz[:P2][1].downcase == user_d
							ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 4, aCC: aCC } ) if ugaz[:P4][0] && ugaz[:P4][0].downcase == user_d
							ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 4, aCC: aCC } ) if ugaz[:P4][1] && ugaz[:P4][1].downcase == user_d
							ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 4, aCC: aCC } ) if ugaz[:P4][2] && ugaz[:P4][2].downcase == user_d
							ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 4, aCC: aCC } ) if ugaz[:P4][3] && ugaz[:P4][3].downcase == user_d
						end
					end
				end
				#save it to cache
				#do sorting web side? eeeh... cached anyway...
				@@fbglist[user_d] = { ugameZ: ugamezfinal.sort_by { |k| [k[:gNAME].downcase, k[:poZ]] }, DATE: Time.now.strftime("%d") }
			end

			#use cache if we have one and its not empty
			if params[:username] != 'MrBug' && @@fbglist[user_d][:ugameZ].any?
				feedbacks[:ugameZ] = @@fbglist[user_d][:ugameZ]

				#remove acc mail if user is not owner of this page
				feedbacks[:ugameZ].each { |h| h.except!(:aCC) } if current_user[:username].downcase != user_d
			end
			
			#render fb
			render json: feedbacks

		end

		def zafeedback
			#decode shit
			fedbacks = Base64.decode64(params[:fedbakibaki]).split("~") #0 - mode, 1 - score, 2 - otziv
			fedbacks[1] = fedbacks[1].to_i
			user_d = current_user[:username].downcase
			pageu_d = params[:username].downcase
			timeNOW = Time.now.strftime("%Y.%m.%d")

			#page owners and guests cant do feedbacks!
			if current_user && fedbacks.length == 3 && user_d != pageu_d && (fedbacks[0] == "true" || fedbacks[0] == "false" )

				#users with negative feedbacks cant do feedbacks!
				if @@user_FB[user_d] && @@user_FB[user_d][:fbB] > 0
					render json: { bakas: true }
				else

					#do normal feedback add
					if fedbacks[0] == "true"

						#if gave feedback already, show stuff
						if @@user_FB[pageu_d] && @@user_FB[pageu_d][:FEEDBACKS] && @@user_FB[pageu_d][:FEEDBACKS].any? {|h| h[:pNAME] == current_user[:username] && h[:DATE] == timeNOW} && current_user[:username] != 'MrBug'
							render json: { gavas_z: true }
						else
							new_fb = {
								FEEDBACK: fedbacks[2].strip,
								pNAME: current_user[:username],
								DATE: timeNOW,
								SCORE: fedbacks[1]
							}

							#if fb exists, add to it, or create new fb if its not
							if @@user_FB[pageu_d] && @@user_FB[pageu_d][:FEEDBACKS]
								#add feedback to fb cache
								@@user_FB[pageu_d][:FEEDBACKS].push(new_fb)
							else
								#create fb array if user doesnt have any fb yet
								@@user_FB[pageu_d] = { FEEDBACKS: [new_fb] }
							end

							#update fb with glitchy function... hope it works...
							ufbupdate(@@user_FB[pageu_d])
							@@user_FB_date[pageu_d] = Time.now.strftime("%d") 

							render json: { winrars_z: true }

						end

					#or edit last feedback given
					elsif fedbacks[0] == "false"

						#find last feedback and see if we edited it already today
						@@user_FB[pageu_d][:FEEDBACKS].reverse_each do |fb|
							#if found, do stuff
							if fb[:pNAME] == current_user[:username]
								#if edited feedback already, show stuff
								if @@user_FB_edit[pageu_d+current_user[:username]] && @user_FB_edit[pageu_d+current_user[:username]] == timeNOW
									render json: { gavas_e: true }
								else
									fb[:FEEDBACK] = fedbacks[2].strip
									fb[:SCORE] = fedbacks[1]

									#make edited mark
									@user_FB_edit[pageu_d+current_user[:username]] == timeNOW if !@@user_FB_edit[pageu_d+current_user[:username]]

									#add bogus trash to fb so it will recount and update db
									@@user_FB[pageu_d][:fbN] =  999

									#update fb with glitchy function... hope it works...
									ufbupdate(@@user_FB[pageu_d])
									@@user_FB_date[pageu_d] = Time.now.strftime("%d") 

									render json: { winrars_e: true }
								end
								break
							end
						end
					end

				end

			else #if that is a guest or a page owner... thats really really wrong...
				render json: { fail: true }
				puts "###Warning!!!### "+current_user[:username]+" is hacking otzivs!"
			end
		end

		def rentagama
			#drop chache if it exists and is old
			@@rentaCache = {} if @@rentaCache.any? && Time.now - @@rentaCache[:TIME] > 3600

			if @@rentaCache.empty?
				@@rentaCache[:finalrenta] = { rentaGAMEZ: [], rentaGAMEZ1: [], rentaGAMEZ2: [] }
				count = [0,0,0,0,0] # #0 - vsego, #1 - type 1, #2 - type 2, #3 - type 3, #4 - type 4

				#find all rentagamez
				@@rentadb[:rentagadb].find().to_a.each do |games|
					gTYPE = [false,false,false,false]
					count[0] = count[0] + 1
					( gTYPE[0] = true; count[1] += 1 ) if games[:GTYPE] == 1
					( gTYPE[1] = true; count[2] += 1 ) if games[:GTYPE] == 2
					( gTYPE[2] = true; count[3] += 1 ) if games[:GTYPE] == 3
					( gTYPE[3] = true; count[4] += 1 ) if games[:GTYPE] == 4
					games[:GITEMS].each do |game|
						gameojb = {
							GNAME: games[:_id], GPIC: games[:GPIC], GCOMMENT: games[:GCOMMENT],
							TYPE1: gTYPE[0], TYPE2: gTYPE[1], TYPE3: gTYPE[2], TYPE4: gTYPE[3],
							GNEW: games[:GNEW], POSITION: game[:POSITION], PRICE: game[:PRICE],
							STATUS: game[:STATUS], LINE: game[:LINE]
						}
						@@rentaCache[:finalrenta][:rentaGAMEZ].push( gameojb )
						@@rentaCache[:finalrenta][:rentaGAMEZ1].push( gameojb ) if games[:GTYPE] == 1 || games[:GTYPE] == 4
						@@rentaCache[:finalrenta][:rentaGAMEZ2].push( gameojb ) if games[:GTYPE] == 2 || games[:GTYPE] == 3
					end
				end
				@@rentaCache[:finalrenta][:count] = count

				#sort this shit
				@@rentaCache[:finalrenta][:rentaGAMEZ].sort_by! { |k| [-k[:GNEW], k[:GNAME].downcase] }
				@@rentaCache[:finalrenta][:rentaGAMEZ1].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }
				@@rentaCache[:finalrenta][:rentaGAMEZ2].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }

				@@rentaCache[:TIME] = Time.now
			end

			render json: @@rentaCache[:finalrenta]
		end

		#very cute fb update method
		def ufbupdate(inputfb)
			feedbacks = { troikaBAN: 0, fbG: 0, fbN: 0, fbB: 0, fbBuG: 0, fbBuB: 0, fbARC: 0 }
			newfbarray = []; timeNOW = Time.now

			#remove duplicates
			inputfb[:FEEDBACKS].uniq!

			#create key if it doesnt exist yet
			feedbacks[:troikaBAN] = inputfb[:troikaBAN] if inputfb[:troikaBAN]

			#get deleted feedback number if it exists
			feedbacks[:fbARC] = inputfb[:fbARC] if inputfb[:fbARC]

			#count and create numbers
			inputfb[:FEEDBACKS].each do |fb|
				#look for old ones and delete them
				if timeNOW - fb[:DATE].to_time > 63000000
					feedbacks[:fbARC] += 1
				else #else just count them
					feedbacks[:fbG] += 1 if fb[:SCORE] > 0
					feedbacks[:fbB] += 1 if fb[:SCORE] < 0
					feedbacks[:fbN] += 1 if fb[:SCORE] == 0
					#count bugofb
					if fb[:pNAME] == "MrBug" && ( timeNOW - fb[:DATE].to_time < 31500000 )
						feedbacks[:fbBuG] += 1 if fb[:SCORE] > 0
						feedbacks[:fbBuB] += 1 if fb[:SCORE] < 0	
					end
					newfbarray.push({
						FEEDBACK: fb[:FEEDBACK],
						pNAME: fb[:pNAME],
						DATE: fb[:DATE],
						SCORE: fb[:SCORE]
					})
				end
			end

			#update shit if numbers are different
			if feedbacks[:fbG] != inputfb[:fbG] || feedbacks[:fbN] != inputfb[:fbN] || feedbacks[:fbB] != inputfb[:fbB] ||
			feedbacks[:fbBuG] != inputfb[:fbBuG] || feedbacks[:fbBuB] != inputfb[:fbBuB] || feedbacks[:fbARC] != inputfb[:fbARC]
				#save to cache
				@@user_FB[inputfb[:_id]] = { _id: inputfb[:_id], FEEDBACKS: newfbarray, troikaBAN: feedbacks[:troikaBAN],
					fbG: feedbacks[:fbG], fbN: feedbacks[:fbN], fbB: feedbacks[:fbB],
					fbBuG: feedbacks[:fbBuG], fbBuB: feedbacks[:fbBuB], fbARC: feedbacks[:fbARC] }

				#save to db
				@@userfb[:userfb].replace_one( { _id: inputfb[:_id] }, { FEEDBACKS: newfbarray, troikaBAN: feedbacks[:troikaBAN],
					fbG: feedbacks[:fbG], fbN: feedbacks[:fbN], fbB: feedbacks[:fbB],
					fbBuG: feedbacks[:fbBuG], fbBuB: feedbacks[:fbBuB], fbARC: feedbacks[:fbARC] }, { upsert: true } )

			end
		end

	end

end
