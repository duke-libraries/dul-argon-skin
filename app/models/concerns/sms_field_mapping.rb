# frozen_string_literal: true

# Overrides TRLN Argon behavior

module SmsFieldMapping
  extend ActiveSupport::Concern

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
