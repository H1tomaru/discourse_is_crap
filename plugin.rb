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
			#other variables
			finalvar = {}
			finalvar[:qzstuff] = false

			#if viever registered, count his fb
			if current_user
				fbcount = 0
				feedbacks = @@userfb[:userfb].find( { UID: current_user[:username] } ).to_a
				feedbacks.each do |feedback|
					if feedback[:SCORE] < 0
						fbcount = 0
						break
					end
					fbcount = fbcount + feedback[:SCORE]
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
			gameDB.each do |game|
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
				
				users = userDB.find{ |h| h['_id'] == game[:_id] }

				game[:USERS] = users
			end
			finalvar[:gamedb] = gameDB

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
				feedbacks = @@userfb[:userfb].find( { UID: current_user[:username] } ).to_a
				feedbacks.each do |feedback|
					if feedback[:SCORE] < 0
						fbcount = 777
						break
					end
					fbcount = fbcount + feedback[:SCORE]
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
				feedbacks = @@userfb[:userfb].find( { UID: current_user[:username] } ).to_a
				feedbacks.each do |feedback|
					if feedback[:SCORE] < 0
						fbcount = 777
						break
					end
					fbcount = fbcount + feedback[:SCORE]
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

