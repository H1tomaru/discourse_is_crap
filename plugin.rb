# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'
require 'base64'
require 'uri'

register_asset 'stylesheets/MrBug.scss'

after_initialize do

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
		get '/MrBug/troikopoisk/:input' => 'mrbug#troikopoisk'
		get '/MrBug/prezaips/:bagakruta' => 'mrbug#prezaips'
		get '/MrBug/zaips/:bagatrolit' => 'mrbug#zaips'
		get '/MrBugP3' => 'mrbug#showp3'
		get '/MrBugP3/troikopoisk/:input' => 'mrbug#troikopoiskp3'
		get '/MrBugP3/prezaips/:bagakruta' => 'mrbug#prezaipsp3'
		get '/MrBugP3/zaips/:bagatrolit' => 'mrbug#zaipsp3'
		get '/renta-haleguu' => 'mrbug#rentagama'
		get '/admin/MegaAdd' => 'mrbug#showadd', constraints: AdminConstraint.new
		post '/admin/MegaAdd' => 'mrbug#megaadd', constraints: AdminConstraint.new
		get '/u/:username/kek' => 'mrbug#feedbacks', constraints: { username: RouteFormat.username }
		post '/u/:username/kek' => 'mrbug#zafeedback', constraints: { username: RouteFormat.username }
	end

	class ::MrbugController < ::ApplicationController

		db = Mongo::Client.new([ '104.244.76.126:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@cache = db.use('AutoZ_cache')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')
		
		@@rentadb = Mongo::Client.new([ '104.244.76.126:33775' ], database: 'rentagadb', user: 'rentaga', password: 'A75Z3E9R66' )
		
		@@userdb2 = Mongo::Client.new([ '104.244.76.126:33775' ], database: 'userdb', user: 'megaadd', password: '3HXED926MT' )
		@@userfb2 = @@userdb2.use('userfb')

		def show
			#variables, duh
			finalvar = {}
			finalvar[:qzstuff] = false
			priceSTEP = 0
			#cached vars
			qzlist = []
			gamelist = []
			newcache = {}

			#get cache from db, drop it if its old
			cacheDB = @@cache[:cache].find().to_a
			if cacheDB[0]
				if Time.now - cacheDB[0][:TIME] > 900
					@@cache[:cache].drop()
				else
					qzlist = cacheDB[0][:qzlist]
					gamelist = cacheDB[0][:gamelist]
				end
			end

			#if viever registered, count his fb
			if current_user
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if feedback[0] && feedback[0][:fbB]
					fbcount = feedback[0][:fbG]
				end
				finalvar[:qzstuff] = true if fbcount >= 10
			end

			if gamelist.empty?
				#create qzlist variable
				glist = @@gamedb[:gameDB].find().sort( { gameNAME: 1 } ).to_a
				glist.each do |game|
					qzlist.push( [ game[:_id] , game[:gameNAME] ] )
				end

				#get all type 123 games
				gameDB = @@gamedb[:gameDB].find( { TYPE: { "$in": [1,2,3] } }, projection: { imgLINKHQ: 0 } ).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a
				#get all users 2 list
				userDB = @@userlistdb[:uListP4].find().to_a
				#get all user feedbacks
				userFB = @@userfb[:userfb].find().to_a
				#find user for type 0 games and add those type 0 games
				gameIDs = gameDB.map { |e| e[:_id] }
				typ0 = userDB.reject { |zero| gameIDs.include? zero[:_id] }
				typ0.each do |game|
					thisgame = @@gamedb[:gameDB].find( { _id: game[:_id] }, projection: { imgLINKHQ: 0 } ).to_a
					if thisgame[0]
						gameDB.push(thisgame[0])
					else
						finalvar[:error] = game[:_id]
					end
				end
				#start a loop for every game to display
				gameDB.each do |game|
					#type 0 games have 0 price
					game[:PRICE] = 0 if game[:TYPE] == 0
					#somevariables
					p1NO = 0; p2NO = 0; p3NO = 0; price1DISPLAY = 0; price2DISPLAY = 0; price3DISPLAY = 0
					#add template variables
					game[:MODE1] = false; game[:MODE2] = false; game[:SHOWHIDEO] = false
					#create display prices
					if game[:PRICE] > 0
						p4PDOWN1 = 0; p4PDOWN2 = 0; p4PDOWN3 = 0
						p4PDOWN1 = game[:P4PDOWN1] if game[:P4PDOWN1]
						p4PDOWN2 = game[:P4PDOWN2] if game[:P4PDOWN2]
						p4PDOWN3 = game[:P4PDOWN3] if game[:P4PDOWN3]

						game[:P4PRICE1] = (game[:PRICE] * 0.1 / 50).ceil * 50
						game[:P4PRICE3] = (game[:PRICE] * 0.74 / 100).round * 100 / 2
						game[:P4PRICE2] = game[:PRICE] - 2 * game[:P4PRICE3] - game[:P4PRICE1]

						p4UP = [0,200,50]
						p4UP = [0,400,50] if game[:PRICE] > 5000
						p4UP = [0,100,50] if game[:PRICE] < 2600

						game[:P4PRICE1] = game[:P4PRICE1] - p4PDOWN1 + p4UP[0]
						game[:P4PRICE2] = game[:P4PRICE2] - p4PDOWN2 + p4UP[1]
						game[:P4PRICE3] = game[:P4PRICE3] - p4PDOWN3 + p4UP[2]
					else
						game[:P4PRICE1] = game[:P4PRICE2] = game[:P4PRICE3] = 0
					end
					#see if we have users to display
					users = userDB.find{ |h| h['_id'] == game[:_id] }
					#do stuff if we do
					game[:TROIKI] = []
					if users
						#somevariables
						priceUP = 0; nop1ADD = 0
						#find how many p1 p2 p3 we have, and how many troikas to display
						p1NO = users[:P1].length if users[:P1]
						p2NO = users[:P2].length if users[:P2]
						p3NO = users[:P4].length / 2.0 if users[:P4] #fix because 2 P4 per troika

						for i in 0..[p1NO, p2NO, p3NO.ceil].max-1 #get how many troikas, roundup p4 number cos theres 2 per troika
							#tons of variables for everything
							p1 = ''; p2 = ''; p3 = ''; p4 = ''; account = ''; comment = ''
							p1STATUS = [false,false,false,false]; p2STATUS = [false,false,false,false]; p3STATUS = [false,false,false,false]; p4STATUS = [false,false,false,false]
							p1PRICE = 0; p2PRICE = 0; p3PRICE = 0; p1PDOWN = 0; p2PDOWN = 0; p3PDOWN = 0
							p1FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p2FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p3FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p4FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p1TAKEN = false; p2TAKEN = false; p3TAKEN = false; p4TAKEN = false
							p1FBred = false; p2FBred = false; p3FBred = false; p4FBred = false
							#fill user info and template variables for statuses
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
							#template variables for when p1 p2 p3 p4 are taken
							(p1TAKEN = true; p1 = '') if p1 == '-55'
							(p2TAKEN = true; p2 = '') if p2 == '-55'
							(p3TAKEN = true; p3 = '') if p3 == '-55'
							(p4TAKEN = true; p4 = '') if p4 == '-55'
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
							#find feedback percentage
							p1FEEDBACK[:PERCENT] = (p1FEEDBACK[:GOOD].to_f/(p1FEEDBACK[:GOOD] + p1FEEDBACK[:BAD]) * 100.0).floor if p1FEEDBACK[:GOOD] > 0
							p2FEEDBACK[:PERCENT] = (p2FEEDBACK[:GOOD].to_f/(p2FEEDBACK[:GOOD] + p2FEEDBACK[:BAD]) * 100.0).floor if p2FEEDBACK[:GOOD] > 0
							p3FEEDBACK[:PERCENT] = (p3FEEDBACK[:GOOD].to_f/(p3FEEDBACK[:GOOD] + p3FEEDBACK[:BAD]) * 100.0).floor if p3FEEDBACK[:GOOD] > 0
							p4FEEDBACK[:PERCENT] = (p4FEEDBACK[:GOOD].to_f/(p4FEEDBACK[:GOOD] + p4FEEDBACK[:BAD]) * 100.0).floor if p4FEEDBACK[:GOOD] > 0
							#create comment and account variable if they exist
							if users[(i+1).to_s]
								account = users[(i+1).to_s][:ACCOUNT] if users[(i+1).to_s][:ACCOUNT]
								comment = users[(i+1).to_s][:COMMENT] if users[(i+1).to_s][:COMMENT]
							end
							#calculate prices
							if game[:PRICE] > 0
								priceUP = priceSTEP * (i / 10).floor
								#get current pricedown
								if users[(i+1).to_s]
									p1PDOWN = users[(i+1).to_s][:PDOWN1] if users[(i+1).to_s][:PDOWN1]
									p2PDOWN = users[(i+1).to_s][:PDOWN2] if users[(i+1).to_s][:PDOWN2]
									p3PDOWN = users[(i+1).to_s][:PDOWN3] if users[(i+1).to_s][:PDOWN3]
								end
								#create current troika prices
								p1PRICE = game[:P4PRICE1] - p1PDOWN
								p2PRICE = game[:P4PRICE2] - p2PDOWN + priceUP
								p3PRICE = game[:P4PRICE3] - p3PDOWN + priceUP
								#set price to -10 if its x100
								p1PRICE = p1PRICE - 10 if p1PRICE/100.0 == (p1PRICE/100.0).ceil
								p2PRICE = p2PRICE - 10 if p2PRICE/100.0 == (p2PRICE/100.0).ceil
								p3PRICE = p3PRICE - 10 if p3PRICE/100.0 == (p3PRICE/100.0).ceil
							end
							#template again, is feedback green or red?
							p1FBred = true if p1FEEDBACK[:PERCENT] < 100
							p2FBred = true if p2FEEDBACK[:PERCENT] < 100
							p3FBred = true if p3FEEDBACK[:PERCENT] < 100
							p4FBred = true if p4FEEDBACK[:PERCENT] < 100
							#vizmem bez p1?!
							nop1ADD = (p1PRICE / 30.0).ceil * 10 if p1 == ''
							#create final variable
							game[:TROIKI].push( {
								P1: p1, P1FEEDBACK: p1FEEDBACK, P2: p2, P2FEEDBACK: p2FEEDBACK,
								P3: p3, P3FEEDBACK: p3FEEDBACK, P4: p4, P4FEEDBACK: p4FEEDBACK,
								P1PRICE: p1PRICE, P2PRICE: p2PRICE, P3PRICE: p3PRICE, NOP1ADD: nop1ADD, ACCOUNT: account, COMMENT: comment,
								P1TAKEN: p1TAKEN, P2TAKEN: p2TAKEN, P3TAKEN: p3TAKEN, P4TAKEN: p4TAKEN,
								P1FBred: p1FBred, P2FBred: p2FBred, P3FBred: p3FBred, P4FBred: p4FBred,
								P1STATUS: p1STATUS, P2STATUS: p2STATUS, P3STATUS: p3STATUS, P4STATUS: p4STATUS
							} )
							#if current troika has any free position, save its price to display on button, if not saved one already
							price1DISPLAY = p1PRICE if p1.length == 0 && price1DISPLAY == 0
							price2DISPLAY = p2PRICE if p2.length == 0 && price2DISPLAY == 0
							price3DISPLAY = p3PRICE if (p3.length == 0 || p4.length == 0) && price3DISPLAY == 0
						end
						#remove this game users form userdb variable
						#userDB.delete_if{ |h| h['_id'] == game[:_id] }
					end
					#set display users number
					game[:P1NO] = p1NO
					game[:P2NO] = p2NO
					game[:P3NO] = p3NO
					#set the current display price, depending on amount of troek, if price is zero, don't touch it
					if game[:PRICE] > 0
						if price1DISPLAY > 0
							game[:P4PRICE1] = price1DISPLAY
						else
							game[:P4PRICE1] = game[:P4PRICE1] + priceSTEP * (p1NO / 10).floor
						end
						if price2DISPLAY > 0
							game[:P4PRICE2] = price2DISPLAY
						else
							game[:P4PRICE2] = game[:P4PRICE2] + priceSTEP * (p2NO / 10).floor
						end
						if price3DISPLAY > 0
							game[:P4PRICE3] = price3DISPLAY
						else
							game[:P4PRICE3] = game[:P4PRICE3] + priceSTEP * (p3NO / 10).floor
						end
						#set price to -10 if its x100
						game[:P4PRICE1] = game[:P4PRICE1] - 10 if game[:P4PRICE1]/100.0 == (game[:P4PRICE1]/100.0).ceil
						game[:P4PRICE2] = game[:P4PRICE2] - 10 if game[:P4PRICE2]/100.0 == (game[:P4PRICE2]/100.0).ceil
						game[:P4PRICE3] = game[:P4PRICE3] - 10 if game[:P4PRICE3]/100.0 == (game[:P4PRICE3]/100.0).ceil
					end
				end
				gamelist = gameDB
				#save both lists to cache
				newcache[:qzlist] = qzlist
				newcache[:gamelist] = gameDB
				newcache[:TIME] = Time.now
			end

			#save cache to db if it exists
			@@cache[:cache].insert_one(newcache) if newcache.any?

			#if displaying qzaips, add games list to finalvar
			finalvar[:qzlist] = qzlist if finalvar[:qzstuff]

			#make 3 variables for each game type
			finalvar[:gamedb1] = []; finalvar[:gamedb2] = []; finalvar[:gamedb3] = []
			finalvar[:maigamez1] = []; finalvar[:maigamez2] = []

			gamelist.each do |game|
				#if not guest, check if user is in this troika
				if current_user
					gTYPE2 = 0; gTYPE3 = 0
					gTYPE2 = 1 if game[:TYPE] == 2
					gTYPE3 = 1 if game[:TYPE] == 3
					game[:TROIKI].each do |troika|
						troika[:MODE1] = false; troika[:MODE2] = false
						if current_user[:username] == troika[:P1]
							if troika[:P1STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 1, gNAME: game[:gameNAME], PRICE: troika[:P1PRICE],
								P1ADD: troika[:NOP1ADD], DATE: game[:DATE], TYPE2: gTYPE2, TYPE3: gTYPE3 } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 1, gNAME: game[:gameNAME] } )
							end
						end
						if current_user[:username] == troika[:P2]
							if troika[:P2STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 2, gNAME: game[:gameNAME], PRICE: troika[:P2PRICE],
								P1ADD: troika[:NOP1ADD], DATE: game[:DATE], TYPE2: gTYPE2, TYPE3: gTYPE3 } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 2, gNAME: game[:gameNAME] } )
							end
						end
						if current_user[:username] == troika[:P3]
							if troika[:P3STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 4, gNAME: game[:gameNAME], PRICE: troika[:P3PRICE],
								P1ADD: troika[:NOP1ADD], DATE: game[:DATE], TYPE2: gTYPE2, TYPE3: gTYPE3 } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 4, gNAME: game[:gameNAME] } )
							end
						end
						if current_user[:username] == troika[:P4]
							if troika[:P4STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 4, gNAME: game[:gameNAME], PRICE: troika[:P3PRICE],
								P1ADD: troika[:NOP1ADD], DATE: game[:DATE], TYPE2: gTYPE2, TYPE3: gTYPE3 } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 4, gNAME: game[:gameNAME] } )
							end
						end
					end
				end
				#shorten maigamez1 game names of they too long
				finalvar[:maigamez1].each {|game| game[:gNAME] = game[:gNAME].truncate(40)}
				#fill 3 variables for each game type
				finalvar[:gamedb1].push(game.except(:PRICE, :TYPE)) if game[:TYPE] == 1 || game[:TYPE] == 0
				finalvar[:gamedb2].push(game.except(:PRICE, :TYPE)) if game[:TYPE] == 2
				finalvar[:gamedb3].push(game.except(:PRICE, :TYPE)) if game[:TYPE] == 3
			end
			
			render json: finalvar

		end

		def troikopoisk
			#decode shit
			troikopoisk = URI.unescape(Base64.decode64(params[:input])).strip.downcase
			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40
				zapislist = @@userdb[:PS4db].find( { _id: troikopoisk }, projection: { DATE: 0 } ).to_a
				if zapislist[0]
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
			if current_user && code[1]
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if feedback[0] && feedback[0][:fbB]
					if feedback[0][:fbB] > 0
						fbcount = 777
					else
						fbcount = feedback[0][:fbG]
					end
				end

				if fbcount < 10 && code[0] == "1"
					render json: { piadin: true }
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
							prezaips[0] = prezaips[0].except(:imgLINKHQ)
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
			code = URI.unescape(Base64.decode64(params[:bagatrolit])).split("~") #0 - position, 1 - userNAME, 2 - gameCODE, 3 - gameNAME
			#do stuff if user is actual user and code is correct
			if current_user && code[3] && current_user[:username] == code[1]
				#count feedbacks and how many zaips, again!
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if feedback[0] && feedback[0][:fbB]
					if feedback[0][:fbB] > 0
						fbcount = 777
					else
						fbcount = feedback[0][:fbG]
					end
				end
				if ( fbcount < 10 && code[0] == "1" ) || fbcount == 777
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
						zaips = { winrars: true, position: code[0], gameNAME: code[3].force_encoding('UTF-8') }
						#destroy cache
						@@cache[:cache].drop()

						render json: zaips

						#add message to chat
						PostCreator.create(
							Discourse.system_user,
							skip_validations: true,
							topic_id: 21,
							raw: current_user[:username]+" записался на позицию П"+code[0]+" совместной покупки "+code[3]
						)

						#create notification if sobrano
						if gameuzers[0] && (gameuzers[0][:P2] || code[0] == "2") && (gameuzers[0][:P4] || code[0] == "4")

							if gameuzers[0]["P"+code[0]]
								troino = gameuzers[0]["P"+code[0]].count + 1
							else
								troino = 1
							end
							troino = troino / 2.0 if code[0] == "4"
							trindx = troino - 1

							PostCreator.create(
								Discourse.system_user,
								target_usernames: "MrBug",
								archetype: Archetype.private_message,
								subtype: TopicSubtype.system_message,
								title: "Debug",
								raw: "Троек " + troino.to_s + " Индекс " + trindx.to_s
							)

							if  (code[0] == "1" && gameuzers[0]["P2"][trindx] && gameuzers[0]["P4"][trindx*2+1]) || (code[0] == "2" && gameuzers[0]["P4"][trindx*2+1]) || (code[0] == "4" && troino.to_i == troino && gameuzers[0]["P2"][trindx])
								thisgame = @@gamedb[:gameDB].find( { _id: code[2] } ).to_a
								if thisgame[0][:PRICE] && !(thisgame[0][:TYPE] == 3 && thisgame[0][:DATE].to_datetime - Time.now > 2600000)
									usernames = ["MrBug" , current_user[:username]]
									usernames.push(gameuzers[0][:P1][trindx][:NAME]) if gameuzers[0][:P1][trindx] && gameuzers[0][:P1][trindx][:STAT] == 0 && code[0] != "1"
									usernames.push(gameuzers[0][:P2][trindx][:NAME]) if gameuzers[0][:P2] && gameuzers[0][:P2][trindx][:STAT] == 0 && code[0] != "2"
									usernames.push(gameuzers[0][:P4][trindx*2][:NAME]) if gameuzers[0][:P4] && gameuzers[0][:P4][trindx*2][:STAT] == 0
									usernames.push(gameuzers[0][:P4][trindx*2+1][:NAME]) if gameuzers[0][:P4] && gameuzers[0][:P4][trindx*2+1][:STAT] == 0 && code[0] != "4"
									usernames = usernames.uniq

									if gameuzers[0][:P1][trindx] && gameuzers[0][:P1][trindx][:NAME] != "-55"
										troititle = "Четверка на " + code[3] + " собрана! Ждем оплату!"
										troitext = "Здравствуйте! :robot:\n 
										Случилось невероятное! Четверка на " + code[3] + " собрана.\n
										Этого не должно было произойти, но придется с этим как-то теперь жить :robot:\n\n
										Вот план дальнейших действий:\n
										1) Оплатить свою позицию, суммы и реквизиты указаны [на странице четверок, в верху страницы](/MrBug)\n
										2) Ознакомиться с [инструкциями в разделе FAQ](/faq)\n
										3) Ознакомиться с [правилами в разделе FAQ](/faq)\n\n
										Ошибка одного будет дорого стоить всем!\n
										Держитесь! И да поможет вам :bug:"
									else
										troititle = "Тройка на " + code[3] + " собрана! Ждем оплату!"
										troitext = "Здравствуйте! :robot:\n 
										Случилось невероятное! Тройка на " + code[3] + " собрана.\n
										Этого не должно было произойти, но придется с этим как-то теперь жить :robot:\n\n
										Вот план дальнейших действий:\n
										1) Оплатить свою позицию с учетом отсутствующего П1, суммы и реквизиты указаны [на странице четверок, в верху страницы](/MrBug)\n
										2) Ознакомиться с [инструкциями в разделе FAQ](/faq)\n
										3) Ознакомиться с [правилами в разделе FAQ](/faq)\n\n
										Ошибка одного будет дорого стоить всем!\n
										Держитесь! И да поможет вам :bug:"
									end

									PostCreator.create(
										Discourse.system_user,
										target_usernames: "MrBug,H1tomaru",#usernames.join(","),
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
			else
				render json: { zaipsfail: true }
			end
		end

		def showp3
			#variables, duh
			finalvar = {}
			finalvar[:qzstuff] = false
			priceSTEP = 0	##dif
			#cached vars
			qzlist = []
			gamelist = []
			newcache = {}

			#get cache from db, drop it if its old
			cacheDB = @@cache[:cachep3].find().to_a	##dif
			if cacheDB[0]
				if Time.now - cacheDB[0][:TIME] > 900
					@@cache[:cachep3].drop()	##dif
				else
					qzlist = cacheDB[0][:qzlist]
					gamelist = cacheDB[0][:gamelist]
				end
			end

			#if viever registered, count his fb
			if current_user
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if feedback[0] && feedback[0][:fbB]
					fbcount = feedback[0][:fbG]
				end
				finalvar[:qzstuff] = true if fbcount >= 10
			end

			if gamelist.empty?
				#create qzlist variable
				glist = @@gamedb[:gameDB].find().sort( { gameNAME: 1 } ).to_a
				glist.each do |game|
					qzlist.push( [ game[:_id] , game[:gameNAME] ] )
				end

				#get all type 123 games
				gameDB = @@gamedb[:gameDB].find( { TYPE: { "$in": [1,2,3] } }, projection: { imgLINKHQ: 0 } ).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a
				#get all users 2 list
				userDB = @@userlistdb[:uListP3].find().to_a	##dif
				#get all user feedbacks
				userFB = @@userfb[:userfb].find().to_a
				#find user for type 0 games and add those type 0 games
				gameIDs = gameDB.map { |e| e[:_id] }
				typ0 = userDB.reject { |zero| gameIDs.include? zero[:_id] }
				typ0.each do |game|
					thisgame = @@gamedb[:gameDB].find( { _id: game[:_id] }, projection: { imgLINKHQ: 0 } ).to_a
					if thisgame[0]
						gameDB.push(thisgame[0])
					else
						finalvar[:error] = game[:_id]
					end
				end
				#start a loop for every game to display
				gameDB.each do |game|
					#type 0 games have 0 price
					game[:PRICE] = 0 if game[:TYPE] == 0
					#somevariables
					p1NO = 0; p2NO = 0; p3NO = 0; price1DISPLAY = 0; price2DISPLAY = 0; price3DISPLAY = 0; nop1ADD2 = 0; nop1ADD3 = 0
					#add template variables
					game[:MODE1] = false; game[:MODE2] = false; game[:SHOWHIDEO] = false
					#create display prices
					if game[:PRICE] > 0
						p3PDOWN1 = 0; p3PDOWN2 = 0; p3PDOWN3 = 0	##dif down
						p3PDOWN1 = game[:P3PDOWN1] if game[:P3PDOWN1]
						p3PDOWN2 = game[:P3PDOWN2] if game[:P3PDOWN2]
						p3PDOWN3 = game[:P3PDOWN3] if game[:P3PDOWN3]

						game[:P3PRICE1] = (game[:PRICE] * 0.15 / 50).ceil * 50 - p3PDOWN1
						nop1ADD3 = (game[:P3PRICE1] * 2 * 0.6 / 50).floor * 50
						nop1ADD2 = game[:P3PRICE1] * 2 - nop1ADD3
						game[:P3PRICE3] = (game[:PRICE] * 0.63 / 50).floor * 50 - nop1ADD3
						game[:P3PRICE2] = game[:PRICE] - game[:P3PRICE3] - (game[:P3PRICE1] * 2)

						p3UP = [0,100,200]
						p3UP = [0,150,300] if game[:PRICE] > 5500
						p3UP = [0,50,200] if game[:PRICE] < 2000
						p3UP = [0,50,150] if game[:PRICE] < 1000

						#game[:P3PRICE1] = game[:P3PRICE1] - p3PDOWN1 + p3UP[0]
						game[:P3PRICE2] = game[:P3PRICE2] - p3PDOWN2 + p3UP[1]
						game[:P3PRICE3] = game[:P3PRICE3] - p3PDOWN3 + p3UP[2]
					else
						game[:P3PRICE1] = game[:P3PRICE2] = game[:P3PRICE3] = 0	##dif up
					end
					#see if we have users to display
					users = userDB.find{ |h| h['_id'] == game[:_id] }
					#do stuff if we do
					game[:TROIKI] = []
					if users
						#somevariables
						priceUP = 0; nop1ADD0 = 0; nop1ADD1 = 0
						#find how many p1 p2 p3 we have, and how many troikas to display ##dif down
						p1NO = users[:P1].length if users[:P1]
						p2NO = users[:P2].length if users[:P2]
						p3NO = users[:P3].length if users[:P3]

						for i in 0..[p1NO.ceil, p2NO, p3NO].max-1 #get how many troikas, roundup p1 number cos theres 2 per troika
							#tons of variables for everything
							p1 = ''; p2 = ''; p3 = ''; p4 = ''; account = ''; comment = ''
							p1STATUS = [false,false,false,false]; p2STATUS = [false,false,false,false]; p3STATUS = [false,false,false,false]; p4STATUS = [false,false,false,false]
							p1PRICE = 0; p2PRICE = 0; p3PRICE = 0; p1PDOWN = 0; p2PDOWN = 0; p3PDOWN = 0
							p1FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p2FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p3FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }; p4FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
							p1TAKEN = false; p2TAKEN = false; p3TAKEN = false; p4TAKEN = false
							p1FBred = false; p2FBred = false; p3FBred = false; p4FBred = false
							#fill user info and template variables for statuses
							if users[:P1] && users[:P1][i]
								p1 = users[:P1][i][:NAME].strip
								p1STATUS[users[:P1][i][:STAT]] = true
							end
							if users[:P12] && users[:P12][i]
								p2 = users[:P12][i][:NAME].strip
								p2STATUS[users[:P12][i][:STAT]] = true
							end
							if users[:P2] && users[:P2][i]
								p3 = users[:P2][i][:NAME].strip
								p3STATUS[users[:P2][i][:STAT]] = true
							end
							if users[:P3] && users[:P3][i]
								p4 = users[:P3][i][:NAME].strip
								p4STATUS[users[:P3][i][:STAT]] = true	##dif up
							end
							#template variables for when p1 p2 p3 p4 are taken
							(p1TAKEN = true; p1 = '') if p1 == '-55'
							(p2TAKEN = true; p2 = '') if p2 == '-55'
							(p3TAKEN = true; p3 = '') if p3 == '-55'
							(p4TAKEN = true; p4 = '') if p4 == '-55'
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
							#find feedback percentage
							p1FEEDBACK[:PERCENT] = (p1FEEDBACK[:GOOD].to_f/(p1FEEDBACK[:GOOD] + p1FEEDBACK[:BAD]) * 100.0).floor if p1FEEDBACK[:GOOD] > 0
							p2FEEDBACK[:PERCENT] = (p2FEEDBACK[:GOOD].to_f/(p2FEEDBACK[:GOOD] + p2FEEDBACK[:BAD]) * 100.0).floor if p2FEEDBACK[:GOOD] > 0
							p3FEEDBACK[:PERCENT] = (p3FEEDBACK[:GOOD].to_f/(p3FEEDBACK[:GOOD] + p3FEEDBACK[:BAD]) * 100.0).floor if p3FEEDBACK[:GOOD] > 0
							p4FEEDBACK[:PERCENT] = (p4FEEDBACK[:GOOD].to_f/(p4FEEDBACK[:GOOD] + p4FEEDBACK[:BAD]) * 100.0).floor if p4FEEDBACK[:GOOD] > 0
							#create comment and account variable if they exist
							if users[(i+1).to_s]
								account = users[(i+1).to_s][:ACCOUNT] if users[(i+1).to_s][:ACCOUNT]
								comment = users[(i+1).to_s][:COMMENT] if users[(i+1).to_s][:COMMENT]
							end
							#calculate prices
							if game[:PRICE] > 0
								priceUP = priceSTEP * (i / 10).floor
								#get current pricedown
								if users[(i+1).to_s]
									p1PDOWN = users[(i+1).to_s][:PDOWN1] if users[(i+1).to_s][:PDOWN1]
									p2PDOWN = users[(i+1).to_s][:PDOWN2] if users[(i+1).to_s][:PDOWN2]
									p3PDOWN = users[(i+1).to_s][:PDOWN3] if users[(i+1).to_s][:PDOWN3]
								end
								#create current troika prices
								p1PRICE = game[:P3PRICE1] - p1PDOWN	##dif
								p2PRICE = game[:P3PRICE2] - p2PDOWN + priceUP	##dif
								p3PRICE = game[:P3PRICE3] - p3PDOWN + priceUP	##dif
								#set price to -10 if its x100
								p1PRICE = p1PRICE - 10 if p1PRICE/100.0 == (p1PRICE/100.0).ceil
								p2PRICE = p2PRICE - 10 if p2PRICE/100.0 == (p2PRICE/100.0).ceil
								p3PRICE = p3PRICE - 10 if p3PRICE/100.0 == (p3PRICE/100.0).ceil
							end
							#template again, is feedback green or red?
							p1FBred = true if p1FEEDBACK[:PERCENT] < 100
							p2FBred = true if p2FEEDBACK[:PERCENT] < 100
							p3FBred = true if p3FEEDBACK[:PERCENT] < 100
							p4FBred = true if p4FEEDBACK[:PERCENT] < 100
							#vizmem bez p1?!
							(nop1ADD0 = nop1ADD2 - 50; nop1ADD1 = nop1ADD3 - 50) if p1 == '' && p2 == ''	##dif
							(nop1ADD0 = nop1ADD2/2; nop1ADD1 = nop1ADD3/2) if (p1 != '' && p2 == '') || (p1 == '' && p2 != '')	##dif
							#create final variable
							game[:TROIKI].push( {
								P1: p1, P1FEEDBACK: p1FEEDBACK, P2: p2, P2FEEDBACK: p2FEEDBACK,
								P3: p3, P3FEEDBACK: p3FEEDBACK, P4: p4, P4FEEDBACK: p4FEEDBACK,
								P1PRICE: p1PRICE, P2PRICE: p2PRICE, P3PRICE: p3PRICE, NOP1ADD0: nop1ADD0, NOP1ADD1: nop1ADD1, ACCOUNT: account, COMMENT: comment,
								P1TAKEN: p1TAKEN, P2TAKEN: p2TAKEN, P3TAKEN: p3TAKEN, P4TAKEN: p4TAKEN,
								P1FBred: p1FBred, P2FBred: p2FBred, P3FBred: p3FBred, P4FBred: p4FBred,
								P1STATUS: p1STATUS, P2STATUS: p2STATUS, P3STATUS: p3STATUS, P4STATUS: p4STATUS
							} )
							#if current troika has any free position, save its price to display on button, if not saved one already
							price1DISPLAY = p1PRICE if (p1.length == 0 || p2.length == 0) && price1DISPLAY == 0	##dif
							price2DISPLAY = p2PRICE if p3.length == 0 && price2DISPLAY == 0	##dif
							price3DISPLAY = p3PRICE if p4.length == 0 && price3DISPLAY == 0	##dif
						end
						#remove this game users form userdb variable
						#userDB.delete_if{ |h| h['_id'] == game[:_id] }
					end
					#set display users number
					game[:P1NO] = p1NO
					game[:P2NO] = p2NO
					game[:P3NO] = p3NO
					#set the current display price, depending on amount of troek, if price is zero, don't touch it
					if game[:PRICE] > 0
						if price1DISPLAY > 0
							game[:P3PRICE1] = price1DISPLAY	##dif down
						else
							game[:P3PRICE1] = game[:P3PRICE1] + priceSTEP * (p1NO / 10).floor
						end
						if price2DISPLAY > 0
							game[:P3PRICE2] = price2DISPLAY
						else
							game[:P3PRICE2] = game[:P3PRICE2] + priceSTEP * (p2NO / 10).floor
						end
						if price3DISPLAY > 0
							game[:P3PRICE3] = price3DISPLAY
						else
							game[:P3PRICE3] = game[:P3PRICE3] + priceSTEP * (p3NO / 10).floor
						end
						#set price to -10 if its x100
						game[:P3PRICE1] = game[:P3PRICE1] - 10 if game[:P3PRICE1]/100.0 == (game[:P3PRICE1]/100.0).ceil
						game[:P3PRICE2] = game[:P3PRICE2] - 10 if game[:P3PRICE2]/100.0 == (game[:P3PRICE2]/100.0).ceil
						game[:P3PRICE3] = game[:P3PRICE3] - 10 if game[:P3PRICE3]/100.0 == (game[:P3PRICE3]/100.0).ceil	##dif up
					end
				end
				gamelist = gameDB
				#save both lists to cache
				newcache[:qzlist] = qzlist
				newcache[:gamelist] = gameDB
				newcache[:TIME] = Time.now
			end

			#save cache to db if it exists
			@@cache[:cachep3].insert_one(newcache) if newcache.any?	##dif

			#if displaying qzaips, add games list to finalvar
			finalvar[:qzlist] = qzlist if finalvar[:qzstuff]

			#make 3 variables for each game type
			finalvar[:gamedb1] = []; finalvar[:gamedb2] = []; finalvar[:gamedb3] = []
			finalvar[:maigamez1] = []; finalvar[:maigamez2] = []

			gamelist.each do |game|
				#if not guest, check if user is in this troika
				if current_user
					game[:TROIKI].each do |troika|
						troika[:MODE1] = false; troika[:MODE2] = false
						if current_user[:username] == troika[:P1]
							if troika[:P1STATUS][0]		##dif down
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 1, gNAME: game[:gameNAME], PRICE: troika[:P1PRICE], P1ADD: 0 } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 1, gNAME: game[:gameNAME] } )
							end
						end
						if current_user[:username] == troika[:P2]
							if troika[:P2STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 1, gNAME: game[:gameNAME], PRICE: troika[:P1PRICE], P1ADD: 0 } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 1, gNAME: game[:gameNAME] } )
							end
						end
						if current_user[:username] == troika[:P3]
							if troika[:P3STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 2, gNAME: game[:gameNAME], PRICE: troika[:P2PRICE], P1ADD: troika[:NOP1ADD0] } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 2, gNAME: game[:gameNAME] } )
							end
						end
						if current_user[:username] == troika[:P4]
							if troika[:P4STATUS][0]
								game[:MODE1] = true; troika[:MODE1] = true
								finalvar[:maigamez1].push( { POSITION: 3, gNAME: game[:gameNAME], PRICE: troika[:P3PRICE], P1ADD: troika[:NOP1ADD1] } )
							else
								game[:MODE2] = true if !game[:MODE1]
								troika[:MODE2] = true if !troika[:MODE1]
								finalvar[:maigamez2].push( { POSITION: 3, gNAME: game[:gameNAME] } )
							end		##dif up
						end
					end
				end
				#shorten maigamez1 game names of they too long
				finalvar[:maigamez1].each {|game| game[:gNAME] = game[:gNAME].truncate(40)}
				#fill 3 variables for each game type
				finalvar[:gamedb1].push(game.except(:PRICE, :TYPE)) if game[:TYPE] == 1 || game[:TYPE] == 0
				finalvar[:gamedb2].push(game.except(:PRICE, :TYPE)) if game[:TYPE] == 2
				finalvar[:gamedb3].push(game.except(:PRICE, :TYPE)) if game[:TYPE] == 3
			end
			
			render json: finalvar

		end

		def troikopoiskp3
			#decode shit
			troikopoisk = URI.unescape(Base64.decode64(params[:input])).strip.downcase
			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40
				zapislist = @@userdb[:PS4db].find( { _id: troikopoisk }, projection: { DATE: 0 } ).to_a
				if zapislist[0]
					zapislist[0][:poiskwin] = true
					render json: zapislist[0]
				else
					render json: { poiskfail: true }
				end
			else 
				render json: { poiskfail: true }
			end
		end 

		def prezaipsp3
			#decode shit
			code = Base64.decode64(params[:bagakruta]).split("~") #0 - position, 1 - gameCODE
			#if viever registered, count his fb
			if current_user && code[1]
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if feedback[0] && feedback[0][:fbB]
					if feedback[0][:fbB] > 0
						fbcount = 777
					else
						fbcount = feedback[0][:fbG]
					end
				end

				if fbcount < 10 && code[0] == "1"
					render json: { piadin: true }
				elsif fbcount == 777
					render json: { banned: true }
				else
					#find and count how many times user zaipsalsq
					zcount = 0
					gameuzers = @@userlistdb[:uListP3].find( _id: code[1] ).to_a	##dif
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
							prezaips[0] = prezaips[0].except(:imgLINKHQ)
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

		def zaipsp3
			#decode shit
			code = URI.unescape(Base64.decode64(params[:bagatrolit])).split("~") #0 - position, 1 - userNAME, 2 - gameCODE, 3 - gameNAME
			#do stuff if user is actual user and code is correct
			if current_user && code[3] && current_user[:username] == code[1]
				#count feedbacks and how many zaips, again!
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				if feedback[0] && feedback[0][:fbB]
					if feedback[0][:fbB] > 0
						fbcount = 777
					else
						fbcount = feedback[0][:fbG]
					end
				end
				if ( fbcount < 10 && code[0] == "1" ) || fbcount == 777
					render json: { zaipsfail: true }
				else
					#find and count how many times user zaipsalsq
					zcount = 0
					gameuzers = @@userlistdb[:uListP3].find( _id: code[2] ).to_a	##dif
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
						@@userlistdb[:uListP3].find_one_and_update( { _id: code[2] }, { "$push" => push }, { upsert: true } )	##dif
						zaips = { winrars: true, position: code[0], gameNAME: code[3].force_encoding('UTF-8') }
						#destroy cache
						@@cache[:cachep3].drop()	##dif

						render json: zaips

						#add message to chat
						PostCreator.create(
							Discourse.system_user,
							skip_validations: true,
							topic_id: 21,
							raw: current_user[:username]+" записался на позицию П"+code[0]+" совместной покупки "+code[3]
						)
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
			addstuff = {}
			addstuff = params
			addstuff[:RESULT] = []
			feedbacks = []
			if current_user && current_user[:username] == 'H1tomaru' && addstuff[:GAME] && addstuff[:STRING]
				addstuff[:NEWSTRING] = addstuff[:STRING].gsub(/^.*П1 - .*$/,"").gsub(/^.* - /,"").gsub(/^.* ---> /,"").gsub(/(\()(.*)(\))/,"").gsub(/^\s*[\r\n]/,"").split("\n")
				#check if were doing p3 or p4
				if (addstuff[:STRING].include? "П4") && (addstuff[:STRING].exclude? "П3")
					#p4 version
					addstuff[:NEWSTRING].each_slice(4) do |sostav|
						if sostav[0] && sostav[1] && sostav[2] && sostav[3]
							addstuff[:winrarP4] = true
							addstuff[:RESULT].push({ GAME: addstuff[:GAME].strip, Mail: sostav[0].strip, П2: sostav[1].strip, П41: sostav[2].strip, П42: sostav[3].strip})
							@@userdb2[:PS4db].replace_one( { _id: sostav[0].strip }, { _id: sostav[0].strip, GAME: addstuff[:GAME].strip, P2: sostav[1].strip, P41: sostav[2].strip, P42: sostav[3].strip, DATE: Time.now.strftime("%Y.%m.%d") }, { upsert: true } )
							feedbacks.push(sostav[1].strip, sostav[2].strip, sostav[3].strip) if addstuff[:ADDFB]
						end
					end
				else
					#p3 version
					addstuff[:NEWSTRING].each_slice(3) do |sostav|
						if sostav[0] && sostav[1] && sostav[2]
							addstuff[:winrarP3] = true
							addstuff[:RESULT].push({ GAME: addstuff[:GAME].strip, Mail: sostav[0].strip, П2: sostav[1].strip, П3: sostav[2].strip })
							@@userdb2[:PS4db].replace_one( { _id: sostav[0].strip }, {  _id: sostav[0].strip, GAME: addstuff[:GAME].strip, P2: sostav[1].strip, P3: sostav[2].strip, DATE: Time.now.strftime("%Y.%m.%d") }, { upsert: true } )
							feedbacks.push(sostav[1].strip, sostav[2].strip) if addstuff[:ADDFB]
						end
					end
				end
				#add feedback of we're doing it
				if addstuff[:ADDFB] == 'true'
					#delete duplicate users
					feedbacks = feedbacks.uniq
					feedbacks.each do |user|
						#find if user gave feedback already today
						ufb = @@userfb[:userfb].find( { _id: user.downcase } ).to_a
						if ufb[0]
							hasfb = ufb[0][:FEEDBACKS].any? {|h| h[:FEEDBACK] == "Участвовал в четверке на "+addstuff[:GAME].strip+". Всё отлично!" && h[:DATE] == Time.now.strftime("%Y.%m.%d")}
						end
						unless hasfb
							@@userfb2[:userfb].find_one_and_update( { _id: user.downcase }, { "$push" => { 
								FEEDBACKS: {
									FEEDBACK: "Участвовал в четверке на "+addstuff[:GAME].strip+". Всё отлично!",
									pNAME: "MrBug",
									DATE: Time.now.strftime("%Y.%m.%d"),
									SCORE: 1,
									DELETED: false
								}
							} }, { upsert: true } )
						end
					end
				end
				render json: addstuff
			end
		end

		def feedbacks
			feedbacks = { MENOSHO: true, fbG: 0, fbB: 0, fbN: 0 }
			#page owners and users with negative feedbacks cant do feedbacks! 
			if current_user
				viewerfb = @@userfb[:userfb].find( { _id: current_user[:username].downcase } ).to_a
				feedbacks[:MENOSHO] = false if (viewerfb[0] && viewerfb[0][:fbB] && viewerfb[0][:fbB] > 0) || current_user[:username].downcase == params[:username].downcase
			end

			#find feedbacks from my database
			userfb = @@userfb[:userfb].find( { _id: params[:username].downcase } ).to_a

			#if found, go
			if userfb[0]
				#remove duplicates
				@@userfb2[:userfb].find_one_and_update( { _id: params[:username].downcase }, userfb[0] ) if userfb[0][:FEEDBACKS].uniq!
				#count it and check if numbers match
				userfb[0][:FEEDBACKS].each do |fb|
					( feedbacks[:fbG] = feedbacks[:fbG] + fb[:SCORE]; fb[:COLOR] = 'bggr' ) if fb[:SCORE] > 0
					( feedbacks[:fbB] = feedbacks[:fbB] - fb[:SCORE]; fb[:COLOR] = 'bgred3' ) if fb[:SCORE] < 0
					( feedbacks[:fbN] = feedbacks[:fbN] + 1; fb[:COLOR] = 'bggrey' ) if fb[:SCORE] == 0
				end
				#update db with correct values if needed
				if not userfb[0][:fbG] && userfb[0][:fbB] && userfb[0][:fbN] && userfb[0][:fbG] == feedbacks[:fbG] && userfb[0][:fbB] == feedbacks[:fbB] && userfb[0][:fbN] == feedbacks[:fbN]
					@@userfb2[:userfb].find_one_and_update( { _id: params[:username].downcase }, { "$set": { fbG: feedbacks[:fbG], fbB: feedbacks[:fbB], fbN: feedbacks[:fbN] } } )
				end
				#save final variable
				feedbacks[:FEEDBACKS] = userfb[0][:FEEDBACKS].reverse.each_slice(50)
				#do paginations
				feedbacks[:PAGES] = [*1..(userfb[0][:FEEDBACKS].length / 50.0).ceil]
			end

			render json: feedbacks
		end
		
		def zafeedback
			#decode shit
			fedbacks = URI.unescape(Base64.decode64(params[:fedbakibaki])).split("~") #0 - score, 1 - otziv
			#page owners, guests and users with negative feedbacks cant do feedbacks! also cant do short or very long feedbacks
			if current_user && fedbacks.length == 2 && current_user[:username].downcase != params[:username].downcase
				#find if user gave feedback already today
				ufb = @@userfb[:userfb].find( { _id: params[:username].downcase } ).to_a
				if ufb[0]
					fedbacks[2] = ufb[0][:FEEDBACKS].any? {|h| h[:pNAME] == current_user[:username] && h[:DATE] == Time.now.strftime("%Y.%m.%d")}
				end
				if fedbacks[2] && current_user[:username] != 'MrBug'
					render json: { gavas: true }
				else
				fedbacks[0] = fedbacks[0].to_i
				fedbacks[0] = 1 if fedbacks[0] == 1
				fedbacks[0] = 0 if fedbacks[0] == 2
				fedbacks[0] = -1 if fedbacks[0] == 3
				@@userfb2[:userfb].find_one_and_update( { _id: params[:username].downcase }, { "$push" => { 
					FEEDBACKS: {
						FEEDBACK: fedbacks[1].strip,
						pNAME: current_user[:username],
						DATE: Time.now.strftime("%Y.%m.%d"),
						SCORE: fedbacks[0],
						DELETED: false
					}
				} }, { upsert: true } )
				render json: { winrars: true }
				end
			else
				render json: { fail: true }
			end
		end

		def rentagama
			rentagamez = @@rentadb[:rentagadb].find().to_a
			finalrenta = { rentaGAMEZ: [], rentaGAMEZ1: [], rentaGAMEZ2: [], rentaGAMEZ3: [] }
			count = [0,0,0,0,0]
			rentagamez.each do |games|
				gTYPE = [false,false,false,false]
				count[0] = count[0] + 1
				( gTYPE[0] = true; count[1] = count[1] + 1 ) if games[:GTYPE] == 1
				( gTYPE[1] = true; count[2] = count[2] + 1 ) if games[:GTYPE] == 2
				( gTYPE[2] = true; count[3] = count[3] + 1 ) if games[:GTYPE] == 3
				( gTYPE[3] = true; count[4] = count[4] + 1 ) if games[:GTYPE] == 4
				games[:GITEMS].each do |game|
					finalrenta[:rentaGAMEZ].push( {
						GNAME: games[:_id], GPIC: games[:GPIC], GCOMMENT: games[:GCOMMENT],
						TYPE1: gTYPE[0], TYPE2: gTYPE[1], TYPE3: gTYPE[2], TYPE4: gTYPE[3],
						GNEW: games[:GNEW], POSITION: game[:POSITION], PRICE: game[:PRICE],
						STATUS: game[:STATUS], LINE: game[:LINE]
					} )
					finalrenta[:rentaGAMEZ1].push( {
						GNAME: games[:_id], GPIC: games[:GPIC], GCOMMENT: games[:GCOMMENT],
						TYPE1: gTYPE[0], TYPE2: gTYPE[1], TYPE3: gTYPE[2], TYPE4: gTYPE[3],
						GNEW: games[:GNEW], POSITION: game[:POSITION], PRICE: game[:PRICE],
						STATUS: game[:STATUS], LINE: game[:LINE]
					} ) if games[:GTYPE] == 1
					finalrenta[:rentaGAMEZ2].push( {
						GNAME: games[:_id], GPIC: games[:GPIC], GCOMMENT: games[:GCOMMENT],
						TYPE1: gTYPE[0], TYPE2: gTYPE[1], TYPE3: gTYPE[2], TYPE4: gTYPE[3],
						GNEW: games[:GNEW], POSITION: game[:POSITION], PRICE: game[:PRICE],
						STATUS: game[:STATUS], LINE: game[:LINE]
					} ) if games[:GTYPE] == 2 || games[:GTYPE] == 3
					finalrenta[:rentaGAMEZ3].push( {
						GNAME: games[:_id], GPIC: games[:GPIC], GCOMMENT: games[:GCOMMENT],
						TYPE1: gTYPE[0], TYPE2: gTYPE[1], TYPE3: gTYPE[2], TYPE4: gTYPE[3],
						GNEW: games[:GNEW], POSITION: game[:POSITION], PRICE: game[:PRICE],
						STATUS: game[:STATUS], LINE: game[:LINE]
					} ) if games[:GTYPE] == 4
				end
			end
			#sort this shit
			finalrenta[:rentaGAMEZ].sort_by! { |k| [-k[:GNEW], k[:GNAME].downcase] }
			finalrenta[:rentaGAMEZ1].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }
			finalrenta[:rentaGAMEZ2].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }
			finalrenta[:rentaGAMEZ3].sort_by! { |k| [-k[:PRICE][0..2].to_i, k[:GNAME].downcase] }

			finalrenta[:count] = count

			render json: finalrenta 
		end

	end

end
