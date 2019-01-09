# frozen_string_literal: true

module DulArgonSkin
  module Configurable
    extend ActiveSupport::Concern
    # rubocop:disable Metrics/BlockLength
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

      # ILLiad base URLs for DUL & professional school libraries.
      # =========================================================
      mattr_accessor :illiad_dul_base_url do
        ENV['ILLIAD_DUL_BASE_URL'] ||= 'https://duke-illiad-oclc-org.proxy.lib.duke.edu/illiad/NDD/illiad.dll'
      end

      mattr_accessor :illiad_law_base_url do
        ENV['ILLIAD_LAW_BASE_URL'] ||= 'https://duke-illiad-oclc-org.proxy.lib.duke.edu/illiad/NDL/illiad.dll'
      end

      mattr_accessor :illiad_ford_base_url do
        ENV['ILLIAD_FORD_BASE_URL'] ||= 'https://duke-illiad-oclc-org.proxy.lib.duke.edu/illiad/NDB/illiad.dll'
      end

      mattr_accessor :illiad_med_base_url do
        ENV['ILLIAD_MED_BASE_URL'] ||= 'https://illiad.mclibrary.duke.edu/illiad.dll'
      end

      mattr_accessor :map_location_service_url do
        ENV['MAP_LOCATION_SERVICE_URL'] ||= 'https://library.duke.edu/locguide/mapinfo'
      end

      # Broad and narrow location codes that indicate online items.
      # =========================================================
      mattr_accessor :online_loc_b_codes do
        ENV['ONLINE_LOC_B_CODES'] ||= 'ONLINE, DUKIR'
      end

      mattr_accessor :online_loc_n_codes do
        ENV['ONLINE_LOC_N_CODES'] ||= 'FRDE, database, LINRE, PEI'
      end

      # Report missing item URL template
      mattr_accessor :report_missing_item_url do
        ENV['REPORT_MISSING_ITEM_URL'] ||=
          'https://duke.qualtrics.com/jfe/form/SV_71J91hwAk1B5YkR/{?query*}'
      end

      # Request System base URL.
      mattr_accessor :request_base_url do
        ENV['REQUEST_BASE_URL'] ||= 'https://requests.library.duke.edu'
      end

      # Search tips URL.
      mattr_accessor :search_tips_url do
        ENV['SEARCH_TIPS_URL'] ||= 'https://library.duke.edu/using/catalog-search-tips'
      end
    end
    # rubocop:enable Metrics/BlockLength
    module ClassMethods
      def configure
        yield self
      end
    end
  end
end
