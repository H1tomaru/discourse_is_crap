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
	end

	class ::MrbugController < ::ApplicationController
		
		db = Mongo::Client.new([ '93.171.216.230:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')
		
		def show
			#db variables
			ulist = @@userlistdb[:uListP4].find().to_a
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

			render json: { finalvar: finalvar }
		end

		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(URI.unescape(params[:miloakka])).strip.downcase
			#do stuff when finding acc or not
			if troikopoisk.length > 20 && troikopoisk.length < 40
				zapislist = @@userdb[:PS4db].find( { _id: troikopoisk }, projection: { DATE: 0 } ).to_a
				if zapislist[0]
					render json: { poiskwin: true, troikopoisk: zapislist[0] }
				else
					render json: { poiskwin: false }
				end
			else 
				render json: { poiskwin: false }
			end
		end 

	end
end

