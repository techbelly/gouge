# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{gouge}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ben Griffiths"]
  s.date = %q{2011-02-14}
  s.default_executable = %q{gouge}
  s.email = %q{bengriffiths@gmail.com}
  s.executables = ["gouge"]
  s.extra_rdoc_files = ["README"]
  s.files = ["bin/gouge", "lib/gouge/application/app.rb", "lib/gouge/application/views/scrape.erb", "lib/gouge/scraper.rb", "lib/gouge/tasks/rake.rb", "lib/gouge/utils.rb", "lib/gouge.rb", "README"]
  s.homepage = %q{https://github.com/techbelly/gouge}
  s.rdoc_options = ["--main", "README"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{What this thing does}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 0"])
      s.add_runtime_dependency(%q<rake>, [">= 0"])
      s.add_runtime_dependency(%q<activerecord>, [">= 0"])
      s.add_runtime_dependency(%q<delayed_job>, [">= 0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
    else
      s.add_dependency(%q<sinatra>, [">= 0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<activerecord>, [">= 0"])
      s.add_dependency(%q<delayed_job>, [">= 0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<activerecord>, [">= 0"])
    s.add_dependency(%q<delayed_job>, [">= 0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
  end
end
