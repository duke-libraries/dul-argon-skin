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

  private

  # fetches enhanced data (SyndeticsData object) and yields it to a block,
  # if it's available.
  # NOTE: Quick patch of Argon to prevent slow page loads due to Syndetics.
  # rubocop:disable MethodLength
  def enhanced_data(client = 'trlnet')
    params = get_params(client, 'XML.XML')
    return nil unless params
    begin
      response = Faraday::Connection.new.get(build_syndetics_query(params)) do |request|
        request.options.timeout = 3
        request.options.open_timeout = 2
      end
      data = TrlnArgon::SyndeticsData.new(Nokogiri::XML(response.body))
    rescue StandardError => e
      Rails.logger.warn('unable to fetch syndetics data for '\
                        "#{fetch('id', 'unknown document')} "\
                        "-- #{params}: #{e}")
    end
    yield data if block_given? && !data.nil?
    data
  end
end
