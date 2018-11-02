# frozen_string_literal: true
require 'dul_argon_skin'

DulArgonSkin.configure do |config|
  # Configs unique to local skin, separate from TrlnArgon
  config.dul_home_url = ENV['DUL_HOME_URL']
  config.environment_alert = ENV['ENVIRONMENT_ALERT']
  config.google_analytics_debug = ENV['GOOGLE_ANALYTICS_DEBUG']
  config.google_analytics_tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
  config.map_location_service_url = ENV['MAP_LOCATION_SERVICE_URL']
  config.request_base_url = ENV['REQUEST_BASE_URL']
end
