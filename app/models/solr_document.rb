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

  include TrlnArgon::SolrDocument
  include TrlnArgon::ItemDeserializer

  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Email)

  SolrDocument.use_extension(TrlnArgon::DocumentExtensions::Sms)

  use_extension(Blacklight::Document::DublinCore)
end
