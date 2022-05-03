# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'
require 'base64'
require 'net/http'
require 'uri'

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
		post '/posos' => 'mrbug#ufbupdate'
	end

	class ::MrbugController < ::ApplicationController

		SiteSetting.site_ip = 'union3.vg' if SiteSetting.site_ip.empty?

		db = Mongo::Client.new([ SiteSetting.site_ip+':33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@cache = db.use('AutoZ_cache')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')

		@@rentadb = Mongo::Client.new([ SiteSetting.site_ip+':33775' ], database: 'rentagadb', user: 'rentaga', password: 'A75Z3E9R66' )

		@@userdb2 = Mongo::Client.new([ SiteSetting.site_ip+':33775' ], database: 'userdb', user: 'megaadd', password: '3HXED926MT' )
		@@userfb2 = @@userdb2.use('userfb')

		def show
			#variables, duh
			finalvar = {}; finalvar[:qzstuff] = false; fbcount = 0; timeNOW = Time.now
			#cache vars
			gamelist = []

			#get cache from db, drop it if its old
			cacheDB = @@cache[:cache].find().to_a
			if cacheDB[0]
				if timeNOW - cacheDB[0][:TIME] > 900
					@@cache[:cache].drop()
				else
					gamelist = cacheDB[0][:gamelist]
				end
			end

			if gamelist.empty?
				#get all type 123 games
				gameDB = @@gamedb[:gameDB].find( { TYPE: { "$in": [1,2,3] } }, projection: { imgLINKHQ: 0 } ).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a
				#get all users 2 list
				userDB = @@userlistdb[:uListP4].find().to_a
				#get all user feedbacks
				userFB = @@userfb[:userfb].find( {}, projection: { FEEDBACKS: 0, troikaBAN: 0, fbBuG: 0, fbBuB: 0 } ).to_a

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
							troikaNO = [p1NO, p2NO.ceil, p3NO.ceil].max-1
						elsif game[:TTYPE][1]
							p1NO = users[:P1].length if users[:P1]
							p2NO = users[:P2].length if users[:P2]
							p3NO = users[:P4].length / 2.0 if users[:P4] #fix because 2 P4 per troika
							#get how many troikas, roundup p4 number cos theres 2 per troika
							troikaNO = [p1NO, p2NO, p3NO.ceil].max-1
						else
							p1NO = users[:P2_4].length if users[:P2_4]
							p2NO = users[:P2_5].length if users[:P2_5]
							p3NO = users[:P4_4].length / 2.0 if users[:P4_4] #fix because 2 P4 per troika
							p4NO = users[:P4_5].length / 2.0 if users[:P4_5] #fix because 2 P4 per troika
							#get how many troikas, roundup p4 number cos theres 2 per troika
							troikaNO = [p1NO, p2NO, p3NO.ceil, p4NO.ceil].max-1
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
							if users[(i+1).to_s]
								account = users[(i+1).to_s][:ACCOUNT] if users[(i+1).to_s][:ACCOUNT]
							end

							#template again, is feedback green or red?
							p1FBred = true if p1FEEDBACK[:PERCENT] < 100
							p2FBred = true if p2FEEDBACK[:PERCENT] < 100
							p3FBred = true if p3FEEDBACK[:PERCENT] < 100
							p4FBred = true if p4FEEDBACK[:PERCENT] < 100
							p5FBred = true if p5FEEDBACK[:PERCENT] < 100
							p6FBred = true if p6FEEDBACK[:PERCENT] < 100

							#vizmem bez p1?!
							nop1ADD = (game[:P4PRICE1] / 30.0).ceil * 10 if game[:CONSOLE] == "PS5" && !game[:CONSOLE2] && p1 == ''

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

					#set display user numbers since we are looping through all games
					game[:P1NO] = p1NO; game[:P2NO] = p2NO; game[:P3NO] = p3NO; game[:P4NO] = p4NO

				end

				#save cache to db
				gamelist = gameDB
				@@cache[:cache].insert_one({ 
					gamelist: gameDB, TIME: timeNOW
				})
			end

			#make 3 variables for each game type
			finalvar[:gamedb1] = []; finalvar[:gamedb2] = []; finalvar[:gamedb3] = []
			finalvar[:maigamez1] = []; finalvar[:maigamez2] = []

			gamelist.each do |game|
				#if not guest, check if user is in this troika
				if current_user
					#template shit for type 2 and 3 games displaying type 2 and 3 stuff
					gTYPE2 = false; gTYPE3 = false
					gTYPE2 = true if game[:TYPE] == 2
					gTYPE3 = true if game[:TYPE] == 3

					#loop thorought troikas and see if current user is in it
					game[:TROIKI].each do |troika|
						troika[:MODE1] = false; troika[:MODE2] = false

						#calculate if user is in this troika, if he is, add user + gname to list, also gamechangecolor = true, troika change color = true
						for i in 0..5
							if current_user[:username] == troika[:USERS][i]
								if troika[:PSTATUS][i][0]
									game[:MODE1] = true; troika[:MODE1] = true
									finalvar[:maigamez1].push( {
										POSITION: game[:PPOSITIONS][i], gNAME: game[:gameNAME], gPIC: game[:imgLINK], PRICE: game[:PPRICES][i],
										P1ADD: troika[:NOP1ADD], DATE: game[:DATE], TYPE2: gTYPE2, TYPE3: gTYPE3
									} )
								else
									game[:MODE2] = true if !game[:MODE1]
									troika[:MODE2] = true if !troika[:MODE1]
									finalvar[:maigamez2].push( { POSITION: game[:PPOSITIONS][i], gNAME: game[:gameNAME], gPIC: game[:imgLINK] } )
								end
							end
						end
					end
				end
				#fill 3 variables for each game type
				finalvar[:gamedb1].push(game.except("PRICE", "TYPE", "PPOSITIONS", "PPRICES")) if game[:TYPE] == 1
				finalvar[:gamedb2].push(game.except("PRICE", "TYPE", "PPOSITIONS", "PPRICES")) if game[:TYPE] == 2
				finalvar[:gamedb3].push(game.except("PRICE", "TYPE", "PPOSITIONS", "PPRICES")) if game[:TYPE] == 3
			end
			
			render json: finalvar

		end

		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(params[:input]).strip.downcase
			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40
				zapislist = @@userdb[:PS4db].find( { _id: troikopoisk } ).to_a
				if zapislist[0] && ( Time.now - zapislist[0][:DATE].to_time < 63000000 )
					zapislist[0].except!(:DATE)
					zapislist[0][:poiskwin] = true
					render json: zapislist[0]
				else
					render json: { poiskfail: true }
				end

			else 
				render json: { poiskfail: true }
			end
		end 

		def prezaips
			#decode shit
			code = Base64.decode64(params[:bagakruta]).split("~") #0 - position, 1 - gameCODE
			#if viever registered, count his fb
			if current_user && code.length == 2
				fbcount = 0
				fbcount2 = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase }, projection: { troikaBAN: 1, fbBuG: 1, fbG: 1 } ).to_a
				if feedback[0]
					if feedback[0][:troikaBAN] && feedback[0][:troikaBAN] == 1
						fbcount = 777
					else
						fbcount = feedback[0][:fbBuG]
					end
					fbcount2 = feedback[0][:fbG]
				end

				#antibotbaby!!!
				if fbcount2 == 0 || Time.now - current_user[:created_at] < 260000
					fbcount = 777
				end

				#antispambaby!!!
				#will do later ;)

				if fbcount < 5 && code[0] == "1" && current_user[:username] != 'MrBug'
					render json: { piadin: true, fbcount: fbcount }
				elsif fbcount == 777
					render json: { banned: true }
				else
					#find and count how many times user zaipsalsq
					zcount = 0
					gameuzers = @@userlistdb[:uListP4].find( _id: code[1] ).to_a
					if gameuzers[0] && gameuzers[0]["P"+code[0]]
						gameuzers[0]["P"+code[0]].each do |user|
							if user[:NAME] == current_user[:username]
								zcount = zcount + 1
							end
						end
					end
					if zcount > 2
						render json: { banned: true }
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
				#count feedbacks, again!
				fbcount = 0
				fbcount2 = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase }, projection: { troikaBAN: 1, fbBuG: 1, fbG: 1 } ).to_a
				if feedback[0]
					if feedback[0][:troikaBAN] && feedback[0][:troikaBAN] == 1
						fbcount = 777
					else
						fbcount = feedback[0][:fbBuG]
					end
					fbcount2 = feedback[0][:fbG]
				end

				#antibotbaby!!!
				if fbcount2 == 0 || Time.now - current_user[:created_at] < 260000
					fbcount = 777
				end

				#antispambaby!!!
				#will do later ;)

				if ( fbcount < 5 && code[0] == "1" && current_user[:username] != 'MrBug' ) || fbcount == 777
					render json: { zaipsfail: true }
				else
					#find and count how many times user zaipsalsq
					zcount = 0
					gameuzers = @@userlistdb[:uListP4].find( _id: code[2] ).to_a
					if gameuzers[0] && gameuzers[0]["P"+code[0]]
						gameuzers[0]["P"+code[0]].each do |user|
							if user[:NAME] == current_user[:username]
								zcount = zcount + 1
							end
						end
					end
					if zcount > 2
						render json: { zaipsfail: true }
					else
						#do actual zaips, wohoo
						push = {}
						push["P"+code[0]] = { NAME: current_user[:username], DATE: Time.now.strftime("%Y.%m.%d"), STAT: 0 }
						@@userlistdb[:uListP4].find_one_and_update( { _id: code[2] }, { "$push" => push }, { upsert: true } )
						zaips = { winrars: true, position: code[0], gameNAME: code[3] }
						#destroy cache
						@@cache[:cache].drop()

						render json: zaips

						#add message to chat
						PostCreator.create(
							Discourse.system_user,
							skip_validations: true,
							topic_id: 61653,
							raw: current_user[:username]+" записался на позицию П"+code[0][0]+" совместной покупки "+code[3]
						)

						#add message to telegram bot, if enabled
						unless SiteSetting.metatron_id.empty? || SiteSetting.telegram_id.empty?
							tgurl = "https://api.telegram.org/bot"+SiteSetting.metatron_id+"/sendMessage?chat_id="+SiteSetting.telegram_id+"&text="+current_user[:username]+" записался на позицию П"+code[0][0]+" совместной покупки "+code[3]
							Net::HTTP.get URI.parse(URI.encode(tgurl.force_encoding('ASCII-8BIT')))
						end

						#create notification if sobrano
						if gameuzers[0]
							#get game info from db to determine if were on ps4, ps5, ps4\ps5 type of game
							thisgame = @@gamedb[:gameDB].find( { _id: code[2] }, projection: { TYPE:1, DATE:1, CONSOLE:1, CONSOLE2:1 } ).to_a

							#count index of this troika
							if gameuzers[0]["P"+code[0]]
								troino = gameuzers[0]["P"+code[0]].count + 1
							else
								troino = 1
							end
							troino = troino / 2.0 if code[0] == "4" || code[0] == "4_4" || code[0] == "4_5"
							trindx = troino - 1

							#awful unoptimized mess
							if thisgame[0][:CONSOLE] == "PS4" && !thisgame[0][:CONSOLE2]
								if (code[0] == "2" && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"] &&
									gameuzers[0]["P4_4"][trindx*2+1] && gameuzers[0]["P4_5"][trindx*2+1]) ||
								(code[0] == "4_4" && troino.to_i == troino && gameuzers[0]["P2"] && gameuzers[0]["P4_5"] &&
									gameuzers[0]["P2"][trindx] && gameuzers[0]["P4_5"][trindx*2+1] ) ||
								(code[0] == "4_5" && troino.to_i == troino && gameuzers[0]["P2"] && gameuzers[0]["P4_4"] &&
									gameuzers[0]["P2"][trindx] && gameuzers[0]["P4_4"][trindx*2+1])
									#dont do shit if its a preorder thats more then a month away
									unless thisgame[0][:TYPE] == 3 && thisgame[0][:DATE].to_time - Time.now > 2600000
										usernames = ["MrBug" , current_user[:username]]
										usernames.push(gameuzers[0][:P2][trindx][:NAME])	if code[0] != "2" && gameuzers[0][:P2] && gameuzers[0][:P2][trindx] && gameuzers[0][:P2][trindx][:STAT] == 0
										usernames.push(gameuzers[0][:P4_4][trindx*2][:NAME])	if gameuzers[0][:P4_4][trindx*2] && gameuzers[0][:P4_4][trindx*2][:STAT] == 0
										usernames.push(gameuzers[0][:P4_4][trindx*2+1][:NAME])	if code[0] != "4_4" && gameuzers[0][:P4_4][trindx] && gameuzers[0][:P4_4][trindx][:STAT] == 0
										usernames.push(gameuzers[0][:P4_5][trindx*2][:NAME])	if gameuzers[0][:P4_5][trindx*2] && gameuzers[0][:P4_5][trindx*2][:STAT] == 0
										usernames.push(gameuzers[0][:P4_5][trindx*2+1][:NAME])	if code[0] != "4_5" && gameuzers[0][:P4_5][trindx*2+1] && gameuzers[0][:P4_5][trindx*2+1][:STAT] == 0
										usernames = usernames.uniq

										troititle = "Пятерка на " + code[3] + " собрана! Ждем оплату!"
										troitext = "Здравствуйте! :robot:\n" +
										"Случилось невероятное! Пятерка на " + code[3] + " собрана.\n" +
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
								end
							elsif ( thisgame[0][:CONSOLE] == "PS5" && !thisgame[0][:CONSOLE2] ) || ( thisgame[0][:CONSOLE] == "PS4" && thisgame[0][:CONSOLE2] == "XXX" )
								if (code[0] == "1" && gameuzers[0]["P2"] && gameuzers[0]["P4"] &&
									gameuzers[0]["P2"][trindx] && gameuzers[0]["P4"][trindx*2+1]) ||
								(code[0] == "2" && gameuzers[0]["P4"] &&
									gameuzers[0]["P4"][trindx*2+1]) ||
								(code[0] == "4" && troino.to_i == troino && gameuzers[0]["P2"] &&
									gameuzers[0]["P2"][trindx])
									#dont do shit if its a preorder thats more then a month away
									unless thisgame[0][:TYPE] == 3 && thisgame[0][:DATE].to_time - Time.now > 2600000
										usernames = ["MrBug" , current_user[:username]]
										usernames.push(gameuzers[0][:P1][trindx][:NAME])	if code[0] != "1" && gameuzers[0][:P1] && gameuzers[0][:P1][trindx] && gameuzers[0][:P1][trindx][:STAT] == 0 && gameuzers[0][:P1][trindx][:NAME] != "-55"
										usernames.push(gameuzers[0][:P2][trindx][:NAME])	if code[0] != "2" && gameuzers[0][:P2][trindx] && gameuzers[0][:P2][trindx][:STAT] == 0
										usernames.push(gameuzers[0][:P4][trindx*2][:NAME])	if gameuzers[0][:P4][trindx*2] && gameuzers[0][:P4][trindx*2][:STAT] == 0
										usernames.push(gameuzers[0][:P4][trindx*2+1][:NAME])	if code[0] != "4" && gameuzers[0][:P4][trindx*2+1] && gameuzers[0][:P4][trindx*2+1][:STAT] == 0
										usernames = usernames.uniq

										if ( gameuzers[0][:P1] && gameuzers[0][:P1][trindx] && gameuzers[0][:P1][trindx][:NAME] != "-55" ) || code[0] == "1"
											troititle = "Четверка на " + code[3] + " собрана! Ждем оплату!"
											troitext = "Здравствуйте! :robot:\n" +
											"Случилось невероятное! Четверка на " + code[3] + " собрана.\n" +
											"Этого не должно было произойти, но придется теперь как-то с этим жить :robot:\n\n" +
											"Вот план дальнейших действий:\n" +
											"1) Оплатить свою позицию, суммы и реквизиты указаны [на странице четверок, в начале страницы](/MrBug)\n" +
											"2) Сразу же нажать кнопку 'ответить' под этим сообщением и сообщить что вы оплатили\n" +
											"3) Ознакомиться с [инструкциями в разделе FAQ](/faq)\n" +
											"4) Написать в общем чате как вам не повезло с товарищами по составу\n\n" +
											"Держитесь! И да поможет вам :bug:"
										else
											troititle = "Тройка на " + code[3] + " собрана! Ждем оплату!"
											troitext = "Здравствуйте! :robot:\n" +
											"Случилось невероятное! Тройка на " + code[3] + " собрана.\n" +
											"Этого не должно было произойти, но придется теперь как-то с этим жить :robot:\n\n" +
											"Вот план дальнейших действий:\n" +
											"1) Оплатить свою позицию с учетом отсутствующего П1, суммы и реквизиты указаны [на странице четверок, в начале страницы](/MrBug)\n" +
											"2) Сразу же нажать кнопку 'ответить' под этим сообщением и сообщить что вы оплатили\n" +
											"3) Ознакомиться с [инструкциями в разделе FAQ](/faq)\n" +
											"4) Написать в общем чате как вам не повезло с товарищами по составу\n\n" +
											"Держитесь! И да поможет вам :bug:"
										end

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
								end
							else
								if (code[0] == "2_4" && gameuzers[0]["P2_5"] && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"] &&
									gameuzers[0]["P2_5"][trindx] && gameuzers[0]["P4_4"][trindx*2+1] && gameuzers[0]["P4_5"][trindx*2+1]) ||
								(code[0] == "2_5" && gameuzers[0]["P2_4"] && gameuzers[0]["P4_4"] && gameuzers[0]["P4_5"] &&
									gameuzers[0]["P2_4"][trindx] && gameuzers[0]["P4_4"][trindx*2+1] && gameuzers[0]["P4_5"][trindx*2+1]) ||
								(code[0] == "4_4" && troino.to_i == troino && gameuzers[0]["P2_4"] && gameuzers[0]["P2_5"] && gameuzers[0]["P4_5"] &&
									gameuzers[0]["P2_4"][trindx] && gameuzers[0]["P2_5"][trindx] && gameuzers[0]["P4_5"][trindx*2+1] ) ||
								(code[0] == "4_5" && troino.to_i == troino && gameuzers[0]["P2_4"] && gameuzers[0]["P2_5"] && gameuzers[0]["P4_4"] &&
									gameuzers[0]["P2_4"][trindx] && gameuzers[0]["P2_5"][trindx] && gameuzers[0]["P4_4"][trindx*2+1])
									#dont do shit if its a preorder thats more then a month away
									unless thisgame[0][:TYPE] == 3 && thisgame[0][:DATE].to_time - Time.now > 2600000
										usernames = ["MrBug" , current_user[:username]]
										usernames.push(gameuzers[0][:P2_4][trindx][:NAME])	if code[0] != "2_4" && gameuzers[0][:P2_4] && gameuzers[0][:P2_4][trindx] && gameuzers[0][:P2_4][trindx][:STAT] == 0
										usernames.push(gameuzers[0][:P2_5][trindx][:NAME])	if code[0] != "2_5" && gameuzers[0][:P2_5] && gameuzers[0][:P2_5][trindx] && gameuzers[0][:P2_5][trindx][:STAT] == 0
										usernames.push(gameuzers[0][:P4_4][trindx*2][:NAME])	if gameuzers[0][:P4_4][trindx*2] && gameuzers[0][:P4_4][trindx*2][:STAT] == 0
										usernames.push(gameuzers[0][:P4_4][trindx*2+1][:NAME])	if code[0] != "4_4" && gameuzers[0][:P4_4][trindx] && gameuzers[0][:P4_4][trindx][:STAT] == 0
										usernames.push(gameuzers[0][:P4_5][trindx*2][:NAME])	if gameuzers[0][:P4_5][trindx*2] && gameuzers[0][:P4_5][trindx*2][:STAT] == 0
										usernames.push(gameuzers[0][:P4_5][trindx*2+1][:NAME])	if code[0] != "4_5" && gameuzers[0][:P4_5][trindx*2+1] && gameuzers[0][:P4_5][trindx*2+1][:STAT] == 0
										usernames = usernames.uniq

										troititle = "Шестерка на " + code[3] + " собрана! Ждем оплату!"
										troitext = "Здравствуйте! :robot:\n" +
										"Случилось невероятное! Шестерка на " + code[3] + " собрана.\n" +
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
								end
							end
						end
					end
				end
			else
				render json: { zaipsfail: true }
			end
		end

		def showadd
			render json: { HiMom: "!!!" }
		end

		def megaadd
			addstuff = {}, feedbacks = [], chetverk = ''
			addstuff = params
			addstuff[:RESULT] = []
			if current_user && current_user[:username] == 'H1tomaru' && addstuff[:GAME] && addstuff[:STRING]
				#regex string #1: remove lines with P1, #2: remove stuff left of " - ", #3: remove prices like "(800 рублей)", #4: make proper new lines
				addstuff[:NEWSTRING] = addstuff[:STRING].gsub(/^.*П1 - .*$/,"").gsub(/^.* - /,"").gsub(/(\()(.*)(\))/,"").gsub(/^\s*[\r\n]/,"").split("\n")
				#check if were doing p2p4p4, p2p4p4p4p4 or p2p2p4p4p4p4
				if (addstuff[:STRING].include? "П4") && (addstuff[:STRING].exclude? "П4_5")
					chetverk = 'четверке'
					#p2p4p4 version
					addstuff[:NEWSTRING].each_slice(4) do |sostav|
						if sostav[0] && (sostav[0].include? "gmail.com") && sostav[1] && sostav[2] && sostav[3]
							addstuff[:winrarP244] = true
							for i in 1..3
								sostav[i] = sostav[i].split(" ---> ").map { |item| item.strip }
							end
							addstuff[:RESULT].push({ GAME: addstuff[:GAME].strip, Mail: sostav[0].strip, П2: [sostav[1].last], П4: [sostav[2].last, sostav[3].last] })
							@@userdb2[:PS4db].replace_one( { _id: sostav[0].strip }, {
								_id: sostav[0].strip, GAME: addstuff[:GAME].strip,
								P2: [sostav[1].last], P4: [sostav[2].last, sostav[3].last],
								DATE: Time.now.strftime("%Y.%m.%d")
								}, { upsert: true } )
							#add those users to a list of users to give them feedback after, if were giving it
							feedbacks.push(sostav[1].last, sostav[2].last, sostav[3].last) if addstuff[:ADDFB]
						end
					end
				elsif (addstuff[:STRING].include? "П4_5") && (addstuff[:STRING].include? "П2_5")
					chetverk = 'шестерке'
					#p2p2p4p4p4p4 version
					addstuff[:NEWSTRING].each_slice(7) do |sostav|
						if sostav[0] && (sostav[0].include? "gmail.com") && sostav[1] && sostav[2] && sostav[3] && sostav[4] && sostav[5] && sostav[6]
							addstuff[:winrarP224444] = true
							for i in 1..6
								sostav[i] = sostav[i].split(" ---> ").map { |item| item.strip }
							end
							addstuff[:RESULT].push({ GAME: addstuff[:GAME].strip, Mail: sostav[0].strip, П2: [sostav[1].last, sostav[2].last], П4: [sostav[3].last, sostav[4].last, sostav[5].last, sostav[6].last] })
							@@userdb2[:PS4db].replace_one( { _id: sostav[0].strip }, {
								_id: sostav[0].strip, GAME: addstuff[:GAME].strip,
								P2: [sostav[1].last, sostav[2].last], P4: [sostav[3].last, sostav[4].last, sostav[5].last, sostav[6].last],
								DATE: Time.now.strftime("%Y.%m.%d")
								}, { upsert: true } )
							#add those users to a list of users to give them feedback after, if were giving it
							feedbacks.push(sostav[1].last, sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last, sostav[6].last) if addstuff[:ADDFB]
						end
					end
				else
					chetverk = 'пятерке'
					#p2p4p4p4p4 version
					addstuff[:NEWSTRING].each_slice(6) do |sostav|
						if sostav[0] && (sostav[0].include? "gmail.com") && sostav[1] && sostav[2] && sostav[3] && sostav[4] && sostav[5]
							addstuff[:winrarP24444] = true
							for i in 1..5
								sostav[i] = sostav[i].split(" ---> ").map { |item| item.strip }
							end
							addstuff[:RESULT].push({ GAME: addstuff[:GAME].strip, Mail: sostav[0].strip, П2: [sostav[1].last], П4: [sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last] })
							@@userdb2[:PS4db].replace_one( { _id: sostav[0].strip }, {
								_id: sostav[0].strip, GAME: addstuff[:GAME].strip,
								P2: [sostav[1].last], P4: [sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last],
								DATE: Time.now.strftime("%Y.%m.%d")
								}, { upsert: true } )
							#add those users to a list of users to give them feedback after, if were giving it
							feedbacks.push(sostav[1].last, sostav[2].last, sostav[3].last, sostav[4].last, sostav[5].last) if addstuff[:ADDFB]
						end
					end
				end

				render json: addstuff

				#add feedback if we're doing it
				if addstuff[:ADDFB] == 'true'
					#delete duplicate users
					feedbacks = feedbacks.uniq
					feedbacks.each do |user|
						#find if we gave user this feedback already
						ufb = @@userfb[:userfb].find( { _id: user.downcase }, projection: { FEEDBACKS: 1 } ).to_a
						if ufb[0]
							hasfb = ufb[0][:FEEDBACKS].any? {|h| h[:FEEDBACK] == "Участвовал в "+chetverk+" на "+addstuff[:GAME].strip+". Всё отлично!" && h[:DATE] == Time.now.strftime("%Y.%m.%d")}
						end
						unless hasfb
							@@userfb2[:userfb].find_one_and_update( { _id: user.downcase }, { "$push" => { 
								FEEDBACKS: {
									FEEDBACK: "Участвовал в "+chetverk+" на "+addstuff[:GAME].strip+". Всё отлично!",
									pNAME: "MrBug",
									DATE: Time.now.strftime("%Y.%m.%d"),
									SCORE: 1
								}
							} }, { upsert: true } )
						end
					end
				end
			end
		end

		def feedbacks
			feedbacks = { FEEDBACKS: [], FEEDBACKS2: [], MENOSHO: true, fbG: 0, fbN: 0, fbB: 0, fbBuG: 0, fbBuB: 0, fbARC: 0, uZar: params[:username] }
			newfbarray = []; updfbarray = []; update = false; fbedit = false; timeNOW = Time.now

			#page owners cant do feedbacks!
			if current_user
				feedbacks[:MENOSHO] = false if current_user[:username].downcase == params[:username].downcase
			end

			#get feedbacks from my database
			userfb = @@userfb[:userfb].find( { _id: params[:username].downcase } ).to_a
			
			#get deleted feedback number if it exists
			feedbacks[:fbARC] = userfb[0][:fbARC] if userfb[0] && userfb[0][:fbARC]

			#if found, go
			if userfb[0] && userfb[0][:FEEDBACKS] && userfb[0][:FEEDBACKS].any?
				#remove duplicates
				update = true if userfb[0][:FEEDBACKS].uniq!

				#create key if it doesnt exist yet
				userfb[0][:troikaBAN] = 0 unless userfb[0].key?("troikaBAN")

				#count it and check if numbers match
				userfb[0][:FEEDBACKS].reverse_each do |fb|
					#look for old ones and delete them
					if timeNOW - fb[:DATE].to_time > 63000000
						update = true; feedbacks[:fbARC] += 1
					else #else just count them
						( feedbacks[:fbG] += 1; fb[:COLOR] = 'zeG' ) if fb[:SCORE] > 0
						( feedbacks[:fbB] += 1; fb[:COLOR] = 'zeB' ) if fb[:SCORE] < 0
						( feedbacks[:fbN] += 1; fb[:COLOR] = 'zeN' ) if fb[:SCORE] == 0
						#count bugofb
						if fb[:pNAME] == "MrBug" && ( timeNOW - fb[:DATE].to_time < 31500000 )
							feedbacks[:fbBuG] += 1 if fb[:SCORE] > 0
							feedbacks[:fbBuB] += 1 if fb[:SCORE] < 0	
						end
						newfbarray.push({
							FEEDBACK: fb[:FEEDBACK], pNAME: fb[:pNAME],
							DATE: fb[:DATE], COLOR: fb[:COLOR]
						})
						updfbarray.push({
							FEEDBACK: fb[:FEEDBACK], pNAME: fb[:pNAME],
							DATE: fb[:DATE], SCORE: fb[:SCORE]
						})

						#onetime check for users last feedback to make it editable
						( newfbarray[-1][:eDit] = true; fbedit = true ) if fbedit == false && current_user && fb[:pNAME] == current_user[:username]

					end
				end
				
				update = true if !userfb[0][:fbG] || !userfb[0][:fbB] || !userfb[0][:fbN] || !userfb[0][:fbBuG] || !userfb[0][:fbBuB] || !userfb[0][:fbARC]
				update = true if userfb[0][:fbG] != feedbacks[:fbG] || userfb[0][:fbB] != feedbacks[:fbB] || userfb[0][:fbN] != feedbacks[:fbN]
				update = true if userfb[0][:fbBuG] != feedbacks[:fbBuG] || userfb[0][:fbBuB] != feedbacks[:fbBuB]

				#save final variable
				if feedbacks[:MENOSHO]
					feedbacks[:FEEDBACKS] = newfbarray.take(11)
					feedbacks[:FEEDBACKS2] = newfbarray.drop(11).each_slice(12)
				else
					feedbacks[:FEEDBACKS] = newfbarray.take(12)
					feedbacks[:FEEDBACKS2] = newfbarray.drop(12).each_slice(12)
				end
			#if feedback are empty, make sure numbers do exist and are zero
			elsif userfb[0]
				update = true if userfb[0][:fbG] != 0 || userfb[0][:fbB] != 0 || userfb[0][:fbN] != 0
				update = true if userfb[0][:fbBuG] != 0 || userfb[0][:fbBuB] != 0
			end

			#do the games owned display, for logged in users only
			if current_user && params[:username] != 'MrBug'
				#get user games from my database
				ugamez = @@userdb[:PS4db].find( 
					{ "$or": [ { P2: params[:username] }, { P4: params[:username] } ] },
                           		collation: { locale: 'en', strength: 2 } ).to_a
				#do stuff if we have some
				if ugamez[0]
					ugamezfinal = []
					ugamez.each do |ugaz|
						if timeNOW - ugaz[:DATE].to_time < 63000000 && ugaz[:P2] && ugaz[:P4]
							#show acc mail if user if owner of this page
							aCC = false
							#select between + and @, \+ and \@
							aCC = ugaz[:_id][/\+(.*?)\@/m, 1] if current_user[:username].downcase == params[:username].downcase
							#create final variable
							if (ugaz[:P2][0] && ugaz[:P2][0].downcase == params[:username].downcase) || (ugaz[:P2][1] && ugaz[:P2][1].downcase == params[:username].downcase)
								ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 2, aCC: aCC } )
							else
								ugamezfinal.push( { gNAME: ugaz[:GAME], poZ: 4, aCC: aCC } )
							end
						end
					end
					feedbacks[:ugameZ] = ugamezfinal.sort_by { |k| [k[:gNAME].downcase, k[:poZ]] }
				end
			end

			#render fb
			render json: feedbacks

			#update db with new correct values if needed
			if update
				@@userfb2[:userfb].replace_one( { _id: params[:username].downcase }, {
					FEEDBACKS: updfbarray.reverse, troikaBAN: userfb[0][:troikaBAN],
					fbG: feedbacks[:fbG], fbN: feedbacks[:fbN], fbB: feedbacks[:fbB],
					fbBuG: feedbacks[:fbBuG], fbBuB: feedbacks[:fbBuB], fbARC: feedbacks[:fbARC]
				}, { upsert: true } )
			end
		end

		def zafeedback
			render json: { halpme: "mnogo" }
