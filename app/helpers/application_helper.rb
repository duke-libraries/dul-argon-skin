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

  # Hathitrust links can be displayed if the record:
  # 1) Has an OCLC Number
  # 2) Is NOT a Rubenstein record
  # 3) Is NOT a Serial OR
  #      it is a Gov Doc OR
  #      it was published before 1924
  def show_hathitrust_link_if_available?(document)
    document.oclc_number.present? &&
      !document.rubenstein_record? &&
      (!document.fetch(TrlnArgon::Fields::RESOURCE_TYPE, [])
                .include?('Journal, Magazine, or Periodical') ||
      document.fetch(TrlnArgon::Fields::RESOURCE_TYPE, [])
              .include?('Government publication') ||
      document.fetch(TrlnArgon::Fields::PUBLICATION_YEAR, '9999').to_i < 1924)
  end
  # rubocop:enable Style/SafeNavigation

  def strip_duke_id_prefix(options = {})
    doc = options.fetch(:document, nil)
    return unless doc
    doc.fetch(TrlnArgon::Fields::LOCAL_ID, '').sub('DUKE', '')
  end

  def add_bookplate_span(options = {})
    options.fetch(:value, []).map do |v|
      if v.match(bookplate_regex)
        content_tag(:span, v, class: 'dul-bookplate')
      else
        v
      end
    end.join('<br/>').html_safe
  end

  def add_donor_span(options = {})
    options.fetch(:value, []).map do |v|
      content_tag(:span, v, class: 'dul-bookplate')
    end.join('<br/>').html_safe
  end

  private

  def bookplate_regex
    /^(in\smemory\sof\s|
       gift\sof\s|
       in\shonor\sof\s|
       the\sconservation\sof\s|
       in\sremembrance\sof\s|
       in\srecognition\sof\s|
       dul\sexceptional\sstaff\smember\s|
       duke\suniversity\slibraries\shonors\s)/xi
  end
end
