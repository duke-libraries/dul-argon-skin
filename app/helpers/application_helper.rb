# frozen_string_literal: true

module ApplicationHelper
  def git_branch_info
    `git rev-parse --abbrev-ref HEAD`
  end

  # rubocop:disable Style/SafeNavigation
  def search_session_includes_ajax_request?(current_search_session = nil)
    current_search_session &&
      current_search_session.respond_to?(:query_params) &&
      current_search_session.query_params.fetch('format', nil).present? &&
      %w[json xml].include?(current_search_session.query_params
                                                  .fetch('format', ''))
  end

  def search_session_includes_catalog_controller?(current_search_session = nil)
    current_search_session &&
      current_search_session.respond_to?(:query_params) &&
      %w[catalog trln].include?(current_search_session.query_params
                                                      .fetch(:controller, ''))
  end
  # rubocop:enable Style/SafeNavigation
end
