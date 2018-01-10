# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

register_asset 'javascripts/discourse/templates/mrbug.hbs'

after_initialize do
  Discourse::Application.routes.append do
    get "/mrbug" => "mrbug#show"
    get "/zaips" => "zaips#show"
    post "/oops" => "oops#add"
    post "/troikopoisk" => "troikopoisk#find"
#   get 'users/:username/route' => 'users#show', constraints: {username: USERNAME_ROUTE_FORMAT}
  end
end
