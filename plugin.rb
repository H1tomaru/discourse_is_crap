# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

#gems...
gem 'bson', "4.3.0"
gem 'mongo', "2.5.0"

#require_dependency "application_controller" //wtf is this crap?

require 'mongo'

#connect to database
gamedb = Mongo::Client.new('mongodb://troiko_user:47TTGLRLR3@91.134.133.218:33775/AutoZ_gameDB?authSource=admin')
#	puts gamedb.collections
#	test = gamedb.collections

#some retarded crap where route is... binded... to some function... with #subfuction... 
Discourse::Application.routes.append do
	get '/MrBug' => 'mrbug#show'
end

#actual program...
class ::MrbugController < ::ApplicationController

#	include CurrentUser #dont even know what it is...
	#really really actual program...
	def show
		render json: { name: "donut", description: "delicious!" }
	end 

end
