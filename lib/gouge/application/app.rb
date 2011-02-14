require 'sinatra'
require 'active_record'
require 'delayed_job'

class Gouge::App < Sinatra::Base
  
  set :static, true
  set :public, File.expand_path('..',__FILE__)
  set :views, File.expand_path('../views',__FILE__)
  
  configure do
    Delayed::Worker.backend = :active_record
    config = YAML::load(File.open('config/database.yml'))
    environment = Sinatra::Application.environment.to_s
    ActiveRecord::Base.logger = Logger.new($stdout)
    ActiveRecord::Base.establish_connection(
      config[environment]
    )
  end
  
  get '/' do
    erb :scrape
  end
  
  post '/scraper' do
    name = params['classname']
    clazz = Object.const_get name
    clazz.create! {}
  end
end