=begin
			#decode shit
			fedbacks = URI.unescape(Base64.decode64(params[:fedbakibaki])).split("~") #0 - mode, 1 - score, 2 - otziv
			#page owners and guests cant do feedbacks!
			if current_user && fedbacks.length == 3 && current_user[:username].downcase != params[:username].downcase
				#users with negative feedbacks cant do feedbacks!
				userfb = @@userfb[:userfb].find( { _id: current_user[:username].downcase }, projection: { fbB: 1 } ).to_a

				#if bad feedback present, show stuff
				if userfb[0] && userfb[0][:fbB] > 0
					render json: { bakas: true }
				else
					#get user feedback
					ufb = @@userfb[:userfb].find( { _id: params[:username].downcase } ).to_a

					fedbacks[0] = fedbacks[0].to_i; fedbacks[1] = fedbacks[1].to_i

					#do normal feedback add
					if fedbacks[0] == 666
						#find if user gave feedback already today
						if ufb[0] && ufb[0][:FEEDBACKS]
							fedbacks[3] = ufb[0][:FEEDBACKS].any? {|h| h[:pNAME] == current_user[:username] && h[:DATE] == Time.now.strftime("%Y.%m.%d")}
						end

						#if gave feedback already, show stuff
						if fedbacks[3] && current_user[:username] != 'MrBug'
							render json: { gavas: true }
						else
							@@userfb2[:userfb].find_one_and_update( { _id: params[:username].downcase }, { "$push" => { 
								FEEDBACKS: {
									FEEDBACK: fedbacks[2].strip,
									pNAME: current_user[:username],
									DATE: Time.now.strftime("%Y.%m.%d"),
									SCORE: fedbacks[1]
								}
							} }, { upsert: true } )
							render json: { winrars: true }
						end
					#or edit last feedback given
					elsif fedbacks[0] == 1337
						#find if user edited feedback already today
						if ufb[0] && ufb[0][:FEEDBACKS]
							fedbacks[3] = ufb[0][:FEEDBACKS].any? {|h| h[:pNAME] == current_user[:username] && h[:DATE] == Time.now.strftime("%Y.%m.%d") && h[:EDITED] == Time.now.strftime("%Y.%m.%d")}
						end

						#if edited feedback already, show stuff
						if fedbacks[3] && current_user[:username] != 'MrBug'
							render json: { gavas2: true }
						else
							ufb[0][:FEEDBACKS].reverse_each do |fb|
								if fb[:pNAME] == current_user[:username]
									fb[:FEEDBACK] = fedbacks[2].strip
									fb[:SCORE] = fedbacks[1]
									fb[:EDITED] = Time.now.strftime("%Y.%m.%d")
									break
								end
							end
							@@userfb2[:userfb].replace_one( { _id: params[:username].downcase },
								ufb[0], { upsert: true } )
							render json: { winrars: true }
						end
					else #if none of these happen, thats really wrong...
						render json: { fail: true }
					end

				end
			else #if that is a guest or a page owner... thats really really wrong...
				render json: { fail: true }
			end
