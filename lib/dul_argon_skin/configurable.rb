# frozen_string_literal: true

module DulArgonSkin
  module Configurable
    extend ActiveSupport::Concern
    included do
      mattr_accessor :dul_home_url do
        ENV['DUL_HOME_URL'] ||= 'https://library.duke.edu'
      end

      # If present this string will display in a banner alert
      # at the top of each page to indicate which environment
      # the application is running in. Banner alert NOT shown if blank.
      mattr_accessor :environment_alert do
        ENV['ENVIRONMENT_ALERT'] ||= ''
      end

      # If 'true', output the data being sent to Google Analytics in
      # the browser console.
      mattr_accessor :google_analytics_debug do
        ENV['GOOGLE_ANALYTICS_DEBUG'] ||= 'false'
      end

      # If tracking ID is present, activate Google Analytics tracking
      # and use that ID.
      mattr_accessor :google_analytics_tracking_id do
        ENV['GOOGLE_ANALYTICS_TRACKING_ID'] ||= ''
      end

      mattr_accessor :map_location_service_url do
        ENV['MAP_LOCATION_SERVICE_URL'] ||= 'https://library.duke.edu/locguide/mapinfo'
      end

      # Request System base URL.
      mattr_accessor :request_base_url do
        ENV['REQUEST_BASE_URL'] ||= 'https://requests.library.duke.edu'
      end
    end
    module ClassMethods
      def configure
        yield self
      end
    end
  end
end
