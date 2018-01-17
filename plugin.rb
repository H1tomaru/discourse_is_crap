# name: MrBug-TroikiPoisk
# version: 9.9.1
# authors: MrBug

after_initialize do

	require_dependency "application_controller"

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
