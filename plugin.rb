# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'
require 'base64'
require 'faraday'

enabled_site_setting :metatron_id
enabled_site_setting :telegram_id
enabled_site_setting :site_ip
enabled_site_setting :pbot_ip
enabled_site_setting :chat_webhook

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
		post '/u/:username/kek/oishiiii' => 'mrbug#zapass', constraints: { username: RouteFormat.username }
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

		def show
			#get cache
			autozCache = @@cachedb[:autozCache].find().to_a.first()

			#drop chache, if its old
			( @@cachedb[:autozCache].drop(); autozCache = {} ) if autozCache && Time.now - autozCache[:TIME] > 1800

			#create cache if theres none
			if autozCache.blank?
				#get all type 123 games
				gameDB = @@gamedb[:gameDB].find( { TYPE: { "$in": [1,2,3] } }, projection: { imgLINKHQ: 0 } ).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a

				#get all users 2 list
				userDB = @@userlistdb[:uListP4].find().to_a

				#get all user feedbacks
				userFB = @@userfb[:userfb].find( {}, projection: { fbG: 1, fbN: 1, fbB: 1 } ).to_a

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
						game[:PDOWN1] = 0 if !game[:PDOWN1]
						game[:PDOWN2] = 0 if !game[:PDOWN2]
						game[:PDOWN3] = 0 if !game[:PDOWN3]

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
						
						game[:P4PRICE1] = game[:P4PRICE1] - game[:PDOWN1] + p4UP[0] if game[:TTYPE][1]
						game[:P4PRICE2] = game[:P4PRICE2] - game[:PDOWN2] + p4UP[1]
						game[:P4PRICE3] = game[:P4PRICE3] - game[:PDOWN3] + p4UP[2]
						
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
							if p1.length > 0
								feedbackp1 = userFB.find{ |h| h['_id'] == p1.downcase }
								if feedbackp1
									p1FEEDBACK[:GOOD] = feedbackp1[:fbG] if feedbackp1[:fbG]
									p1FEEDBACK[:BAD] = feedbackp1[:fbB] if feedbackp1[:fbB]
									p1FEEDBACK[:NEUTRAL] = feedbackp1[:fbN] if feedbackp1[:fbN]
								end
							end
							if p2.length > 0
								feedbackp2 = userFB.find{ |h| h['_id'] == p2.downcase }
								if feedbackp2
									p2FEEDBACK[:GOOD] = feedbackp2[:fbG] if feedbackp2[:fbG]
									p2FEEDBACK[:BAD] = feedbackp2[:fbB] if feedbackp2[:fbB]
									p2FEEDBACK[:NEUTRAL] = feedbackp2[:fbN] if feedbackp2[:fbN]
								end
							end
							if p3.length > 0
								feedbackp3 = userFB.find{ |h| h['_id'] == p3.downcase }
								if feedbackp3
									p3FEEDBACK[:GOOD] = feedbackp3[:fbG] if feedbackp3[:fbG]
									p3FEEDBACK[:BAD] = feedbackp3[:fbB] if feedbackp3[:fbB]
									p3FEEDBACK[:NEUTRAL] = feedbackp3[:fbN] if feedbackp3[:fbN]
								end
							end
							if p4.length > 0
								feedbackp4 = userFB.find{ |h| h['_id'] == p4.downcase }
								if feedbackp4
									p4FEEDBACK[:GOOD] = feedbackp4[:fbG] if feedbackp4[:fbG]
									p4FEEDBACK[:BAD] = feedbackp4[:fbB] if feedbackp4[:fbB]
									p4FEEDBACK[:NEUTRAL] = feedbackp4[:fbN] if feedbackp4[:fbN]
								end
							end
							if p5.length > 0
								feedbackp5 = userFB.find{ |h| h['_id'] == p5.downcase }
								if feedbackp5
									p5FEEDBACK[:GOOD] = feedbackp5[:fbG] if feedbackp5[:fbG]
									p5FEEDBACK[:BAD] = feedbackp5[:fbB] if feedbackp5[:fbB]
									p5FEEDBACK[:NEUTRAL] = feedbackp5[:fbN] if feedbackp5[:fbN]
								end
							end
							if p6.length > 0
								feedbackp6 = userFB.find{ |h| h['_id'] == p6.downcase }
								if feedbackp6
									p6FEEDBACK[:GOOD] = feedbackp6[:fbG] if feedbackp6[:fbG]
									p6FEEDBACK[:BAD] = feedbackp6[:fbB] if feedbackp6[:fbB]
									p6FEEDBACK[:NEUTRAL] = feedbackp6[:fbN] if feedbackp6[:fbN]
								end
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

				autozCache = { gamelist: gameDB }

			end

			render json: { gamelist: autozCache[:gamelist] }

		end

		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(params[:poisk]).strip.downcase
			acc = Base64.decode64(params[:acc]).strip
			
			if acc == 'Den888'
				accountsDB = @@userdb[:PS4db_den].find( { _id: troikopoisk } ).to_a.first()
			else
				accountsDB = @@userdb[:PS4db].find( { _id: troikopoisk } ).to_a.first()
			end

			#do stuff when finding acc or not
			if accountsDB && ( Time.now - accountsDB[:DATE].to_time < 63000000 )
				render json: { 
					_id: accountsDB[:_id], GAME: accountsDB[:GAME],
					P2: accountsDB[:P2], P4: accountsDB[:P4],
					poiskwin: true
				}
			else 
				render json: { poiskfail: true}
			end
		end

		def prezaips
			#decode shit
			code = Base64.decode64(params[:bagakruta]).split("~") #0 - position, 1 - gameCODE

			#if viewer registered, count his fb
			if current_user && code.length == 2
				user_d = current_user[:username].downcase

				#delete users zaipsalsq if its old
				zaipsalsq = @@cachedb[:zaipsalsq].find( { _id: user_d } ).to_a.first()

				if zaipsalsq && zaipsalsq[:DATE] != Time.now.strftime("%d")	
					@@cachedb[:zaipsalsq].delete_one( { _id: user_d } )
					zaipsalsq = 0
				end

				user_FB = @@userfb[:userfb].find({ _id: user_d }, projection: { fbG: 1, fbBuG: 1, troikaBAN: 1 }).to_a.first()

				#check if positive feedback or spam exists
				if user_FB && user_FB[:fbG] > 0 && user_FB[:troikaBAN] == 0 && Time.now - current_user[:created_at] > 260000 &&
					( current_user[:username] == 'MrBug' || (zaipsalsq.blank? || zaipsalsq[:count] < 4) )
					#special message if its a p1 zapis with less then 5 mrbug feedback
					if code[0] == "1" && user_FB[:fbBuG] < 5 && current_user[:username] != 'MrBug'
						render json: { piadin: true, fbcount: user_FB[:fbBuG] }
					else
						#get stuff from db
						prezaips = @@gamedb[:gameDB].find( { _id: code[1] }, projection: { imgLINK: 1, imgLINKHQ: 1, gameNAME: 1 } ).to_a.first()
						if prezaips[:imgLINKHQ]
							prezaips[:imgLINK] = prezaips[:imgLINKHQ]
							prezaips.except!("imgLINKHQ")
						end

						prezaips[:position] = code[0]
						prezaips[:winrars] = true

						render json: prezaips
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
				zaipsalsq = @@cachedb[:zaipsalsq].find( { _id: user_d } ).to_a.first()

				if zaipsalsq && zaipsalsq[:DATE] != Time.now.strftime("%d")	
					@@cachedb[:zaipsalsq].delete_one( { _id: user_d } )
					zaipsalsq = 0
				end

				user_FB = @@userfb[:userfb].find({ _id: user_d }, projection: { fbG: 1, fbBuG: 1, troikaBAN: 1 }).to_a.first()

				#do everything checking again!
				if user_FB && user_FB[:fbG] > 0 && user_FB[:troikaBAN] == 0 && Time.now - current_user[:created_at] > 260000 &&
					( current_user[:username] == 'MrBug' || (zaipsalsq.blank? || zaipsalsq[:count] < 4) ) &&
				!(code[0] == "1" && user_FB[:fbBuG] < 5 && current_user[:username] != 'MrBug')
					#increase zaips count for user
					if zaipsalsq && zaipsalsq[:count]
						@@cachedb[:zaipsalsq].find_one_and_update( { _id: user_d }, { 
							"$inc" => { count: 1 }
						}, { upsert: true } )
					else
						@@cachedb[:zaipsalsq].insert_one( { _id: user_d, count: 1, DATE: Time.now.strftime("%d") } )
					end

					#do actual zaips, wohoo
					push = {}
					push["P"+code[0]] = { NAME: current_user[:username], DATE: Time.now.strftime("%Y.%m.%d"), STAT: 0 }

					@@userlistdb[:uListP4].find_one_and_update( { _id: code[2] }, { "$push" => push }, { upsert: true } )

					render json: { winrars: true, position: code[0], gameNAME: code[3] }

					#destroy 4tverki cache
					@@cachedb[:autozCache].drop()


					msgtext = current_user[:username]+" записался на позицию П"+code[0][0]+" совместной покупки "+code[3]
					#add message to old topic
					PostCreator.create(
						Discourse.system_user,
						skip_validations: true,
						topic_id: 61653,
						raw: msgtext
					)

					unless SiteSetting.chat_webhook.empty?
						#add message to discourse chat, if enabled
						begin
							Faraday::Connection.new.post(
								SiteSetting.chat_webhook,
								'text' => msgtext
							) { |request| request.options.timeout = 10 }
						rescue => e
							PostCreator.create(
								Discourse.system_user,
								skip_validations: true,
								topic_id: 61653,
								raw: 'Chat webhook fail: ' + e
							)
						end
					end

					unless SiteSetting.telegram_id.empty? || SiteSetting.metatron_id.empty?
						#add message to telegram bot, if enabled
						begin
							Faraday::Connection.new.post(
								'https://api.telegram.org/bot'+SiteSetting.metatron_id+'/sendMessage',
								{ 'chat_id' => SiteSetting.telegram_id, 'text' => msgtext }
							) { |request| request.options.timeout = 20 }
						rescue => e
							PostCreator.create(
								Discourse.system_user,
								skip_validations: true,
								topic_id: 61653,
								raw: 'TG webhook fail: ' + e
							)
						end
					end

					#create forum notification if sobrano
					#get game userlist
					gameuzers = @@userlistdb[:uListP4].find( _id: code[2] ).to_a.first()
					#find this troika index
					troino = gameuzers["P"+code[0]].count
					troino = troino / 2.0 if code[0] == "4" || code[0] == "4_4" || code[0] == "4_5"
					trindx = troino - 1

					#dont do shit if troika index not full number
					#check if troika sobrana
					if troino.to_i == troino && ( (gameuzers["P2"] && gameuzers["P4_4"] && gameuzers["P4_5"] &&
						gameuzers["P2"][trindx] && gameuzers["P4_4"][trindx*2+1] && gameuzers["P4_5"][trindx*2+1]) ||
					(gameuzers["P2"] && gameuzers["P4"] &&
						gameuzers["P2"][trindx] && gameuzers["P4"][trindx*2+1]) ||
					(gameuzers["P2_4"] && gameuzers["P2_5"] && gameuzers["P4_4"] && gameuzers["P4_5"] &&
						gameuzers["P2_4"][trindx] && gameuzers["P2_5"][trindx] && gameuzers["P4_4"][trindx*2+1] && gameuzers["P4_5"][trindx*2+1]) )
						#add users to userlist
						usernames = ["MrBug"]
						usernames.push(gameuzers[:P1][trindx][:NAME])		if gameuzers[:P1] && gameuzers[:P1][trindx] && gameuzers[:P1][trindx][:STAT] == 0 && gameuzers[:P1][trindx][:NAME] != "-55"
						usernames.push(gameuzers[:P2][trindx][:NAME])		if gameuzers[:P2] && gameuzers[:P2][trindx][:STAT] == 0
						usernames.push(gameuzers[:P4][trindx*2][:NAME])		if gameuzers[:P4] && gameuzers[:P4][trindx*2][:STAT] == 0
						usernames.push(gameuzers[:P4][trindx*2+1][:NAME])	if gameuzers[:P4] && gameuzers[:P4][trindx*2+1][:STAT] == 0
						usernames.push(gameuzers[:P2_4][trindx][:NAME])		if gameuzers[:P2_4] && gameuzers[:P2_4][trindx][:STAT] == 0
						usernames.push(gameuzers[:P2_5][trindx][:NAME])		if gameuzers[:P2_5] && gameuzers[:P2_5][trindx][:STAT] == 0
						usernames.push(gameuzers[:P4_4][trindx*2][:NAME])	if gameuzers[:P4_4] && gameuzers[:P4_4][trindx*2][:STAT] == 0
						usernames.push(gameuzers[:P4_4][trindx*2+1][:NAME])	if gameuzers[:P4_4] && gameuzers[:P4_4][trindx*2+1][:STAT] == 0
						usernames.push(gameuzers[:P4_5][trindx*2][:NAME])	if gameuzers[:P4_5] && gameuzers[:P4_5][trindx*2][:STAT] == 0
						usernames.push(gameuzers[:P4_5][trindx*2+1][:NAME])	if gameuzers[:P4_5] && gameuzers[:P4_5][trindx*2+1][:STAT] == 0
						usernames.uniq!

						hrenka = "Тройка" 	if gameuzers["P2"] && gameuzers["P4"]
						hrenka = "Четверка" 	if gameuzers[:P1] && gameuzers[:P1][trindx]
						hrenka = "Пятерка" 	if gameuzers["P2"] && gameuzers["P4_4"] && gameuzers["P4_5"]
						hrenka = "Шестерка" 	if gameuzers["P2_4"] && gameuzers["P2_5"] && gameuzers["P4_4"] && gameuzers["P4_5"]	

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
						if sostav[0] && (sostav[0].include?("@gmail.com") || sostav[0].include?("@union3.vg")) && sostav[1] && sostav[2] && sostav[3]
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
						if sostav[0] && (sostav[0].include?("@gmail.com") || sostav[0].include?("@union3.vg")) && sostav[1] && sostav[2] && sostav[3] && sostav[4] && sostav[5] && sostav[6]
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
						if sostav[0] && (sostav[0].include?("@gmail.com") || sostav[0].include?("@union3.vg")) && sostav[1] && sostav[2] && sostav[3] && sostav[4] && sostav[5]
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
						user_FB = @@userfb[:userfb].find({ _id: user }, projection: { FEEDBACKS: 1 }).to_a.first()
						#find if we gave user this feedback already
						hasfb = user_FB[:FEEDBACKS].any? {|h| h[:FEEDBACK] == neoFB[:FEEDBACK] && h[:DATE] == daTE } unless user_FB.blank?
						unless hasfb
							#mark that todays fb is uptodate
							@@cachedb[:user_FB_date].find_one_and_update( { _id: user }, { DATE: daTE_day }, { upsert: true } )

							#add to fb, or create new if there no fb
							if user_FB
								#save to db
								@@userfb[:userfb].find_one_and_update( { _id: user }, { 
									"$push" => { FEEDBACKS: neoFB },
									"$inc" => { fbG: 1, fbBuG: 1 }
								}, { upsert: true } )
							else
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
			unless current_user[:trust_level] == 0 || !current_user[:silenced_till].nil?

			feedbacks = { FEEDBACKS: [], fbG: 0, fbN: 0, fbB: 0, fbBuG: 0, fbBuB: 0, fbARC: 0 }
			timeNOW = Time.now; timeDAY = Time.now.strftime("%d"); ugamezfinal = []
			user_d = params[:username].downcase

			#get fb update date
			fbupdate_date = @@cachedb[:user_FB_date].find( { _id: user_d } ).to_a.first()
			#recount user fb, in case its old
			ufbupdate(user_d) if fbupdate_date.blank? || fbupdate_date[:DATE] != timeDAY

			#get userfb
			user_FB = @@userfb[:userfb].find({ _id: user_d }, projection: { FEEDBACKS: 1, fbG: 1, fbN: 1, fbB: 1, fbARC: 1 }).to_a.first()

			#display userfb it it exists
			unless user_FB.blank?
				feedbacks[:FEEDBACKS] = user_FB[:FEEDBACKS]
				feedbacks[:fbG] = user_FB[:fbG]
				feedbacks[:fbN] = user_FB[:fbN]
				feedbacks[:fbB] = user_FB[:fbB]
				feedbacks[:fbARC] = user_FB[:fbARC]
			end

			#get fbglist cache
			fbglist = @@cachedb[:fbglist].find({ _id: user_d }).to_a.first()

			#update chache for this user, if its old
			fbglist = {} if fbglist && fbglist[:DATE] != timeDAY

			#do the games owned display for logged in users only
			if fbglist.blank? && current_user && user_d != 'mrbug'
				#get user games from my database
				user_BGZ = @@userdb[:PS4db].find( 
					{ "$or": [ { P2: params[:username] }, { P4: params[:username] } ] },
					collation: { locale: 'en', strength: 2 }
				).to_a

				#get user games from den database
				user_DGZ = @@userdb[:PS4db_den].find( 
					{ "$or": [ { P2: params[:username] }, { P4: params[:username] } ] },
					collation: { locale: 'en', strength: 2 }
				).to_a

				user_gamez = user_BGZ + user_DGZ
				user_gamez = user_BGZ if user_d == 'den888'

				#do stuff if we have some
				user_gamez.each do |ugaz| #do stuff if we have some
					if timeNOW - ugaz[:DATE].to_time < 63000000 && ugaz[:P2] && ugaz[:P4]
						#select acc mail between + and @, \+ and \@
						if ugaz[:den]
							aCC = 'Den888'
						else
							aCC = ugaz[:_id][/\+(.*?)\@/m, 1]
						end

						#get positions list
						poZz = []
						poZz.push( 2 ) if ugaz[:P2][0] && ugaz[:P2][0].downcase == user_d
						poZz.push( 2 ) if ugaz[:P2][1] && ugaz[:P2][1].downcase == user_d
						poZz.push( 4 ) if ugaz[:P4][0] && ugaz[:P4][0].downcase == user_d
						poZz.push( 4 ) if ugaz[:P4][1] && ugaz[:P4][1].downcase == user_d
						poZz.push( 4 ) if ugaz[:P4][2] && ugaz[:P4][2].downcase == user_d
						poZz.push( 4 ) if ugaz[:P4][3] && ugaz[:P4][3].downcase == user_d

						#create final variable
						ugamezfinal.push( { gNAMEid: ugaz[:_id], gNAME: ugaz[:GAME], poZ: poZz, aCC: aCC } ) 
					end
				end

				#do sorting web side? eeeh... cached anyway...
				ugamezfinal.sort_by! { |k| k[:gNAME].downcase }

				fbglist = { ugameZ: ugamezfinal }

				#save it to cache
				@@cachedb[:fbglist].find_one_and_update( { _id: user_d }, {
					ugameZ: ugamezfinal, DATE: timeDAY
				}, { upsert: true } )
			end

			#show for logged in users only
			feedbacks[:ugameZ] = fbglist[:ugameZ] unless fbglist.blank? 

			#render fb
			render json: feedbacks

			end #unless end
		end

		def zafeedback
			unless current_user[:trust_level] == 0 || !current_user[:silenced_till].nil?

			#decode shit
			fedbacks = Base64.decode64(params[:fedbakibaki]).split("~") #0 - mode, 1 - score, 2 - otziv
			fedbacks[1] = fedbacks[1].to_i
			user_d = current_user[:username].downcase
			pageu_d = params[:username].downcase
			timeNOW = Time.now.strftime("%Y.%m.%d")

			#page owners and guests cant do feedbacks!
			if current_user && fedbacks.length == 3 && user_d != pageu_d && (fedbacks[0] == "true" || fedbacks[0] == "false" )

				#get poster fb
				user_FB = @@userfb[:userfb].find({ _id: user_d }, projection: { FEEDBACKS: 1, fbB: 1 }).to_a.first()

				#users with negative feedbacks cant do feedbacks!
				if user_FB && user_FB[:fbB] > 0
					render json: { bakas: true }
				else

					#get user fb
					pageu_FB = @@userfb[:userfb].find({ _id: pageu_d }).to_a.first()

					#do normal feedback add
					if fedbacks[0] == "true"

						#if gave feedback already, show stuff
						if pageu_FB && pageu_FB[:FEEDBACKS] && pageu_FB[:FEEDBACKS].any? {|h| h[:pNAME] == current_user[:username] && h[:DATE] == timeNOW} && current_user[:username] != 'MrBug'
							render json: { gavas_z: true }
						else
							new_fb = {
								FEEDBACK: fedbacks[2].strip,
								pNAME: current_user[:username],
								DATE: timeNOW,
								SCORE: fedbacks[1]
							}

							#if fb exists, add to it, or create new fb if its not
							@@userfb[:userfb].find_one_and_update( { _id: pageu_d }, { "$push" => { FEEDBACKS: new_fb } }, { upsert: true } )

							#update and recount fb
							ufbupdate(pageu_d)

							render json: { winrars_z: true }
						end

					#or edit last feedback given
					elsif fedbacks[0] == "false"

						#find last feedback and see if we edited it already today
						pageu_FB[:FEEDBACKS].reverse_each do |fb|
							#if found, do stuff
							if fb[:pNAME] == current_user[:username]
								#if edited feedback already, show stuff
								user_FB_edit = @@cachedb[:user_FB_edit].find( { _id: pageu_d+user_d } ).to_a.first()
								if user_FB_edit && user_FB_edit[:DATE] == timeNOW
									render json: { gavas_e: true }
								else
									fb[:FEEDBACK] = fedbacks[2].strip
									fb[:SCORE] = fedbacks[1]

									#make edited mark
									@@cachedb[:user_FB_edit].find_one_and_update( { _id: pageu_d+user_d }, { DATE: timeNOW }, { upsert: true } )

									@@userfb[:userfb].replace_one( { _id: pageu_d }, pageu_FB )

									#update and recount fb
									ufbupdate(pageu_d)

									render json: { winrars_e: true }

								end
								#stop loop
								break
							end
						end
					end

				end

			else #if that is a guest or a page owner... thats really really wrong...
				render json: { fail: true }
				puts "###Warning!!!### "+current_user[:username]+" is hacking otzivs!"
			end

			end #unless end
		end

		def zapass
			unless current_user[:trust_level] == 0 || !current_user[:silenced_till].nil?

			dukan = false
			user_d = current_user[:username].downcase

			#recheck if username is in database... just in case... might be a bit unnecessary... but if old page was used...
			user_BGZ = @@userdb[:PS4db].find( 
				{ id: Base64.decode64(params[:myylo]), "$or": [ { P2: user_d }, { P4: user_d } ] },
				projection: { _id: 1 }, collation: { locale: 'en', strength: 2 }
			).to_a

			#only page owners can do zapass!
			if current_user && params[:myylo] && user_d == params[:username].downcase && user_BGZ
				timeNOW = Time.now
				#check fb to see if eligible to get pass
				inputfb = @@userfb[:userfb].find({ _id: user_d }).to_a.first()
				inputfb[:FEEDBACKS].each do |fb|
					#look for my recent fb
					if fb[:pNAME] == "MrBug" && ( timeNOW - fb[:DATE].to_time < 15800000 )
						dukan = true
						break
					end
				end
				
				if dukan
					#get how many pass times from cache db
					user_apasaz = @@cachedb[:user_passzss].find( { _id: user_d } ).to_a.first()

					#if already asked pass today, message something about it
					if user_apasaz && user_apasaz[:DATE] == Time.now.strftime("%Y.%m.%d") && user_apasaz[:MAIL] != params[:myylo]
						render json: { spam: true }
					else #if first time ask pass today, go
						begin
							res = Faraday::Connection.new.post('http://'+SiteSetting.pbot_ip+'/get_passzss', 'myylo' => params[:myylo]) { |request| request.options.timeout = 10 }
							if res.status == 200
								#message pass to user
								render json: { winrar: Base64.decode64(res.body) }

								#add any pass times to cache db
								@@cachedb[:user_passzss].find_one_and_update( { _id: user_d }, { DATE: Time.now.strftime("%Y.%m.%d"), MAIL: params[:myylo] }, { upsert: true } )
							else
								#message something about failure
								render json: { noconnect: true, status: res.status[0..30] }
							end
						rescue => e
							#message something about error
							render json: { error: true, status: e[0..30] }
						end
					end
				else
					#message something about not having fb
					render json: { noufb: true }
				end
			else #if that is a guest or not a page owner... thats really really wrong...
				render json: { fail: true }
				puts "###Warning!!!### "+current_user[:username]+" is hacking passzss!"
			end

			else #message something about ban
				render json: { banned: true }
			end
		end

		def rentagama
			#get cache
			rentaCache = @@cachedb[:rentaCache].find().to_a.first()

			#drop chache if it exists and is old
			( @@cachedb[:rentaCache].drop(); rentaCache = {} ) if rentaCache && Time.now - rentaCache[:TIME] > 1800

			if rentaCache.blank?
				finalrenta = { rentaGAMEZ: [], rentaGAMEZ1: [], rentaGAMEZ2: [] }
				count = [0,0,0,0,0] # #0 - vsego, #1 - type 1, #2 - type 2, #3 - type 3, #4 - type 4

				#find all rentagamez
				@@rentadb[:rentagadb].find().to_a.each do |games|
					gTYPE = [false,false,false,false]
					count[0] += 1
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
						finalrenta[:rentaGAMEZ].push( gameojb )
						finalrenta[:rentaGAMEZ1].push( gameojb ) if games[:GTYPE] == 1 || games[:GTYPE] == 4
						finalrenta[:rentaGAMEZ2].push( gameojb ) if games[:GTYPE] == 2 || games[:GTYPE] == 3
					end
				end
				finalrenta[:count] = count
				finalrenta[:TIME] = Time.now

				#sort this shit
				finalrenta[:rentaGAMEZ].sort_by! { |k| [-k[:GNEW], k[:GNAME].downcase] }
				finalrenta[:rentaGAMEZ1].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }
				finalrenta[:rentaGAMEZ2].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }

				rentaCache = finalrenta

				#save cache to db
				@@cachedb[:rentaCache].insert_one( finalrenta )
			end

			render json: rentaCache
		end

		#very cute fb update method
		def ufbupdate(uzar)
			inputfb = @@userfb[:userfb].find({ _id: uzar }).to_a.first()

			if inputfb && inputfb[:FEEDBACKS]
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

				#mark that todays fb is uptodate
				@@cachedb[:user_FB_date].find_one_and_update( { _id: uzar }, { DATE: Time.now.strftime("%d") }, { upsert: true } )

				#update shit if numbers are different
				if feedbacks[:fbG] != inputfb[:fbG] || feedbacks[:fbN] != inputfb[:fbN] || feedbacks[:fbB] != inputfb[:fbB] ||
				feedbacks[:fbBuG] != inputfb[:fbBuG] || feedbacks[:fbBuB] != inputfb[:fbBuB] || feedbacks[:fbARC] != inputfb[:fbARC]
					#save to db
					@@userfb[:userfb].replace_one( { _id: inputfb[:_id] }, { FEEDBACKS: newfbarray, troikaBAN: feedbacks[:troikaBAN],
						fbG: feedbacks[:fbG], fbN: feedbacks[:fbN], fbB: feedbacks[:fbB],
						fbBuG: feedbacks[:fbBuG], fbBuB: feedbacks[:fbBuB], fbARC: feedbacks[:fbARC] }, { upsert: true } )
				end
			end
		end

	end

end
