# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

require 'mongo'

register_asset 'stylesheets/MrBug.scss'

after_initialize do

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
		get '/MrBug/troikopoisk/:ebatmiloakka' => 'mrbug#troikopoisk'
	end

	class ::MrbugController < ::ApplicationController

	#	include CurrentUser

		db = Mongo::Client.new([ '93.171.216.230:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
		@@gamedb = db.use('AutoZ_gameDB')
		@@userlistdb = db.use('AutoZ_gameZ')
		@@userdb = db.use('userdb')
		@@userfb = db.use('userfb')

		def show
			gamelist = @@gamedb[:gameDB].find().limit( 10 )
			userlist = @@userlistdb[:uListP4].find().limit( 10 )
			feedbacks = @@userfb[:userfb].find().limit( 10 )
			render json: { name: "donut", description: "delicious!", gamelist: gamelist, userlist: userlist, feedbacks: feedbacks }
		end
		
		
		def troikopoisk
			zapislist = @@userdb[:PS4db].find().limit( 10 )
			render json: { poiskwin: "false", troikopoisk: "email" }
		end 

	end
end
