source_paths.unshift File.expand_path(File.dirname(__FILE__)) + "/files"

# Do not ask to overwrite
run "rm Gemfile"
copy_file "Gemfile", "Gemfile"

after_bundle do
  # Fixes sqlite exception
  run "rm config/database.yml"
  directory "config", "config", resursive: true

  generate("simple_form:install --bootstrap")
  generate("rspec:install")
  generate("bootstrap:install static")
  gsub_file("Gemfile", "# gem \"spring\"") { |_| "gem \"spring\"" } # uncomment spring after generators finished

  run "rm -rf README.md test app/views/layouts/application.html.erb"

  copy_file ".rubocop.yml", ".rubocop.yml"
  copy_file "docker-compose.yml", "docker-compose.yml"

  directory "app", "app", resursive: true
  directory "docker", "docker", resursive: true
  directory "seeds", "db/seeds"
  directory "spec/support", "spec/support", resursive: true

  gsub_file("spec/rails_helper.rb", "# Dir[Rails") { |_| "Dir[Rails" } # activate eager loading of support dir
  gsub_file("app/assets/javascripts/application.js", "\n//= require turbolinks") { |_| "" } # remove turbolinks

  environment "config.autoload_paths << Rails.root.join('lib').to_s" # Make rails autoload lib files by default
  route "root to: \"example#index\""

  run "bundle exec rubocop -a" # your rails belongs to us
  git :init
end
