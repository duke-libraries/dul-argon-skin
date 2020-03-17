# frozen_string_literal: true

module RequestDigitizationHelper
  def show_request_digitization_link?(_document)
    # Temporarily disable request digitization link.
    false
    # DulArgonSkin.request_digitization_url.present? &&
    #   document.present? &&
    #   document.record_owner == 'duke' &&
    #   display_items?(document: document) &&
    #   meets_publication_year_requirement?(document) &&
    #   meets_resource_type_requirement?(document) &&
    #   meets_location_requirement?(document) &&
    #   meets_physical_media_requirement?(document)
  end

  def request_digitization_url(document)
    request_digitization_url_template.expand(
      'query' => request_digitization_params(document)
    ).to_s
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

  def request_digitization_url_template
    Addressable::Template.new(DulArgonSkin.request_digitization_url)
  end

  def meets_location_requirement?(document)
    loc_b_codes = document.holdings.keys
    loc_n_codes = document.holdings.map { |_, v| v.keys }.flatten

    (DulArgonSkin.req_digi_loc_b_codes & loc_b_codes).any? ||
      (DulArgonSkin.req_digi_loc_n_codes & loc_n_codes).any?
  end

  def meets_publication_year_requirement?(document)
    pub_year = document.fetch(TrlnArgon::Fields::PUBLICATION_YEAR, '0')
    pub_year.to_i < Time.now.year - 75
  end

  def meets_physical_media_requirement?(document)
    physical_media_types = document.fetch(TrlnArgon::Fields::PHYSICAL_MEDIA, [])
    physical_media_types.include?('Print') &&
      physical_media_types.select { |m| m.match?(/Microform/) }.none?
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
