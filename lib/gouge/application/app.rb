require 'sinatra'

class Gouge < Sinatra::Base
  
  set :static, true
  set :public, File.expand_path('..',__FILE__)
  set :views, File.expand_path('../views',__FILE__)
  
  get '/' do
    erb :scrape
  end
end

