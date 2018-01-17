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

end
