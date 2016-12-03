require "pry-byebug"

source_paths.unshift File.expand_path(File.dirname(__FILE__))

run "rm Gemfile"
copy_file "Gemfile", "Gemfile"
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
  # == Rspec ==
  generate("rspec:install")
  generate("bootstrap:install static")
  generate("simple_form:install --bootstrap")
  rake "haml:erb2haml"

  # activate eager loading of support dir
  gsub_file "spec/rails_helper.rb", "# Dir[Rails" do |match|
    "Dir[Rails"
  end

  directory "files/app",    "app",    resursive: true
  directory "files/spec",   "spec",   resursive: true
  # ==

  # seedbank
  directory "seeds", "db/seeds"
  run "rm db/seeds.rb"

  run "bundle exec rubocop -a" # your rails belongs to us

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
