# frozen_string_literal: true

module SolrDocumentBehavior
  extend ActiveSupport::Concern

  included do
    send(:include, Blacklight::Solr::Document)
    # This is needed so that find will work correctly
    # from the Rails console with our Solr configuration.
    # Otherwise, it tries to use the non-existent document request handler.
    repository.blacklight_config.document_solr_path = :document
    repository.blacklight_config.document_solr_request_handler = nil
    use_extension(TrlnArgon::DocumentExtensions::Ris)
    use_extension(TrlnArgon::DocumentExtensions::OpenurlCtxKev)
    use_extension(TrlnArgon::DocumentExtensions::Email)
    use_extension(TrlnArgon::DocumentExtensions::Sms)
    use_extension(Blacklight::Document::DublinCore)

    send(:include, TrlnArgon::SolrDocument)
    send(:include, TrlnArgon::ItemDeserializer)
    send(:include, RequestItem)
    send(:include, SmsFieldMapping)
    send(:include, Syndetics)

    def urls
      @urls ||= deserialized_urls.each do |url|
        url[:href] = fix_old_proxy(url[:href])
      end
    end

    def fix_old_proxy(url)
      url.gsub('//proxy.lib.duke.edu/', '//login.proxy.lib.duke.edu/')
    end
  end

  def rubenstein_record?
    holdings.key?('SCL')
  end
end
