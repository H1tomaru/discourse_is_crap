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

# name: Discourse Sitemap
# about:
# version: 1.1
# authors: DiscourseHosting.com, vinothkannans 
# url: https://github.com/discoursehosting/discourse-sitemap

PLUGIN_NAME = "discourse-sitemap".freeze

after_initialize do

  module ::DiscourseSitemap
    class Engine < ::Rails::Engine
      engine_name PLUGIN_NAME
      isolate_namespace DiscourseSitemap
    end
  end

  require_dependency "application_controller"

  class DiscourseSitemap::SitemapController < ::ApplicationController
    layout false
    skip_before_action :preload_json, :check_xhr

    def index
      raise ActionController::RoutingError.new('Not Found') unless SiteSetting.sitemap_enabled
      prepend_view_path "plugins/discourse_is_crap/app/views/"

      sitemap_size = SiteSetting.sitemap_topics_per_page
      @output = Rails.cache.fetch("sitemap/index/#{sitemap_size}", expires_in: 24.hours) do
        count = topics_query.count
        @size = count / sitemap_size
        @size += 1 if count % sitemap_size > 0
        @lastmod = Time.now
        1.upto(@size) do |i|
          Rails.cache.delete("sitemap/#{i}")
        end
        if @size > 1
          render :index, content_type: 'text/xml; charset=UTF-8'
        else
          sitemap(1)
        end
      end
      render :plain => @output, content_type: 'text/xml; charset=UTF-8' unless performed?
    end

    def sitemap(page)
      sitemap_size = SiteSetting.sitemap_topics_per_page
      offset = (page - 1) * sitemap_size

      @output = Rails.cache.fetch("sitemap/#{page}/#{sitemap_size}", expires_in: 24.hours) do
        @topics = Array.new
        topics_query.limit(sitemap_size).offset(offset).pluck(:id, :slug, :last_posted_at, :updated_at).each do |t|
          t[2] = t[3] if t[2].nil?
          @topics.push t
        end
        render :default, content_type: 'text/xml; charset=UTF-8'
      end
      render :plain => @output, content_type: 'text/xml; charset=UTF-8' unless performed?
      return @output
    end

  end

  Discourse::Application.routes.prepend do
    mount ::DiscourseSitemap::Engine, at: "/sitemap"
  end

  DiscourseSitemap::Engine.routes.draw do
    get ".xml" => "sitemap#index"
  end

end
