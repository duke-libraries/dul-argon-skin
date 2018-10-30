# frozen_string_literal: true

module DulArgonSkin
  module Configurable
    extend ActiveSupport::Concern
    included do
      # Request System base URL.
      mattr_accessor :request_base_url do
        ENV['REQUEST_BASE_URL'] ||= 'https://requests.library.duke.edu'
      end
      mattr_accessor :map_location_service_url do
        ENV['MAP_LOCATION_SERVICE_URL'] ||= 'https://library.duke.edu/locguide/mapinfo'
      end
      mattr_accessor :dul_home_url do
        ENV['DUL_HOME_URL'] ||= 'https://library.duke.edu'
      end

      # If tracking ID is present, activate Google Analytics tracking
      # and use that ID.
      mattr_accessor :google_analytics_tracking_id do
        ENV['GOOGLE_ANALYTICS_TRACKING_ID'] ||= ''
      end

      # If 'true', output the data being sent to Google Analytics in
      # the browser console.
      mattr_accessor :google_analytics_debug do
        ENV['GOOGLE_ANALYTICS_DEBUG'] ||= 'false'
      end
    end
    module ClassMethods
      def configure
        yield self
      end
    end
  end
end
