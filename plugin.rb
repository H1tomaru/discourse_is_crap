# name: MrBug-TroikiPoisk
# version: 9.9.1
# authors: MrBug

#after_initialize do
#  Discourse::Application.routes.append do
#    get "/mrbug" => "mrbug#show"
#    get "/zaips" => "zaips#show"
#    post "/oops" => "oops#add"
#    post "/troikopoisk" => "troikopoisk#find"
#    get 'users/:username/route' => 'users#show', constraints: {username: USERNAME_ROUTE_FORMAT}
#  end
#end

#Discourse::Application.routes.append do
#  get '/admin/plugins/mrbug' => 'admin/plugins#index'
#end

after_initialize do

  require_dependency "application_controller"

  Discourse::Application.routes.append do
    get '/home' => 'custom#index'
    get '/home/page' => 'try#index'
    get '/MrBug' => 'MrBug#index'
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
	
  class ::MrBugController < ::ApplicationController
    def index
      #code here lol
    end
  end

end
