# name: MrBug-TroikiPoisk
# version: 9.9.1
# authors: MrBug

gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

after_initialize do
	
	require 'mongo'
	
	gamedb = Mongo::Client.new('mongodb://troiko_user:47TTGLRLR3@91.134.133.218:33775/AutoZ_gameDB?authSource=admin')
#	puts gamedb.collections
#	test = gamedb.collections

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
	end

	class ::MrbugController < ::ApplicationController

		include CurrentUser

		def show
			render html: "<strong>Not Found</strong>"
#			render json: {test:"We fail"}
		end 

	end
  
end
