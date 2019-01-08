# frozen_string_literal: true
require 'dul_argon_skin'

DulArgonSkin.configure do |config|
  # Configs unique to local skin, separate from TrlnArgon
  config.dul_home_url = ENV['DUL_HOME_URL']
  config.environment_alert = ENV['ENVIRONMENT_ALERT']
  config.google_analytics_debug = ENV['GOOGLE_ANALYTICS_DEBUG']
  config.google_analytics_tracking_id = ENV['GOOGLE_ANALYTICS_TRACKING_ID']
  config.illiad_dul_base_url = ENV['ILLIAD_DUL_BASE_URL']
  config.illiad_law_base_url = ENV['ILLIAD_LAW_BASE_URL']
  config.illiad_ford_base_url = ENV['ILLIAD_FORD_BASE_URL']
  config.illiad_med_base_url = ENV['ILLIAD_MED_BASE_URL']
  config.map_location_service_url = ENV['MAP_LOCATION_SERVICE_URL']
  config.online_loc_b_codes = ENV['ONLINE_LOC_B_CODES'].split(', ')
  config.online_loc_n_codes = ENV['ONLINE_LOC_N_CODES'].split(', ')
  config.report_missing_item_url = ENV['REPORT_MISSING_ITEM_URL']
  config.request_base_url = ENV['REQUEST_BASE_URL']
end
