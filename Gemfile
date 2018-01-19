source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'haml'
gem 'pg'
gem 'bcrypt'
gem 'sucker_punch'
gem 'bootstrap', '~> 4.0.0.beta3'
gem 'jquery-rails'
gem "bootstrap_form",
    git: "https://github.com/bootstrap-ruby/rails-bootstrap-forms.git",
    branch: "master"
gem 'figaro'
gem "font-awesome-rails"
gem 'faker'

source 'https://rails-assets.org' do
  gem 'rails-assets-particles.js'
end

gem 'rails', '~> 5.1.4'
gem 'puma', '~> 3.7'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem 'rspec-rails'
  gem 'fabrication'
  gem 'orderly'
  gem 'rspec_junit_formatter'
end

group :test do
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'capybara-email'
end

group :development do
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'guard-rspec'
  gem 'spring-commands-rspec'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