=end
		end

		def ufbupdate
			if current_user && params[:pNAME] && params[:pNAME] == current_user[:username]
				#get current user feedback, update it, check for negative feedbacks
				userfb = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if userfb[0] && userfb[0][:FEEDBACKS] && userfb[0][:FEEDBACKS].any?
					feedbacks = { fbG: 0, fbN: 0, fbB: 0, fbBuG: 0, fbBuB: 0, fbARC: 0 }
					newfbarray = []; update = false; timeNOW = Time.now

					#create key if it doesnt exist yet
					userfb[0][:troikaBAN] = 0 unless userfb[0].key?("troikaBAN")

					#get deleted feedback number if it exists
					feedbacks[:fbARC] = userfb[0][:fbARC] if userfb[0][:fbARC]

					#remove duplicates
					update = true if userfb[0][:FEEDBACKS].uniq!

					#count it and check if numbers match
					userfb[0][:FEEDBACKS].each do |fb|
						#look for old ones and delete them
						if timeNOW - fb[:DATE].to_time > 63000000
							update = true; feedbacks[:fbARC] += 1
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

					update = true if !userfb[0][:fbG] || !userfb[0][:fbB] || !userfb[0][:fbN] || !userfb[0][:fbBuG] || !userfb[0][:fbBuB] || !userfb[0][:fbARC]
					update = true if userfb[0][:fbG] != feedbacks[:fbG] || userfb[0][:fbB] != feedbacks[:fbB] || userfb[0][:fbN] != feedbacks[:fbN]
					update = true if userfb[0][:fbBuG] != feedbacks[:fbBuG] || userfb[0][:fbBuB] != feedbacks[:fbBuB]

					#update db with new correct values if needed
					if update
						@@userfb2[:userfb].replace_one( { _id: current_user[:username].downcase }, {
							FEEDBACKS: newfbarray, troikaBAN: userfb[0][:troikaBAN],
							fbG: feedbacks[:fbG], fbN: feedbacks[:fbN], fbB: feedbacks[:fbB],
							fbBuG: feedbacks[:fbBuG], fbBuB: feedbacks[:fbBuB], fbARC: feedbacks[:fbARC]
						}, { upsert: true } )
					end
				end

			end
		end

		def rentagama
			finalrenta = {} # { rentaGAMEZ: [], rentaGAMEZ1: [], rentaGAMEZ2: [] }

			#get cache from db, drop it if its old
			cachedRENT = @@cache[:rentaCHA].find().to_a
			if cachedRENT[0]
				if Time.now - cachedRENT[0][:TIME] > 3600
					@@cache[:rentaCHA].drop()
				else
					finalrenta = cachedRENT[0].symbolize_keys.except(:_id, :TIME)
				end
			end

			if finalrenta.empty?
				#find all rentagamez
				rentagamez = @@rentadb[:rentagadb].find().to_a
				finalrenta = { rentaGAMEZ: [], rentaGAMEZ1: [], rentaGAMEZ2: [] }
				count = [0,0,0,0,0] # #0 - vsego, #1 - type 1, #2 - type 2, #3 - type 3, #4 - type 4
				#create template shit
				rentagamez.each do |games|
					gTYPE = [false,false,false,false]
					count[0] = count[0] + 1
					( gTYPE[0] = true; count[1] = count[1] + 1 ) if games[:GTYPE] == 1
					( gTYPE[1] = true; count[2] = count[2] + 1 ) if games[:GTYPE] == 2
					( gTYPE[2] = true; count[3] = count[3] + 1 ) if games[:GTYPE] == 3
					( gTYPE[3] = true; count[4] = count[4] + 1 ) if games[:GTYPE] == 4
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

				#sort this shit
				finalrenta[:rentaGAMEZ].sort_by! { |k| [-k[:GNEW], k[:GNAME].downcase] }
				finalrenta[:rentaGAMEZ1].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }
				finalrenta[:rentaGAMEZ2].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }

				#save cache to db
				@@cache[:rentaCHA].insert_one({ 
					rentaGAMEZ: finalrenta[:rentaGAMEZ], rentaGAMEZ1: finalrenta[:rentaGAMEZ1],
					rentaGAMEZ2: finalrenta[:rentaGAMEZ2], count: count, TIME: Time.now
				})
			end

			render json: finalrenta
		end

	end

end
