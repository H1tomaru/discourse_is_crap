# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

register_asset 'stylesheets/MrBug.scss'

#require_dependency "application_controller"

require 'mongo'

after_initialize do

	db = Mongo::Client.new([ '93.171.216.230:33775' ], user: 'troiko_user', password: '47TTGLRLR3' )
	gamedb = db.use('AutoZ_gameDB')
	userlistdb = db.use('AutoZ_gameZ')
	userdb = db.use('userdb')
	userfb = db.use('userfb')
	#gamedb = Mongo::Client.new('mongodb://troiko_user:47TTGLRLR3@93.171.216.230:33775/AutoZ_gameDB?authSource=admin')
	#	puts gamedb.collections
	#	test = gamedb.collections

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
	end

	class ::MrbugController < ::ApplicationController

	#	include CurrentUser

		def show
			gamelist = gamedb[:gameDB].find().limit( 10 )
			userlist = userlistdb[:ulistP4].find().limit( 10 )
			zapislist = userdb[:PS4db].find().limit( 10 )
			feedbacks = userfb[:userfb].find().limit( 10 )
			render json: { name: "donut", description: "delicious!", gamelist: gamelist, userlist: userlist, zapislist: zapislist, feedbacks: feedbacks }
		end 

	end
end
