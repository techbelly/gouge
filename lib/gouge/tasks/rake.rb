require 'active_record'
require 'delayed_job'

desc "One time task to setup on Heroku"
namespace :gouge do
  task :create do
    sh "git init"
    sh "git commit -a -m'First commit of webapp'"
    sh "heroku create"
    sh "git push heroku master"
    sh "heroku open"
  end
end

namespace :jobs do
  desc "Start a delayed_job worker."
  task :work  do
    Delayed::Worker.backend = :active_record
    Delayed::Worker.new(:min_priority => ENV['MIN_PRIORITY'], :max_priority => ENV['MAX_PRIORITY']).start
  end
end

namespace :db do
  task :migrate do
    ActiveRecord::Migrator.migrate(
      File.expand_path('../../../../db/migrate',__FILE__),  
      ENV["VERSION"] ? ENV["VERSION"].to_i : nil
    )
  end
end
