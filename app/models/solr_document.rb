# frozen_string_literal: true

require 'trln_argon'
class SolrDocument
  include Blacklight::Solr::Document

  # This is needed so that SolrDocument.find will work correctly
  # from the Rails console with our Solr configuration.
  # Otherwise, it tries to use the non-existent document request handler.
  SolrDocument.repository.blacklight_config.document_solr_path = :document
  SolrDocument.repository.blacklight_config.document_solr_request_handler = nil
  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Ris)
  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::OpenurlCtxKev)
  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Email)
  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Sms)
  SolrDocument.use_extension(Blacklight::Document::DublinCore)

  include TrlnArgon::SolrDocument
  include TrlnArgon::ItemDeserializer
  include DulArgonSkin::RequestItem

  def rubenstein_record?
    holdings.key?('SCL')
  end

  def sms_field_mapping
    @sms_field_mapping ||= {
      title: proc do
               truncate(self[TrlnArgon::Fields::TITLE_MAIN].to_s, length: 50)
             end,
      location: proc { holdings_to_text },
      link_to_record: proc { sms_field_mapping_link }
    }
  end

  def sms_field_mapping_link
    TrlnArgon::Engine.configuration.root_url.chomp('/') +
      Rails.application.routes.url_helpers.solr_document_path(self)
  end
end
