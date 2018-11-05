# frozen_string_literal: true

module GoogleAnalyticsHelper
  # Google Analytics Custom Dimensions.
  # These are logged with every pageview and custom Event. They are
  # selectable as dimensions in Analytics reports alongside standard
  # fields tracked by Google.
  # https://developers.google.com/analytics/devguides/collection/gtagjs/setting-values

  def ga_catalog_scope
    case controller.controller_name
    when 'catalog' then 'Duke'
    when 'trln' then 'TRLN'
    else 'Neutral'
    end
  end

  # rubocop:disable Metrics/MethodLength
  def ga_page_type
    if search_results_page_zero_results?
      'No Results Page'
    elsif search_results_page_with_results?
      'Search Results Page'
    elsif advanced_search_page?
      'Advanced Search Page'
    elsif home_page?
      'Homepage'
    elsif item_show_page?
      'Item Page'
    else
      'Other Page'
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def search_results_page_zero_results?
    search_results_page? && response_has_zero_results?
  end

  def search_results_page_with_results?
    search_results_page? && response_has_results?
  end

  def advanced_search_page?
    controller.controller_name == 'advanced'
  end

  def home_page?
    catalog_or_trln_controller? && controller.action_name == 'index' \
      && respond_to?(:has_search_parameters?) && !has_search_parameters?
  end

  def item_show_page?
    catalog_or_trln_controller? && controller.action_name == 'show'
  end

  def search_results_page?
    catalog_or_trln_controller? && controller.action_name == 'index' \
      && respond_to?(:has_search_parameters?) && has_search_parameters?
  end

  def catalog_or_trln_controller?
    controller.controller_name.in?(%w[catalog trln])
  end

  def response_has_results?
    @response.present? && @response.respond_to?(:total) \
      && @response.total.positive?
  end

  def response_has_zero_results?
    @response.present? && @response.respond_to?(:total) \
      && @response.total.zero?
  end
end
