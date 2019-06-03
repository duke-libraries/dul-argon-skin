# frozen_string_literal: true

module RequestDigitizationHelper
  def link_to_request_digitization(options = {})
    document = options.fetch(:document, nil)
    return unless show_request_digitization_link?(document)

    link_to '<i class="glyphicon glyphicon-duplicate" '\
            'aria-hidden="true"></i> '\
            "#{I18n.t('trln_argon.show.request_digitization')}".html_safe,
            request_digitization_url(document),
            target: '_blank'
  end

  private

  def request_digitization_params(document)
    { 'Title' => document.fetch(TrlnArgon::Fields::TITLE_MAIN,
                                'title unknown'),
      'Author' => document.names.first.to_h.fetch(:name, ''),
      'Published' => document.fetch(TrlnArgon::Fields::PUBLICATION_YEAR,
                                    'publication year unknown'),
      'SystemID' => strip_duke_id_prefix(document: document) }
  end

  def request_digitization_url(document)
    request_digitization_url_template.expand(
      'query' => request_digitization_params(document)
    ).to_s
  end

  def request_digitization_url_template
    Addressable::Template.new(DulArgonSkin.request_digitization_url)
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def show_request_digitization_link?(document)
    DulArgonSkin.request_digitization_url.present? &&
      document.present? &&
      document.record_owner == 'duke' &&
      display_items?(document: document) &&
      meets_publication_year_requirement?(document) &&
      meets_resource_type_requirement?(document) &&
      meets_location_requirement?(document)
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def meets_location_requirement?(document)
    loc_b_codes = document.holdings.keys
    loc_n_codes = document.holdings.map { |_, v| v.keys }.flatten

    (DulArgonSkin.req_digi_loc_b_codes.split(', ') & loc_b_codes).any? ||
      (DulArgonSkin.req_digi_loc_n_codes.split(', ') & loc_n_codes).any?
  end

  def meets_publication_year_requirement?(document)
    pub_year = document.fetch(TrlnArgon::Fields::PUBLICATION_YEAR, '0')
    pub_year.to_i < Time.now.year - 75
  end

  def meets_resource_type_requirement?(document)
    resource_types = document.fetch(TrlnArgon::Fields::RESOURCE_TYPE, [])
    (resource_types &
    ['Book',
     'Government publication',
     'Music score',
     'Thesis/Dissertation']).any? &&
      !resource_types.include?('Journal, Magazine, or Periodical')
  end
end
