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
  include DulArgonSkin::SmsFieldMapping

  def rubenstein_record?
    holdings.key?('SCL')
  end
end
