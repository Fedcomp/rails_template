require "pry-byebug"

source_paths.unshift File.expand_path(File.dirname(__FILE__))

run "rm Gemfile"
copy_file "Gemfile", "Gemfile"

run "rm README.md"
run "rm -rf test"

# StyleGuide
copy_file ".rubocop.yml", ".rubocop.yml"
run "bundle exec rubocop -a" # your rails belongs to us

# Make rails autoload lib files by default
environment "config.autoload_paths << Rails.root.join('lib').to_s"

after_bundle do
  # == Rspec ==
  generate("rspec:install")

  # activate eager loading of support dir
  gsub_file "spec/rails_helper.rb", "# Dir[Rails" do |match|
    "Dir[Rails"
  end

  directory "rspec/support", "spec/support"
  # ==

  # seedbank
  directory "seeds", "db/seeds"
  run "rm db/seeds.rb"

  git :init
  git add: "."
  git commit: %Q{ -m 'Initial commit' }
end
