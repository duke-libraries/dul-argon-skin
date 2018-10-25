# frozen_string_literal: true
require 'dul_argon_skin'

DulArgonSkin.configure do |config|
  # Configs unique to local skin, separate from TrlnArgon
  config.request_base_url = ENV['REQUEST_BASE_URL']
  config.dul_home_url = ENV['DUL_HOME_URL']
end
