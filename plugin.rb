# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

register_asset 'stylesheets/MrBug.scss'

#require_dependency "application_controller"

require 'mongo'

after_initialize do

	gamedb = Mongo::Client.new('mongodb://troiko_user:47TTGLRLR3@93.171.216.230:33775/AutoZ_gameDB?authSource=admin')
	#	puts gamedb.collections
	#	test = gamedb.collections

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
	end

	class ::MrbugController < ::ApplicationController

	#	include CurrentUser

		def show
			render json: { name: "donut", description: "delicious!" }
		end 

	end
end
