# name: MrBug-TroikiPoisk
# version: 9.9.1
# authors: MrBug

after_initialize do

  require_dependency "application_controller"

  Discourse::Application.routes.append do
    get '/home' => 'mrbug#test1'
    get '/home/page' => 'mrbug#test2'
    get '/mrbug' => 'mrbug#show'
  end

  class ::MrbugController < ActionController::Base

  	include CurrentUser

    def test1
	if (current_user)
		redirect_to('/')
	else
	redirect_to('/home/page')
	end
    end

    def test2
      render nothing:true
    end
	  
    def show
      render nothing:true
    end 

  end
  
end
