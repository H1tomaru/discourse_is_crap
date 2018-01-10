# name: MrBug-TroikiPoisk
# version: 9.9.9
# authors: MrBug

after_initialize do

  Discourse::Application.routes.append do
    get "mrbug" => "mrbug#index"
    get "zaips" => "zaips#index"
    post "oops" => "oops#add"
    post "troikopoisk" => "troikopoisk#find"
  end

end
