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

add_admin_route 'purple_tentacle.title', 'purple-tentacle'

Discourse::Application.routes.append do
  get '/admin/plugins/purple-tentacle' => 'admin/plugins#index'
end
