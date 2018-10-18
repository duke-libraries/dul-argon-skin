# frozen_string_literal: true

module DulArgonSkin
  module Configurable
    extend ActiveSupport::Concern
    included do
      # Request System base URL
      mattr_accessor :request_base_url do
        ENV['REQUEST_BASE_URL'] ||= 'https://requests.library.duke.edu'
      end
      mattr_accessor :request_base_url do
        ENV['MAP_LOCATION_SERVICE_URL'] ||= 'https://library.duke.edu/locguide/mapinfo'
      end
    end
    module ClassMethods
      def configure
        yield self
      end
    end
  end
end
