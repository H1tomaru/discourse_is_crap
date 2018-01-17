# name: MrBug-TroikiPoisk
# version: 9.9.1
# authors: MrBug

after_initialize do

  require_dependency "application_controller"

  Discourse::Application.routes.append do
    get '/home' => 'custom#index'
    get '/home/page' => 'try#index'
    get '/mrbug' => 'mrbug#index'
  end

   class ::CustomController < ActionController::Base
  	include CurrentUser
    def index
   		if (current_user)
   			redirect_to('/')
			else
				redirect_to('/home/page')
			end
    end
  end

  class ::TryController < ::ApplicationController
    def index
      render nothing:true
    end
  end
	
  class ::MrBugController < ActionController::Base
    def index
      render nothing:true
    end
  end
  
end
