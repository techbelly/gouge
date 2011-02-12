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
