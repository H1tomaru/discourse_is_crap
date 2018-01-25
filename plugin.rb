# name: MrBug-TroikiPoisk
# version: 9.9.9
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
		
		firstName: "Trek",
 		lastName: "Glowacki"

		include CurrentUser

		def show
			firstName: "Trek2",
	  		lastName: "Glowacki2"
			render json: { name: "donut", description: "delicious!" }
		end 

	end

end
