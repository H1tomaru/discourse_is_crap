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
		get '/MrBug/troikopoisk/:miloakka' => 'mrbug#troikopoisk'
		get '/MrBug/prezaips/:bagakruta' => 'mrbug#prezaips'
		get '/MrBug/zaips/:bagatrolit' => 'mrbug#zaips'
	end

	class ::MrbugController < ::ApplicationController
		
		db = Mongo::Client.new([ '93.171.216.230:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')
		
		def show
			#get all user feedbacks
			userFB = @@userfb[:userfb].find().to_a
			#other variables
			finalvar = {}
			finalvar[:qzstuff] = false
			priceSTEP = 50

			#if viever registered, count his fb
			if current_user
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username] } ).to_a
				if feedback[0]
					fbcount = feedback[:fbG] if feedback[:fbB] == 0
				end
				finalvar[:qzstuff] = true if fbcount >= 10
			end

			finalvar[:qzstuff] = true
			#get all games from db and make a qz variable
			if finalvar[:qzstuff]
				glist = @@gamedb[:gameDB].find().sort( { gameNAME: 1 } ).to_a
				finalvar[:qzlist] = []
				glist.each do |game|
					finalvar[:qzlist].push( [ game[:_id] , game[:gameNAME] ] )
				end
			end
			#get all type 123 games
			gameDB = @@gamedb[:gameDB].find( { TYPE: { "$in": [1,2,3] } }, projection: { imgLINKHQ: 0 } ).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a
			#get all users 2 list
			userDB = @@userlistdb[:uListP4].find().to_a
			#start a loop for every game to display
			gameDB1 = gameDB2 = gameDB3 = []
			gameDB.each do |game|
				#somevariables
				p1NO = p2NO = p3NO = price1DISPLAY = price2DISPLAY = price3DISPLAY = 0
				#create display prices
				if game[:PRICE] > 0
					p4PDOWN1 = p4PDOWN2 = p4PDOWN3 = 0
					p4PDOWN1 = game[:P4PDOWN1] if game[:P4PDOWN1]
					p4PDOWN2 = game[:P4PDOWN2] if game[:P4PDOWN2]
					p4PDOWN3 = game[:P4PDOWN3] if game[:P4PDOWN3]
					
					game[:P4PRICE3] = (game[:PRICE] * 0.75 / 100).floor * 100 / 2
					game[:P4PRICE1] = ((game[:PRICE] - 2 * game[:P4PRICE3]) * 0.3 / 50).ceil * 50
					game[:P4PRICE2] = game[:PRICE] - 2 * game[:P4PRICE3] - game[:P4PRICE1]
					
					p4UP = [100,200,0]
					p4UP = [100,250,50] if game[:PRICE] > 5000
					p4UP = [0,50,50] if game[:PRICE] < 2700

					game[:P4PRICE1] = game[:P4PRICE1] - p4PDOWN1 + p4UP[0]
					game[:P4PRICE2] = game[:P4PRICE2] - p4PDOWN2 + p4UP[1]
					game[:P4PRICE3] = game[:P4PRICE3] - p4PDOWN3 + p4UP[2]
				else
					game[:P4PRICE1] = game[:P4PRICE2] = game[:P4PRICE3] = 0
				end
				#see if we have users to display
				users = userDB.find{ |h| h['_id'] == game[:_id] }
				#do stuff if we do
				if users
					#somevariables
					priceUP = 0
					#find how many p1 p2 p3 we have, and how many troikas to display
					p1NO = users[:P1].length if users[:P1]
					p2NO = users[:P2].length if users[:P2]
					p3NO = users[:P4].length / 2 if users[:P4] #fix because 2 P4 per troika

					game[:TROIKI] = []
					for i in 0..[p1NO, p2NO, p3NO.ceil].max-1 #get how many troikas, roundup p4 number cos theres 2 per troika
						#tons of variables for everything
						p1 = p2 = p3 = p4 = account = comment = ''
						p1STATUS = p2STATUS = p3STATUS = p4STATUS = p1PRICE = p2PRICE = p3PRICE = p1PDOWN = p2PDOWN = p3PDOWN = 0
						p1FEEDBACK = p2FEEDBACK = p3FEEDBACK = p4FEEDBACK = { GOOD: 0, BAD: 0, NEUTRAL: 0, PERCENT: 0 }
						p1TAKEN = p2TAKEN = p3TAKEN = p4TAKEN = p1FBred = p2FBred = p3FBred = p4FBred = false
						#fill user info
						if users[:P1] && users[:P1][i]
							p1 = users[:P1][i][:NAME].strip
							p1STATUS = users[:P1][i][:STAT]
						end
						if users[:P2] && users[:P2][i]
							p1 = users[:P2][i][:NAME].strip
							p1STATUS = users[:P2][i][:STAT]
						end
						if users[:P4] && users[:P4][2*i]
							p1 = users[:P4][2*i][:NAME].strip
							p1STATUS = users[:P4][2*i][:STAT]
						end
						if users[:P4] && users[:P4][2*i+1]
							p1 = users[:P4][2*i+1][:NAME].strip
							p1STATUS = users[:P4][2*i+1][:STAT]
						end
						#template variables for when p1 p2 p3 p4 are taken
						p1TAKEN = true; p1 = '' if p1 == -55
						p2TAKEN = true; p2 = '' if p2 == -55
						p3TAKEN = true; p3 = '' if p3 == -55
						p4TAKEN = true; p4 = '' if p4 == -55
						#find feedback for users
						if p1
							feedbackp1 = userFB.find{ |h| h['_id'] == p1 }
							if feedbackp1
								p1FEEDBACK[:GOOD] = feedbackp1[:fbG]
								p1FEEDBACK[:BAD] = feedbackp1[:fbB]
								p1FEEDBACK[:NEUTRAL] = feedbackp1[:fbN]
							end
						end
						if p2
							feedbackp2 = userFB.find{ |h| h['_id'] == p2 }
							if feedbackp2
								p2FEEDBACK[:GOOD] = feedbackp2[:fbG]
								p2FEEDBACK[:BAD] = feedbackp2[:fbB]
								p2FEEDBACK[:NEUTRAL] = feedbackp2[:fbN]
							end
						end
						if p3
							feedbackp3 = userFB.find{ |h| h['_id'] == p3 }
							if feedbackp3
								p3FEEDBACK[:GOOD] = feedbackp3[:fbG]
								p3FEEDBACK[:BAD] = feedbackp3[:fbB]
								p3FEEDBACK[:NEUTRAL] = feedbackp3[:fbN]
							end
						end
						if p4
							feedbackp4 = userFB.find{ |h| h['_id'] == p4 }
							if feedbackp4
								p4FEEDBACK[:GOOD] = feedbackp4[:fbG]
								p4FEEDBACK[:BAD] = feedbackp4[:fbB]
								p4FEEDBACK[:NEUTRAL] = feedbackp4[:fbN]
							end
						end
						#find feedback percentage
						p1FEEDBACK[:PERCENT] = (p1FEEDBACK[:GOOD]/(p1FEEDBACK[:GOOD] + p1FEEDBACK[:BAD]) * 100).floor if p1FEEDBACK[:GOOD] > 0
						p2FEEDBACK[:PERCENT] = (p2FEEDBACK[:GOOD]/(p2FEEDBACK[:GOOD] + p2FEEDBACK[:BAD]) * 100).floor if p2FEEDBACK[:GOOD] > 0
						p3FEEDBACK[:PERCENT] = (p3FEEDBACK[:GOOD]/(p3FEEDBACK[:GOOD] + p3FEEDBACK[:BAD]) * 100).floor if p3FEEDBACK[:GOOD] > 0
						p4FEEDBACK[:PERCENT] = (p4FEEDBACK[:GOOD]/(p4FEEDBACK[:GOOD] + p4FEEDBACK[:BAD]) * 100).floor if p4FEEDBACK[:GOOD] > 0
						#create comment and account variable if they exist
						if users[i+1]
							account = users[i+1][:ACCOUNT] if users[i+1][:ACCOUNT]
							comment = users[i+1][:COMMENT] if users[i+1][:COMMENT]
						end
						#calculate prices
						if game[:PRICE] > 0
							priceUP = priceSTEP * (i / 10).floor
							#get current pricedown
							if users[i+1]
								p1PDOWN = users[i+1][:PDOWN1] if users[i+1][:PDOWN1]
								p2PDOWN = users[i+1][:PDOWN2] if users[i+1][:PDOWN2]
								p3PDOWN = users[i+1][:PDOWN3] if users[i+1][:PDOWN3]
							end
							#create current troika prices
							p1PRICE = game[:P4PRICE1] - p1PDOWN + priceUP
							p2PRICE = game[:P4PRICE2] - p2PDOWN + priceUP
							p3PRICE = game[:P4PRICE3] - p3PDOWN + priceUP
							#set price to -10 if its x100
							p1PRICE = p1PRICE - 10 if p1PRICE/100 == (p1PRICE/100).ceil
							p2PRICE = p2PRICE - 10 if p2PRICE/100 == (p2PRICE/100).ceil
							p3PRICE = p3PRICE - 10 if p3PRICE/100 == (p3PRICE/100).ceil
						end
						#template again, is feedback green or red?
						p1FBred = true if p1FEEDBACK[:PERCENT] < 100
						p2FBred = true if p2FEEDBACK[:PERCENT] < 100
						p3FBred = true if p3FEEDBACK[:PERCENT] < 100
						p4FBred = true if p4FEEDBACK[:PERCENT] < 100
						#create final variable
						game[:TROIKI].push( {
							P1: p1, P1FEEDBACK: p1FEEDBACK, P2: p2, P2FEEDBACK: p2FEEDBACK,
							P3: p3, P3FEEDBACK: p3FEEDBACK, P4: p4, P4FEEDBACK: p4FEEDBACK,
							P1PRICE: p1PRICE, P2PRICE: p2PRICE, P3PRICE: p3PRICE, ACCOUNT: account, COMMENT: comment,
							P1TAKEN: p1TAKEN, P2TAKEN: p2TAKEN, P3TAKEN: p3TAKEN, P4TAKEN: p4TAKEN,
							P1FBred: p1FBred, P2FBred: p2FBred, P3FBred: p3FBred, P4FBred: p4FBred,
							P1STATUS: p1STATUS, P2STATUS: p2STATUS, P3STATUS: p3STATUS, P4STATUS: p4STATUS
						} )
						#if current troika has any free position, save its price to display on button, if not saved one already
						price1DISPLAY = p1PRICE if !p1 && !price1DISPLAY
						price2DISPLAY = p2PRICE if !p2 && !price2DISPLAY
						price3DISPLAY = p3PRICE if (!p3 || !p4) && !price3DISPLAY
					end
					#remove this game users form userdb variable
					userDB.delete_if{ |h| h['_id'] == game[:_id] }
				end
				#set display users number
				game[:P1NO] = p1NO
				game[:P2NO] = p2NO
				game[:P3NO] = p3NO
				#set the current display price, depending on amount of troek, if price is zero, don't touch it
				if game[:PRICE] > 0
					if price1DISPLAY
						game[:P4PRICE1] = price1DISPLAY
					else
						game[:P4PRICE1] = game[:P4PRICE1] + priceSTEP * (p1NO / 10).floor
					end
					if price2DISPLAY
						game[:P4PRICE2] = price2DISPLAY
					else
						game[:P4PRICE2] = game[:P4PRICE2] + priceSTEP * (p2NO / 10).floor
					end
					if price3DISPLAY
						game[:P4PRICE3] = price3DISPLAY
					else
						game[:P4PRICE3] = game[:P4PRICE3] + priceSTEP * (p3NO / 10).floor
					end
				end
				#set price to -10 if its x100
				game[:P4PRICE1] = game[:P4PRICE1] - 10 if game[:P4PRICE1]/100 == (game[:P4PRICE1]/100).ceil
				game[:P4PRICE2] = game[:P4PRICE2] - 10 if game[:P4PRICE2]/100 == (game[:P4PRICE2]/100).ceil
				game[:P4PRICE3] = game[:P4PRICE3] - 10 if game[:P4PRICE3]/100 == (game[:P4PRICE3]/100).ceil
				gameDB1.push(game.except!(:PRICE, :TYPE)) if game[:TYPE] == 1
				gameDB2.push(game.except!(:PRICE, :TYPE)) if game[:TYPE] == 2
				gameDB3.push(game.except!(:PRICE, :TYPE)) if game[:TYPE] == 3
			end
			finalvar[:gamedb1] = gameDB1
			finalvar[:gamedb2] = gameDB2
			finalvar[:gamedb3] = gameDB3

			render json: finalvar
		end

		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(URI.unescape(params[:miloakka])).strip.downcase
			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40
				zapislist = @@userdb[:PS4db].find( { _id: troikopoisk }, projection: { DATE: 0 } ).to_a
				if zapislist[0]
					zapislist[0][:poiskwin] = true
					render json: zapislist[0]
				else
					render json: { poiskwin: false }
				end
			else 
				render json: { poiskwin: false }
			end
		end 
		
		def prezaips
			#decode shit
			code = Base64.decode64(URI.unescape(params[:bagakruta])).split("~") #0 - position, 1 - gameCODE
			#if viever registered, count his fb
			if current_user && code[1]
				fbcount = 0
				feedback = @@userfb[:userfb].find( { _id: current_user[:username] } ).to_a
				if feedback[0]
					if feedback[:fbB] > 0
						fbcount = 777
					else
						fbcount = feedback[:fbG]
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
			code = Base64.decode64(URI.unescape(params[:bagatrolit])).split("~") #0 - position, 1 - userNAME, 2 - gameCODE, 3 - gameNAME
			#do stuff if user is actual user and code is correct
			if current_user && code[3] && current_user[:username] == code[1]
				#count feedbacks and how many zaips, again!
				fbcount = 0
				feedback = @@userfb[:userfb].find( { UID: current_user[:username] } ).to_a
				if feedback
					if feedback[:fbB] > 0
						fbcount = 777
					else
						fbcount = feedback[:fbG]
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
						zaips = { winrars: true, position: code[0], gameNAME: code[3] }
						render json: zaips
						#add message to chat
					end
				end
			else
				render json: { zaipsfail: true }
			end
		end 

	end
end

