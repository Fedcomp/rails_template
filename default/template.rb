require "pry-byebug"

source_paths.unshift File.expand_path(File.dirname(__FILE__)) + "/files"

run "rm Gemfile"

# docker
copy_file "docker-compose.yml", "docker-compose.yml"
copy_file "Dockerfile", "Dockerfile"
directory "docker", "docker", resursive: true

copy_file "Gemfile", "Gemfile"

# remove turbolinks
gsub_file "app/assets/javascripts/application.js",
          "\n//= require turbolinks" do |match|
            ""
          end

run "rm README.md"
run "rm -rf test"

# StyleGuide
copy_file ".rubocop.yml", ".rubocop.yml"

# Make rails autoload lib files by default
environment "config.autoload_paths << Rails.root.join('lib').to_s"

route "root to: \"example#index\""

after_bundle do
  # Specified gem sqlite for database exception ...
  run "rm config/database.yml"
  directory "config", "config", resursive: true

  # == Rspec ==
  generate("rspec:install")
  generate("bootstrap:install static")
  generate("simple_form:install --bootstrap")
  # rake "haml:erb2haml"

  # activate eager loading of support dir
  gsub_file "spec/rails_helper.rb", "# Dir[Rails" do |match|
    "Dir[Rails"
  end
  # uncomment spring after generators
  gsub_file "Gemfile", "# gem \"spring\"" do |match|
    "gem \"spring\""
  end

  directory "app",    "app",    resursive: true
  directory "spec",   "spec",   resursive: true
  # ==

  run "rm app/views/layouts/application.html.erb"

  # seedbank
  directory "seeds", "db/seeds"
  run "rm db/seeds.rb"

  run "bundle exec rubocop -a" # your rails belongs to us

  git :init
end
