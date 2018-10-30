# frozen_string_literal: true
require 'dul_argon_skin'

DulArgonSkin.configure do |config|
  # Configs unique to local skin, separate from TrlnArgon
  config.request_base_url = ENV['REQUEST_BASE_URL']
  config.map_location_service_url = ENV['MAP_LOCATION_SERVICE_URL']
  config.dul_home_url = ENV['DUL_HOME_URL']
  config.google_analytics_tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
  config.google_analytics_debug = ENV['GOOGLE_ANALYTICS_DEBUG']
end
