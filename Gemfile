# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'addressable', '~> 2.5'
gem 'better_errors', '2.1.1'
gem 'blacklight', '~> 6.7'
gem 'coffee-rails', '~> 4.2'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'jbuilder', '~> 2.5'
gem 'jquery-rails'
gem 'lcsort', '~> 0.9'
gem 'non-stupid-digest-assets'
gem 'pg'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.0.1'
gem 'sass-rails', '~> 5.0'
gem 'sprockets', '~> 3.7.2'
gem 'trln_argon', git: 'https://github.com/trln/trln_argon'
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
gem 'uglifier', '>= 1.3.0'
gem 'velocityjs-rails'

group :development, :test do
  gem 'byebug', platform: :mri
end

group :development do
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.8'
  gem 'rubocop', '~> 0.58.2'
  gem 'rubocop-rspec'
  gem 'solr_wrapper', '>= 0.3'
end
