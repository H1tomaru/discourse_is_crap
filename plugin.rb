# name: MrBug-TroikiPoisk
# version: 9.9.1
# authors: MrBug

gem 'mongo', "9.9.9"

after_initialize do
	
	gamedb = Mongo::Connection.new("localhost", 33775).db("AutoZ_gameDB")
	auth = gamedb.authenticate("troiko_user", "47TTGLRLR3")
	gamedb.collection_names.each { |name| puts name }

	Discourse::Application.routes.append do
		get '/MrBug' => 'mrbug#show'
	end

	class ::MrbugController < ::ApplicationController

		include CurrentUser

		def show
			render nothing:true
		end 

	end
  
end
