# frozen_string_literal: true

# Module for SolrDocument adding methods related to integration
# with DUL Requests System (requests.library.duke.edu) and
# ILLiad for Requests from TRLN partners.

module RequestItem
  extend ActiveSupport::Concern

  def request_item_url
    base = DulArgonSkin.request_base_url
    [base, 'item', stripped_id(id)].join('/')
  end

  def duke_requestable?
    duke_owned? && physical_item?
  end

  def trln_requestable?
    trln_partner_owned? && physical_item?
  end

  def illiad_request_url_default
    [DulArgonSkin.illiad_dul_base_url, illiad_request_params].join('?')
  end

  def illiad_request_params
    params = illiad_request_params_fixed.merge(illiad_request_params_variable)
    params.to_query
  end

  private

  def stripped_id(id)
    id.sub('DUKE', '')
  end

  def duke_owned?
    record_owner == 'duke'
  end

  def trln_partner_owned?
    record_owner.in?(%w[unc ncsu nccu])
  end

  def physical_item?
    fetch(TrlnArgon::Fields::ACCESS_TYPE, []).include?('At the Library')
  end

  # These values are consistent, no matter the item or the home library's
  # ILLiad instance
  def illiad_request_params_fixed
    {
      'Value': 'GenericRequestTRLNLoan',
      'genre': 'TRLNbook',
      'RequestType': 'null',
      'form': '20',
      'Action': '10',
      'IlliadForm': 'Logon',
      'CitedPages': 'TRLN'
    }
  end

  def illiad_request_params_variable
    {
      'Location': item_url_absolute,
      'LoanTitle': fetch(TrlnArgon::Fields::TITLE_MAIN, ''),
      'ESPNumber': oclc_number,
      'ISSN': isbn_number.first,
      'LoanEdition': edition,
      'LoanPublisher': imprint_main_for_header_display,
      'LoanAuthor': statement_of_responsibility
    }
  end

  def item_url_absolute
    [
      TrlnArgon::Engine.configuration.root_url.chomp('/'),
      Rails.application.routes.url_helpers\
           .trln_solr_document_url(self, only_path: true)
    ].join
  end
end
