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
		
		include CurrentUser

		def show
			user_obj = User.pluck(:username, :trust_level).map{|p| {username: p[0], trust_level: p[1]}}
			test_obj = [{username: "PaddingtonBrown", trust_level: 7}]
			combined_obj = user_obj + test_obj
			render :json => combined_obj
#			render json: { name: "donut", description: "delicious!" }
		end 

	end

end
