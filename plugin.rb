# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'
require 'base64'

register_asset 'stylesheets/MrBug.scss'

after_initialize do

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
		get '/MrBug/troikopoisk/:miloakka' => 'mrbug#troikopoisk'
	end

	class ::MrbugController < ::ApplicationController

	#	include CurrentUser

		db = Mongo::Client.new([ '93.171.216.230:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')

		def show
			glist = @@gamedb[:gameDB].find({ _id: { $nin: [ '_encodedcodes' ] } }).sort( { TYPE: 1, DATE: 1, gameNAME: 1 } ).to_a
			ulist = @@userlistdb[:uListP4].find().to_a
			feedbacks = @@userfb[:userfb].find().to_a
			qzlist = @@gamedb[:gameDB].find({ _id: '_encodedcodes' }).to_a
			#if viever registered, count his fb, if guest, just lol
				
			glist.each {
				
			}
			
			
			render json: { currentuser: CurrentUser, gamelist: gamelist, userlist: userlist, feedbacks: feedbacks }
		end
		
		
		def troikopoisk
			#decode shit
			troikopoisk = Base64.decode64(params[:miloakka]).strip.downcase
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
