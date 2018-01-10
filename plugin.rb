# name: MrBug-TroikiPoisk
# version: 7.7.7
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

after_initialize do

  module ::TroikiPoisk
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace TroikiPoisk
    end
  end

  require_dependency "application_controller"

  class TroikiPoisk::TroikiPoiskController < ::ApplicationController
    layout false
    skip_before_action :preload_json, :check_xhr
    
    def index
      raise ActionController::RoutingError.new('Not Found') unless SiteSetting.sitemap_enabled
      prepend_view_path "plugins/discourse-sitemap/app/views/"

      sitemap_size = SiteSetting.sitemap_topics_per_page
      render :plain => "MrBug", content_type: 'text/xml; charset=UTF-8' unless performed?
    end

  end

  Discourse::Application.routes.prepend do
    mount ::TroikiPoisk::Engine, at: "/mrbug"
  end

  TroikiPoisk::Engine.routes.draw do
    get "/" => "mrbug#index"
  end

end
